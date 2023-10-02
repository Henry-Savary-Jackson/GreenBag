unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Data.Win.ADODB, Data.DB,
  System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.ComCtrls, ActiveX,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, PngImage,
  System.Win.ComObj, ADOInt,
  dateutils, stdctrls, System.JSON, System.Threading, REST.Types,
  Data.Bind.Components, REST.Client, IdServerIOHandler, Data.Bind.ObjectScope,
  JOSE.Core.JWT,
  JOSE.Core.Builder, JOSE.Types.Bytes;

type
  TDataModule1 = class(TDataModule)
    tmCheckCartExpired: TTimer;
    procedure tmCheckCartExpiredTimer(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
    // stores these global vairables for all screen\
    username: string;
    usertype: string;
    jwtToken: string;
    // sotres the user's current shopping cart

    // used to store the previous form
    // this var is ony changed a few times in the app
    // this is to make sure that pressing back button on Add item screen
    // will go back to the previous screen, as you can access add item screen
    // from either browse items screen or your products screen.
    lastForm: TForm;

  const
    // all the current categories
    categoryList: array [0 .. 5] of string = ('Toileteries', 'Food',
      'Electronics', 'Containers', 'Clothes', 'Other');

  const
    stRevenue = 0;
    stSales = 1;
    stSpending = 2;
    stCF = 3;
    stEU = 4;
    stWU = 5;

  const
    baseUrl = 'https://localhost:8080';

    success = 1;
    // const for passwords

    tooShort = 4;
    noSpecial = 2;
    noNums = 3;
    // consts for cert code
    invalidChar = 5;
    notInFile = 6;

    nums = '0123456789';
    special = '!@#$%^&*()-+=.,<>?\/|';


    // USER METHODS

    function userInfo(username: string): tADODataSet;

    procedure addFunds(username, token: string; amount: double);

    function obtainStats(username, token: string; statType: integer;
      DateBegin, DateEnd: tDateTime): tADODataSet;

    function getNumProducts(username: string): integer;

    function getProducts(username: string; iMin, iMax: integer): tADODataSet;

    function loadProfilePicture(username: string): tMemoryStream;

    procedure setProfilePicture(username, token: string;
      imageStream: tMemoryStream);

    function loadItemImage(itemid: string): tMemoryStream;


    // ACCOUNT METHODS

    procedure Login(username, password: string);

    procedure SignUp(username, email, password, usertype, homeAddress,
      certificationcode: string; imgPfp: tImage);

    procedure changePassword(username, oldpassword, newpassword: string);

    procedure Changeusername(oldusername, newusername, token: string);


    // SHOPPING CART METHODS

    function CreateUserCart(buyerusername, token: string): string;

    procedure CancelCart(buyerusername, token: string);

    procedure CheckoutCart(buyerusername, token: string);

    procedure addToCart(buyerusername: string; itemid, token: string;
      quantity: integer);

    function getCartItems(buyerusername, token: string): tADODataSet;

    procedure removeFromCart(ShoppingCartItemID, token, buyerusername: string);


    // ITEM METHODS

    function viewItem(itemid: string): tADODataSet;

    procedure updateItem(itemid, Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token: string; Image: tImage = nil);

    procedure insertItem(Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token: string; Image: tImage = nil);

    procedure deleteItem(itemid, token: string);

    procedure sendRating(username, itemid, token: string; rating: integer);

    procedure setItemImage(itemid, token: string; Image: tImage);

    // SEARCHING METHODS

    function getSearchResults(searchQuery: string; categories: TList<string>;
      CFRange, EURange, WURange, resultRange, ratingRange: array of integer)
      : tADODataSet;

    // APPLICATION METHODS

    function getApplications(iMin, iMax: integer; token: string): tADODataSet;

    procedure denyApplication(applicationID, reason, token: string);

    procedure acceptApplication(applicationID, token: string);

    procedure sendApplication(email, explanation: string);

    function getApplication(applicationID, token: string): tADODataSet;

    // UTILITIES

    function ifthenreturn(condition: boolean;
      trueValue, falsevalue: variant): variant;

    function securePassword(password: string): integer;

    procedure loadImageFromFile(img: tImage; window: TForm);

    function ResizeImage(Image: tImage; width, height: integer): tpngImage;

    function getUserTypeFromToken(token: string): string;


    // WEB UTILITIES

    function sendRequest(url: string; method: trestrequestmethod = rmGET;
      body: TObject = nil; authorization: string = '';
      contentType: TRESTContentType = ctAPPLICATION_JSON;
      queryParams: TList < TPair < String, variant >> = nil): TRESTResponse;

    function responseBodyToDataset(body: string): tADODataSet;

    function getFtTypefromString(s: string): tFieldType;

  end;

var
  DataModule1: TDataModule1;
  warnedUser: boolean;

implementation

uses
  Checkout_u, IpPeerClient;

{$R *.dfm}
// USER'S DETAILS METHODS

// method to send request to api to get a summary of a user's details
function TDataModule1.userInfo(username: string): tADODataSet;
var
  url: string;
  response: TRESTResponse;
begin;

  url := format('%s/users/%s', [baseUrl, username]);

  response := sendRequest(url);
  try

    Result := responseBodyToDataset(response.Content);

    if Result.Fields.FindField('Status') <> nil then
    begin
      showMessage(Result['Status']);
      Exit;
    end;

  finally
    freeandnil(response);
  end;

end;

// increase a given user's balance by a given amount
procedure TDataModule1.addFunds(username, token: string; amount: double);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/funds', [baseUrl, username]);

  body := tJsonObject.Create;
  try

    body.AddPair('Username', username);
    body.AddPair('Funds', TJSONNumber.Create(amount));

    try
      response := sendRequest(url, rmPUT, body, token);

      if response.StatusCode <> 200 then
      begin

        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        responseJson.Free;
      end;

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;

// this table doesn't use StatsTB, as it is unnecessary and full of redundancy
// and calculated fields, so i deleted the table and instead calculated using
// transaction history
function TDataModule1.obtainStats(username, token: string; statType: integer;
  DateBegin, DateEnd: tDateTime): tADODataSet;
var

  url, statTypeString: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
  queryParams: TList<TPair<String, variant>>;

begin;
  // based on stat, convert into
  case statType of
    stRevenue:
      statTypeString := 'REV';
    stSales:
      statTypeString := 'SAL';
    stCF:
      statTypeString := 'CF';
    stSpending:
      statTypeString := 'SPE';
    stEU:
      statTypeString := 'EU';
    stWU:
      statTypeString := 'WU';
  end;

  url := format('%s/users/%s/stats/%s', [baseUrl, username, statTypeString]);

  queryParams := TList < TPair < string, variant >>.Create;

  try
    // specify the range of dates to queyr stats from
    queryParams.Add(TPair<string, variant>.Create('monthBegin',
      FormatDateTime('yyyy-mm-dd', DateBegin)));
    queryParams.Add(TPair<string, variant>.Create('monthEnd',
      FormatDateTime('yyyy-mm-dd', DateEnd)));

    response := sendRequest(url, rmGET, nil, token, ctAPPLICATION_JSON,
      queryParams);
    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      end;

      Result := responseBodyToDataset(response.Content);

    finally

      freeandnil(response);
    end;

  finally
    freeandnil(queryParams);
  end;
end;

// method that calls the api endpoint to figure out the number
function TDataModule1.getNumProducts(username: string): integer;
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin
  //
  url := format('%s/users/%s/products/count', [baseUrl, username]);

  response := sendRequest(url);
  try

    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    try
      if response.StatusCode <> 200 then
      begin

        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

      Result := (responseJson.P['data[0].ProductCount'] as TJSONNumber).AsInt;

    finally
      freeandnil(responseJson);
    end;

  finally
    freeandnil(response);
  end;

end;

// get the all the products made by a particular seller
// NOTE: the  var keyword is a pass by referecne
function TDataModule1.getProducts(username: string; iMin, iMax: integer)
  : tADODataSet;
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
  queryParams: TList<TPair<string, variant>>;
begin

  url := format('%s/users/%s/products', [baseUrl, username]);

  queryParams := TList < TPair < string, variant >>.Create;
  try
    // add the minimum
    queryParams.Add(TPair<string, variant>.Create('indexRange', iMin));
    queryParams.Add(TPair<string, variant>.Create('indexRange', iMax));

    response := sendRequest(url, rmGET, nil, '', ctAPPLICATION_JSON,
      queryParams);
    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

      Result := responseBodyToDataset(response.Content);

    finally
      freeandnil(response);
    end;
  finally
    queryParams.Free;
  end

end;

// get profile picture by username of a user from api as a stream of bytes
function TDataModule1.loadProfilePicture(username: string): tMemoryStream;
var
  url: string;
  responseJson: tJsonObject;

begin
  url := format('%s/users/%s/profileImage', [baseUrl, username]);

  Result := tMemoryStream.Create();
  TDownloadURL.DownloadRawBytes(url, Result);

end;

// use this to send a request to the api to change a username's profile picture
// with a new png image using a tmemorystream
procedure TDataModule1.setProfilePicture(username, token: string;
  imageStream: tMemoryStream);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/users/%s/profileImage', [baseUrl, username]);

  response := sendRequest(url, rmPOST, imageStream, token,
    TRESTContentType.ctIMAGE_PNG);

  try
    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

  finally
    freeandnil(response);
  end;

end;

// download the raw data of an item's image from the api
// and return it as a stream of bytes
function TDataModule1.loadItemImage(itemid: string): tMemoryStream;
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/item/%s/image', [baseUrl, itemid]);

  Result := tMemoryStream.Create();
  TDownloadURL.DownloadRawBytes(url, Result);

end;

// Account Methods

// function used to check credentials entered and login a user if successful
procedure TDataModule1.Login(username, password: string);
var
  url: string;
  body, responseBody: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/login', [baseUrl]);

  try
    body := tJsonObject.Create;

    body.AddPair('Username', username);

    body.AddPair('Password', password);

    response := sendRequest(url, rmPOST, body);
    try

      responseBody := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      try

        if response.StatusCode <> 200 then
        begin
          raise Exception.Create
            ((responseBody.GetValue('error') as tJsonString).Value);
          Exit
        end;

        // get the jwt token from the succsful login attempt
        jwtToken := (responseBody.P['data[0].token'] as tJsonString).Value;
        usertype := (responseBody.P['data[0].UserType'] as tJsonString).Value;
        self.username := username;

      finally
        freeandnil(responseBody);
      end;

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;

// a function used to create a new user in the database and return the new user's userid for use by the program
procedure TDataModule1.SignUp(username, email, password, usertype, homeAddress,
  certificationcode: string; imgPfp: tImage);
var
  url: string;
  response: TRESTResponse;
  bodyJson, responseJson: tJsonObject;
  imageStream: tMemoryStream;
begin

  url := format('%s/signup', [baseUrl]);

  bodyJson := tJsonObject.Create;

  try

    bodyJson.AddPair('Username', username);
    bodyJson.AddPair('Password', password);
    bodyJson.AddPair('UserType', usertype);
    bodyJson.AddPair('HomeAddress', homeAddress);

    if usertype.Equals('SELLER') then
      bodyJson.AddPair('certificationCode', certificationcode);

    response := sendRequest(url, rmPOST, bodyJson);

    try

      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;

      try

        if response.StatusCode <> 200 then
        begin
          raise Exception.Create
            ((responseJson.GetValue('error') as tJsonString).Value);
        end;

        jwtToken := (responseJson.P['data[0].token'] as tJsonString).Value;
        usertype := (responseJson.P['data[0].UserType'] as tJsonString).Value;

        imageStream := tMemoryStream.Create;

        try
          // set the profile picture
          setProfilePicture(username, jwtToken, imageStream);

        finally
          imageStream.Free;
        end;

        self.username := username;

      finally
        freeandnil(responseJson);
      end;

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(bodyJson);
  end;

end;

// sends request to api to change a given user's password
procedure TDataModule1.changePassword(username, oldpassword,
  newpassword: string);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/reset', [baseUrl, username]);

  body := tJsonObject.Create;

  try

    body.AddPair('oldPassword', oldpassword);
    body.AddPair('newPassword', newpassword);

    response := sendRequest(url, rmPUT, body);

    try
      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;

// send request to api to change a given user's username
procedure TDataModule1.Changeusername(oldusername, newusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/change', [baseUrl, oldusername]);

  body := tJsonObject.Create;

  try

    body.AddPair('oldUsername', oldusername);
    body.AddPair('newUsername', newusername);

    response := sendRequest(url, rmPUT, body, token);

    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

      username := newusername;

    finally

      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;


// Shopping Cart Methods

// once the user has checked out a cart or has logged in
// generate a new shopping cart for the user
function TDataModule1.CreateUserCart(buyerusername, token: string): string;
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/users/%s/cart/create', [baseUrl, buyerusername]);

  try
    response := sendRequest(url, rmPOST, nil, token, ctAPPLICATION_JSON);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

  finally
    freeandnil(response);
  end;
end;

// removes the user's current cart from the database
procedure TDataModule1.CancelCart(buyerusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/users/%s/cart/return', [baseUrl, buyerusername]);

  try

    response := sendRequest(url, rmDelete, nil, token);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

  finally
    freeandnil(response);
  end;

end;

// For when the users checks out the cart at the metaphorical "till"
procedure TDataModule1.CheckoutCart(buyerusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/users/%s/cart/checkout', [baseUrl, buyerusername]);
  response := sendRequest(url, rmPOST, nil, token, ctAPPLICATION_JSON);

  try
    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

  finally

    freeandnil(response);

  end;

end;

// method that adds an item given its itemid to a shoppingcart of a given user
procedure TDataModule1.addToCart(buyerusername: string; itemid, token: string;
  quantity: integer);
var
  ShoppingCartItemID, url: string;

  i: integer;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/cart/items', [baseUrl, buyerusername]);

  body := tJsonObject.Create;

  body.AddPair('ItemID', itemid);
  body.AddPair('Quantity', TJSONNumber.Create(quantity));

  try
    response := sendRequest(url, rmPOST, body, token);

    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

    try
      if response.StatusCode <> 200 then
      begin
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      end;

    finally
      freeandnil(responseJson);
    end;

  finally
    freeandnil(response);
  end;
end;

// get the list of items in a user's shopping cart
function TDataModule1.getCartItems(buyerusername, token: string): tADODataSet;
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;

begin

  url := format('%s/users/%s/cart', [baseUrl, buyerusername]);
  response := sendRequest(url, rmGET, nil, token);

  try

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

    Result := responseBodyToDataset(response.Content);

  finally
    freeandnil(response);
  end;

end;

// remove an item from a user's cart
procedure TDataModule1.removeFromCart(ShoppingCartItemID, token,
  buyerusername: string);
var
  url: string;
  response: TRESTResponse;
  body, responseJson: tJsonObject;
  itemid: string;
begin

  url := format('%s/users/%s/cart/items', [baseUrl, buyerusername]);

  body := tJsonObject.Create;
  try

    body.AddPair('ShoppingCartItemID', ShoppingCartItemID);
    response := sendRequest(url, rmDelete, body, token);

    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create
          ((responseJson.GetValue('error') as tJsonString).Value);
      end;

      // handle errors

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body)
  end;

end;

// method called by the timer every set interval to check whether the user's
// current cart has expired
procedure TDataModule1.tmCheckCartExpiredTimer(Sender: TObject);
begin

  if usertype.Equals('ADMIN') then
    Exit;

  // run this code in a separate thread
  TTask.Run(
    procedure
    begin

      try
        //
        CoInitialize(nil);
        // this line is needed ,as ado is not multithreaded by default
        self.getCartItems(self.username, self.jwtToken);
        Couninitialize();
      except
        on e: Exception do
        begin

          if e.Message = 'User doesn''t have a cart.' then
          begin
            showMessage
              ('Your cart is expired, so your cart''s items will be returned and you will be given a new cart.');
            CoInitialize(nil);
            self.CreateUserCart(self.username, self.jwtToken);
            Couninitialize();
          end
          else
          begin
            showMessage(e.Message);
          end

        end;

      end;

    end);

end;


// ITEM METHODS

// function used to retrieve all important information on an item
// so that is can be displayed on the VIEW ITEM screen and ADDitemScreen
function TDataModule1.viewItem(itemid: string): tADODataSet;
var
  url: string;
  response: TRESTResponse;
begin

  url := format('%s/item/%s', [baseUrl, itemid]);

  response := sendRequest(url);
  try

    Result := responseBodyToDataset(response.Content);

    if Result.Fields.FindField('Status') <> nil then
    begin
      showMessage(Result['Status']);
      Exit;
    end;

  finally
    freeandnil(response);

  end;

end;

procedure TDataModule1.updateItem(itemid, Name, category, Desc: string;
Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
  WUProduce: double; token: string; Image: tImage = nil);
var
  url: string;
  response: TRESTResponse;
  body, responseJson: tJsonObject;
begin
  url := format('%s/item/%s', [baseUrl, itemid]);

  body := tJsonObject.Create;
  try

    body.AddPair('ItemID', itemid);
    body.AddPair('ItemName', name);
    body.AddPair('Description', Desc);
    body.AddPair('Category', category);
    body.AddPair('CFProduce', TJSONNumber.Create(CFProduce));
    body.AddPair('WUProduce', TJSONNumber.Create(WUProduce));
    body.AddPair('EUProduce', TJSONNumber.Create(EUProduce));
    body.AddPair('WUUsage', TJSONNumber.Create(WU));
    body.AddPair('EUUsage', TJSONNumber.Create(EU));
    body.AddPair('CFUsage', TJSONNumber.Create(CF));
    body.AddPair('Cost', TJSONNumber.Create(CFProduce));
    body.AddPair('Stock', TJSONNumber.Create(stock));
    body.AddPair('MaxWithdrawableStock', TJSONNumber.Create(maxwithdrawstock));

    try
      response := sendRequest(url, rmPUT, body, token);

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

      if Image <> nil then
      begin
        // send request to update image if indicated
        setItemImage(itemid, token, Image);

      end;
    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;

// procedure to insert a new item into the database
procedure TDataModule1.insertItem(Name, category, Desc: string;
Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
  WUProduce: double; token: string; Image: tImage = nil);
var
  url, itemid: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;

begin

  url := format('%s/item', [baseUrl]);

  body := tJsonObject.Create;

  body.AddPair('ItemName', name);
  body.AddPair('Description', Desc);
  body.AddPair('Category', category);
  body.AddPair('CarbonFootprintProduction', TJSONNumber.Create(CFProduce));
  body.AddPair('WaterUsageProduction', TJSONNumber.Create(WUProduce));
  body.AddPair('EnergyUsageProduction', TJSONNumber.Create(EUProduce));
  body.AddPair('WaterFootprintUsage', TJSONNumber.Create(WU));
  body.AddPair('EnergyFootprintUsage', TJSONNumber.Create(EU));
  body.AddPair('CarbonFootprintUsage', TJSONNumber.Create(CF));
  body.AddPair('Cost', TJSONNumber.Create(CFProduce));
  body.AddPair('Stock', TJSONNumber.Create(stock));
  body.AddPair('MaxWithdrawableStock', TJSONNumber.Create(maxwithdrawstock));

  try

    response := sendRequest(url, rmPOST, body, token);

    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

    if response.StatusCode <> 200 then
    begin

      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

    itemid := (responseJson.P['data[0].ItemID'] as tJsonString).Value;

    if Image <> nil then
    begin
      // send request to update image if indicated
      setItemImage(itemid, token, Image);
    end;

  finally

    freeandnil(response);
  end;

end;

// send request to api to delete a given item using its itemid
procedure TDataModule1.deleteItem(itemid, token: string);
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/item/%s', [baseUrl, itemid]);

  response := sendRequest(url, rmDelete, nil, token);
  try

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);

    end;

  finally
    freeandnil(response);
  end;

end;

// allows a user to send a rating from 1 to 5 on an item
procedure TDataModule1.sendRating(username, itemid, token: string;
rating: integer);
var
  url: string;
  response: TRESTResponse;
  body: tJsonObject;
  responseJson: tJsonObject;
begin

  url := format('%s/item/%s/rating', [baseUrl, itemid]);

  body := tJsonObject.Create;

  body.AddPair('Username', username);
  body.AddPair('Rating', inttostr(rating));

  try
    response := sendRequest(url, rmPOST, body, token);

    try
      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create
          ((responseJson.GetValue('error') as tJsonString).Value);
        freeandnil(responseJson);
      end;

    finally
      freeandnil(response);
    end;

  finally
    freeandnil(body);
  end;

end;

// set the profile picture of a given use using a given image
procedure TDataModule1.setItemImage(itemid, token: string; Image: tImage);
var
  strmImageBytes: tBytesStream;
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  strmImageBytes := tBytesStream.Create;
  try
    Image.Picture.SaveToStream(strmImageBytes);

    url := format('%s/item/%s/image', [baseUrl, itemid]);

    response := sendRequest(url, rmPOST, strmImageBytes, token,
      TRESTContentType.ctIMAGE_PNG);

    try
      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

    finally
      freeandnil(response);
    end;

  finally
    strmImageBytes.Free;
  end;

end;

// SEARCHING METHODS

// Search for items with a specific string and category
function TDataModule1.getSearchResults(searchQuery: string;
categories: TList<string>; CFRange, EURange, WURange, resultRange,
  ratingRange: array of integer): tADODataSet;
var
  url, currentCateg: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
  queryParams: TList<TPair<String, variant>>;

begin

  url := format('%s/search', [baseUrl]);

  // stores query parameters to put in the url
  queryParams := TList < TPair < String, variant >>.Create;

  // check if user has specified whcih results they want to see ( first to tenth for example)
  if length(resultRange) <> 0 then
  begin
    // save the given values a query parameter
    queryParams.Add(TPair<String, variant>.Create('indexRange',
      resultRange[0]));
    queryParams.Add(TPair<String, variant>.Create('indexRange',
      resultRange[1]));

  end;

  if length(ratingRange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('ratingRange',
      ratingRange[0]));

  end;

  // add queyr parameters for cf range
  if length(CFRange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('CFRange', CFRange[0]));
    queryParams.Add(TPair<String, variant>.Create('CFRange', CFRange[1]));

  end;

  // add query parameters for energy usage

  if length(EURange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('EURange', EURange[0]));
    queryParams.Add(TPair<String, variant>.Create('EURange', EURange[1]));

  end;

  // add query parameters for water usage
  if length(WURange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('WURange', WURange[0]));
    queryParams.Add(TPair<String, variant>.Create('WURange', WURange[1]));

  end;

  // add any categories
  if categories <> nil then
  begin

    for currentCateg in categories do
    begin

      queryParams.Add(TPair<String, variant>.Create('categories',
        currentCateg));

    end;

  end;

  // add the query string to match with username
  queryParams.Add(TPair<String, variant>.Create('query', searchQuery));

  try
    response := sendRequest(url, rmGET, nil, '', ctAPPLICATION_JSON,
      queryParams);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

    Result := responseBodyToDataset(response.Content);

  finally

    freeandnil(response);

  end;

end;


// APPLICATIONS

function TDataModule1.getApplications(iMin, iMax: integer; token: string)
  : tADODataSet;
var
  url, currentCateg: string;
  responseJson: tJsonObject;
  response: TRESTResponse;
  queryParams: TList<TPair<String, variant>>;
begin

  url := format('%s/application', [baseUrl]);

  // stores query parameters to put in the url
  queryParams := TList < TPair < String, variant >>.Create;
  try
    queryParams.Add(TPair<String, variant>.Create('minIndex', iMin));
    queryParams.Add(TPair<String, variant>.Create('maxIndex', iMax));

    response := sendRequest(url, rmGET, nil, token, ctAPPLICATION_JSON,
      queryParams);
    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

      Result := responseBodyToDataset(response.Content);

    finally

      freeandnil(response);

    end;

  finally

    queryParams.Free;
  end;

end;

procedure TDataModule1.denyApplication(applicationID, reason, token: string);
var
  url, currentCateg: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/application/%s/deny', [baseUrl, applicationID]);

  body := tJsonObject.Create;
  try

    body.AddPair('Reason', reason);

    response := sendRequest(url, rmDelete, body, token);
    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

    finally

      freeandnil(response);

    end;

  finally
    body.Free;
  end;

end;

procedure TDataModule1.acceptApplication(applicationID, token: string);
var
  url, currentCateg: string;
  responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/application/%s/approve', [baseUrl, applicationID]);

  response := sendRequest(url, rmPOST, nil, token);
  try

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

  finally

    freeandnil(response);

  end;

end;

procedure TDataModule1.sendApplication(email, explanation: string);
var
  url, currentCateg: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/application/send', [baseUrl]);

  body := tJsonObject.Create;
  try

    body.AddPair('Email', email);
    body.AddPair('Explanation', explanation);

    response := sendRequest(url, rmPOST, body, '');
    try

      if response.StatusCode <> 200 then
      begin
        responseJson := tJsonObject.ParseJSONValue(response.Content)
          as tJsonObject;
        raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
        freeandnil(responseJson);
      end;

    finally

      freeandnil(response);

    end;

  finally
    body.Free;
  end;
end;

function TDataModule1.getApplication(applicationID, token: string): tADODataSet;
var
  url, currentCateg: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/application/%s', [baseUrl, applicationID]);

  response := sendRequest(url, rmGET, nil, token);
  try

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
      freeandnil(responseJson);
    end;

    Result := responseBodyToDataset(response.Content);
    // size of text field in mysql

  finally

    freeandnil(response);

  end;

end;

// UTILITIES

// a utility that acts as a ternary operator
function TDataModule1.ifthenreturn(condition: boolean;
trueValue, falsevalue: variant): variant;
begin
  if condition then
  begin
    Result := trueValue;
  end
  else
  begin
    Result := falsevalue;
  end;
end;

// function that isd given a password string and determines if it is a secure password
// returns an integer detailing the status of the password
function TDataModule1.securePassword(password: string): integer;
var
  i: integer;

begin

  if length(password) < 8 then
  begin
    Result := tooShort;
    Exit;
  end;

  Result := noNums;

  for i := 1 to length(password) do
  begin
    if not(pos(password[i], nums) = 0) then
    begin
      Result := success
    end;

  end;

  if Result = noNums then
  begin
    Exit;
  end;

  Result := noSpecial;

  for i := 1 to length(password) do
  begin
    if not(pos(password[i], special) = 0) then
    begin
      Result := success
    end;

  end;
end;

// use this to popup a filechooser that allows the user to sleect png or jpg files
// then save them into a given timage component
procedure TDataModule1.loadImageFromFile(img: tImage; window: TForm);
var
  fileChooser: tOpenDialog;
  sImagePath: string;
begin
  // open filchooser
  fileChooser := tOpenDialog.Create(window);
  try
    fileChooser.Filter := 'png files|*.png|jpg Files|*.jpg';
    fileChooser.InitialDir := 'C:\';

    if fileChooser.Execute then
    begin
      sImagePath := fileChooser.FileName;
      img.Picture.LoadFromFile(sImagePath);
    end
    else
    begin
      raise Exception.Create('Please choose a file');
    end;
  finally
    freeandnil(fileChooser);
  end;

end;

// this resizes an image to a certain height and returns a tpngimage
function TDataModule1.ResizeImage(Image: tImage; width, height: integer)
  : tpngImage;
var
  ResizedImage: tImage;
begin

  ResizedImage := tImage.Create(nil);

  try
    // resize the image

    ResizedImage.Picture.Assign(Image.Picture);

    ResizedImage.Stretch := True;

    ResizedImage.width := width;
    ResizedImage.height := height;

    // get image as a png

    Result := tpngImage.Create();
    Result.Assign(ResizedImage.Picture.Graphic);

  finally

    // free allocated memory
    freeandnil(ResizedImage);
  end;

end;

function TDataModule1.getUserTypeFromToken(token: string): string;
var
  tjwt: tJose;
  tjBytes: TJOSEBytes;
begin

end;

// WEB UTILITIES

function TDataModule1.sendRequest(url: string;
method: trestrequestmethod = rmGET; body: TObject = nil;
authorization: string = ''; contentType: TRESTContentType = ctAPPLICATION_JSON;
queryParams: TList < TPair < String, variant >> = nil): TRESTResponse;
var
  AParameter: TRESTRequestParameter;
  urlBuilder: tStringBuilder;
  currQueryParam: TPair<String, variant>;
  restCLient: TRESTClient;
  restRequest: TRESTRequest;
  i: integer;
begin
  // set up client, request and response objects

  restCLient := TRESTClient.Create(url);

  // the ref to self will free once program closes
  restRequest := TRESTRequest.Create(nil);

  Result := TRESTResponse.Create(nil);

  restRequest.Client := restCLient;
  restRequest.response := Result;

  try

    if queryParams <> nil then
    begin
      urlBuilder := tStringBuilder.Create(url).Append('?');
      // add all query params
      for i := 0 to queryParams.Count - 1 do

      begin
        currQueryParam := queryParams.Items[i];
        urlBuilder.Append(currQueryParam.Key).Append('=')
          .Append(Vartostr(currQueryParam.Value));

        if queryParams.Count - 1 > i then
          urlBuilder.Append('&')

      end;

      restCLient.baseUrl := urlBuilder.ToString;

    end;

    // decide on method to use
    restRequest.method := method;

    if body <> nil then
    begin

      // add a json body
      if body is tJsonObject then
        restRequest.body.Add(body.ToString, ctAPPLICATION_JSON);

      // add an image body
      if contentType = ctIMAGE_PNG then
      begin

        restRequest.body.Add(body as tBytesStream, contentType);
      end;

    end;

    if authorization <> '' then
    begin
      // podonot encode ensures white spaces dont get encoded as %20
      restRequest.params.AddItem('Authorization', 'Bearer ' + authorization,
        pkHttpHeader, [poDoNotEncode]);
    end;

    restRequest.Execute;

    // return result  as rest response

  finally

    // free allocated memory
    freeandnil(restRequest);
    freeandnil(restCLient);

  end;
end;

// use this to convert a response from the api ( a json string) into a
// a tAdoDataset. The reason for this conversion is that the previous versions
// of this project used adodb library to interact with a microsoft access db
// directly. This method allows for compatibility with older code ansd keeps the code modular
function TDataModule1.responseBodyToDataset(body: string): tADODataSet;
var
  bodyJson: tJsonObject;
  dataFields: tJsonObject;
  currentJsonValue: TJsonValue;
  currentJsonPair: tJsonPair;
  currentJsonObj: tJsonObject;
  currentFieldName: string;
  currentFieldType: string;
  currentStringValue: string;
  datafieldsEnumerator: tJsonObject.TEnumerator;
  currField: tField;
  Data: Tjsonarray;

begin
  bodyJson := tJsonObject.Create;

  Result := tADODataSet.Create(nil);

  if body.IsEmpty then
  begin
    // return nil
    Result.FieldDefs.Add('Status', tFieldType.ftString, 100);
    Result.CreateDataSet;
    Result.InsertRecord(['Success']);
    Exit;
  end;

  bodyJson := tJsonObject.ParseJSONValue(body) as tJsonObject;

  // if the body details are an error

  if not(bodyJson.get('error') = nil) then
  begin
    Result.FieldDefs.Add('Status', tFieldType.ftString, 100);
    Result.CreateDataSet;
    Result.InsertRecord
      ([(bodyJson.get('error').JsonValue as tJsonString).Value]);
    Exit;
  end;

  dataFields := bodyJson.GetValue('dataFields') as tJsonObject;

  Data := bodyJson.GetValue('data') as Tjsonarray;

  // define the columns of the dataset from the json response
  datafieldsEnumerator := dataFields.GetEnumerator;
  while datafieldsEnumerator.MoveNext do
  begin
    currentJsonPair := datafieldsEnumerator.GetCurrent;
    currentFieldName := currentJsonPair.JsonString.Value;
    currentFieldType := (currentJsonPair.JsonValue as tJsonString).Value;
    Result.FieldDefs.Add(currentFieldName,
      getFtTypefromString(currentFieldType));
    // hacky nonsense , i hate this
    // for string you MUST  specify size
    if currentFieldType.Equals('string') then
    begin
      Result.FieldDefs.Find(currentFieldName).Size := 256;
    end;
    if currentFieldType.Equals('memo') then
    begin
      Result.FieldDefs.Find(currentFieldName).Size := 65536;
    end;
  end;

  Result.CreateDataSet;

  // add data as records
  for currentJsonValue in Data do
  begin
    Result.Append;
    currentJsonObj := currentJsonValue as tJsonObject;
    for currField in Result.Fields do
    begin

      case currField.DataType of

        tFieldType.ftString, tFieldType.ftMemo:
          begin
            Result.Edit;
            Result[currField.DisplayName] :=
              (currentJsonObj.P[currField.DisplayName] as tJsonString).Value;

          end;
        tFieldType.ftInteger:
          begin
            Result.Edit;
            Result[currField.DisplayName] :=
              (currentJsonObj.GetValue(currField.DisplayName)
              as TJSONNumber).AsInt;
          end;
        tFieldType.ftFloat:
          begin
            Result.Edit;
            Result[currField.DisplayName] :=
              (currentJsonObj.GetValue(currField.DisplayName)
              as TJSONNumber).AsDouble;
          end;

      end;

    end;

  end;

end;

// used to get type of a column for dataset based on string for the column
// given by the api. the types are "string", "int" and "double".
function TDataModule1.getFtTypefromString(s: string): tFieldType;
begin
  //
  if s.Equals('string') then
  begin

    Result := tFieldType.ftString;

    Exit;
  end;
  if s.Equals('int') then
  begin

    Result := tFieldType.ftInteger;
    Exit;
  end;
  if s.Equals('double') then
  begin

    Result := tFieldType.ftFloat;
    Exit;
  end;
  if s.Equals('memo') then
  begin
    Result := tFieldType.ftMemo;
    Exit;
  end;

end;

end.
