unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Data.Win.ADODB, Data.DB,
  sCrypt, System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.ComCtrls,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, PngImage,
  System.Win.ComObj, ADOInt,
  dateutils, stdctrls, System.JSON, System.Threading, REST.Types,
  Data.Bind.Components, REST.Client, IdServerIOHandler, Data.Bind.ObjectScope;

type
  TDataModule1 = class(TDataModule)
    procedure checkIFCartOutdated(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
    // stores these global vairables for all screen\
    username: string;
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

    procedure Login(username, password: string);
    procedure SignUp(username, password, usertype, homeAddress,
      certificationcode: string; imgPfp: tImage);

    procedure Changeusername(oldusername, newusername, token: string);

    procedure changePassword(username, oldpassword, newpassword: string);

    procedure loadProfilePicture(username: string; Image: tImage);

    procedure setProfilePicture(username, token: string; imgPfp: tImage);

    procedure loadItemImage(itemid: string; Image: tImage);

    procedure setItemImage(itemid, token: string; Image: tImage);

    function userInfo(username: string): tADODataSet;

    function obtainStats(username, token: string; statType: integer;
      DateBegin, DateEnd: tDateTime): tADODataSet;

    function viewItem(itemid: string): tADODataSet;

    procedure insertItem(Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token: string; Image: tImage = nil);

    procedure updateItem(itemid, Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token: string; Image: tImage = nil);

    procedure deleteItem(itemid, token: string);

    procedure sendRating(username, itemid, token: string; rating: integer);

    function getProducts(username: string; iMin, iMax: integer;
      var numproducts: integer): tADODataSet;

    function getSearchResults(searchQuery: string; categories: TList<string>;
      CFRange, EURange, WURange, resultRange, ratingRange: array of integer;
      var numResults: integer): tADODataSet;

    // methods relating to transaction management
    function CreateUserCart(buyerusername, token: string): string;

    procedure CancelCart(buyerusername, token: string);

    procedure CheckoutCart(buyerusername, token: string);

    procedure addToCart(buyerusername: string; itemid, token: string;
      quantity: integer);

    function getCartItems(buyerusername, token: string): tADODataSet;

    procedure removeFromCart(ShoppingCartItemID, token, buyerusername: string);

    procedure loadImageFromFile(img: tImage; window: TForm);

    procedure addFunds(username, token: string; amount: double);

    function ResizeImage(Image: tImage; width, height: integer): tpngImage;

    procedure warnUser();

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

const
  baseUrl = 'https://localhost:8080';

implementation

uses
  Checkout_u;

{$R *.dfm}

// increase a given user's balance by a given amount
procedure TDataModule1.addFunds(username, token: string; amount: double);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/funds', [baseUrl, username]);

  body := tJsonObject.Create;

  body.AddPair('Username', username);
  body.AddPair('Funds', TJSONNumber.Create(amount));

  try
    response := sendRequest(url, rmPUT, body, token);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

  finally
    freeandnil(response);
  end;

end;

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

    if response.StatusCode <> 200 then
    begin
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
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

  url := format('%s/users/%/cart/return', [baseUrl, buyerusername]);

  try
    response := sendRequest(url, rmDelete, nil, token);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

  finally
    freeandnil(response);
  end;

end;

procedure TDataModule1.changePassword(username, oldpassword,
  newpassword: string);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/reset', [baseUrl, username]);

  body := tJsonObject.Create;

  body.AddPair('oldPassword', oldpassword);
  body.AddPair('newPassword', newpassword);

  response := sendRequest(url, rmPUT, body);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

end;

procedure TDataModule1.Changeusername(oldusername, newusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/users/%s/change', [baseUrl, oldusername]);

  body := tJsonObject.Create;

  body.AddPair('oldUsername', oldusername);
  body.AddPair('newUsername', newusername);

  try
    response := sendRequest(url, rmPUT, body, token);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

    username := newusername;

  finally

    freeandnil(response);
  end;

end;

// send a request to see if cart has expired
procedure TDataModule1.checkIFCartOutdated(Sender: TObject);
begin
  //
end;

// For when the users checks out the cart at the metaphorical "till"
procedure TDataModule1.CheckoutCart(buyerusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/users/%s/cart/checkout', [baseUrl, buyerusername]);

  try
    response := sendRequest(url, rmPOST, nil, token, ctAPPLICATION_JSON);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

  finally
    freeandnil(response);
  end;

end;

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
    end;

  finally
    freeandnil(response);
  end;
end;


// Mark an item as deleted
// do not remove any actual records, we need to maintain referential integrity
// between other tables

procedure TDataModule1.deleteItem(itemid, token: string);
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin
  //

  url := format('%s/item/%s', [baseUrl, itemid]);

  try
    response := sendRequest(url, rmDelete, nil, token);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
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

  try
    response := sendRequest(url, rmGET, nil, token);

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

end;

// used to  get type for dataset based on str
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

end;

// get the all the products made by a particular seller
// NOTE: the  var keyword is a pass by referecne
function TDataModule1.getProducts(username: string; iMin, iMax: integer;
  var numproducts: integer): tADODataSet;
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin
  //

  url := format('%s/users/%s/products', [baseUrl, username]);

  response := sendRequest(url);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  Result := responseBodyToDataset(response.Content);
  numproducts := Result.RecordCount;

end;

procedure TDataModule1.loadProfilePicture(username: string; Image: tImage);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
  stream: tBytesStream;

begin
  url := format('%s/users/%s/profileImage', [baseUrl, username]);

  try
    response := sendRequest(url);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

    try
      stream := tBytesStream.Create(BytesOf(response.Content));
      Image.Picture.LoadFromStream(stream);
    finally

      stream.Free;
    end;
  finally

    freeandnil(response);
  end;

end;

// Search for items with a specific string and category
function TDataModule1.getSearchResults(searchQuery: string;
  categories: TList<string>; CFRange, EURange, WURange, resultRange,
  ratingRange: array of integer; var numResults: integer): tADODataSet;
var
  url, currentCateg: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
  queryParams: TList<TPair<String, variant>>;

begin

  url := format('%s/search', [baseUrl]);

  queryParams := TList < TPair < String, variant >>.Create;

  if length(resultRange) <> 0 then
  begin
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

  if length(CFRange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('CFRange', CFRange[0]));
    queryParams.Add(TPair<String, variant>.Create('CFRange', CFRange[1]));

  end;

  if length(EURange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('EURange', EURange[0]));
    queryParams.Add(TPair<String, variant>.Create('EURange', EURange[1]));

  end;

  if length(WURange) <> 0 then
  begin
    queryParams.Add(TPair<String, variant>.Create('WURange', WURange[0]));
    queryParams.Add(TPair<String, variant>.Create('WURange', WURange[1]));

  end;

  if categories <> nil then
  begin

    for currentCateg in categories do
    begin

      queryParams.Add(TPair<String, variant>.Create('categories',
        currentCateg));

    end;

  end;

  queryParams.Add(TPair<String, variant>.Create('query', searchQuery));

  try
    response := sendRequest(url, rmGET, nil, '', ctAPPLICATION_JSON,
      queryParams);

    Result := responseBodyToDataset(response.Content);

    numResults := Result.RecordCount;

  finally

    freeandnil(response);

  end;

end;

// procedure to insert a new item into the database
procedure TDataModule1.insertItem(Name, category, Desc: string;
  Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
  WUProduce: double; token: string; Image: tImage = nil);
var
  url: string;
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

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

    if Image <> nil then
    begin
      // send request to update image if indicated
    end;

  finally

    freeandnil(response);
  end;

end;

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
      showMessage('Please choose a file');
    end;
  finally
    freeandnil(fileChooser);
  end;

end;

procedure TDataModule1.loadItemImage(itemid: string; Image: tImage);
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
  stream: tBytesStream;
begin

  url := format('%s/item/%s/image', [baseUrl, itemid]);

  try

    response := sendRequest(url);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

    if response.Content.Equals('') then
      Exit;

    stream := tBytesStream.Create(BytesOf(response.Content));
    try
      Image.Picture.LoadFromStream(stream);
    finally
      freeandnil(stream);
    end;

  finally

    if assigned(response) then
      freeandnil(response);
  end;
end;

// function used to check credentials entered and login a user if successful
procedure TDataModule1.Login(username, password: string);
var
  url: string;
  body, responseBody: tJsonObject;
  response: TRESTResponse;
begin

  url := format('%s/login', [baseUrl]);

  body := tJsonObject.Create;

  body.AddPair('Username', username);

  body.AddPair('Password', password);

  try

    response := sendRequest(url, rmPOST, body);

    responseBody := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

    if response.StatusCode <> 200 then
    begin
      raise Exception.Create
        ((responseBody.GetValue('error') as tJsonString).Value);
      Exit
    end;

    // get the jwt token from the succsful login attempt
    jwtToken := (responseBody.P['data[0].token'] as tJsonString).Value;
    self.username := username;

  finally

    freeandnil(response);
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

  // specify the range of dates to queyr stats from
  queryParams.Add(TPair<string, variant>.Create('monthBegin',
    FormatDateTime('yyyy-mm-dd', DateBegin)));
  queryParams.Add(TPair<string, variant>.Create('monthEnd',
    FormatDateTime('yyyy-mm-dd', DateEnd)));

  try
    response := sendRequest(url, rmGET, nil, token, ctAPPLICATION_JSON,
      queryParams);

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
end;

// remove an item from a user's cart
procedure TDataModule1.removeFromCart(ShoppingCartItemID, token,
  buyerusername: string);
var
  url: string;
  dsResult: tADODataSet;
  response: TRESTResponse;
  params: tObjectDictionary<string, variant>;
  body: tJsonObject;
  itemid: string;
begin

  url := format('%s/users/%s/cart/items', [baseUrl, buyerusername]);

  body := tJsonObject.Create;

  body.AddPair('ShoppingCartItemID', ShoppingCartItemID);

  try

    response := sendRequest(url, rmDelete, body, token);


    // handle errors

  finally
    freeandnil(response);
  end;

end;

// this resizes an image to a certain height and returns a tpngimage
function TDataModule1.ResizeImage(Image: tImage; width, height: integer)
  : tpngImage;
var
  ResizedImage: tImage;
  PngImage: tpngImage;
begin

  try
    // resize the image
    ResizedImage := tImage.Create(nil);
    ResizedImage.Picture.Assign(Image.Picture);

    ResizedImage.Stretch := True;

    ResizedImage.width := width;
    ResizedImage.height := height;

    // get image as a png
    Result := tpngImage.Create;

    Result.Assign(ResizedImage.Picture.Graphic);

  finally

    // free allocated memory
    freeandnil(ResizedImage);

  end;

end;

function TDataModule1.responseBodyToDataset(body: string): tADODataSet;
var
  bodyJson: tJsonObject;
  dataFields: tJsonObject;
  currentJsonValue: TJsonValue;
  currentJsonPair: tJsonPair;
  currentJsonObj: tJsonObject;
  currentFieldName: string;
  currentFieldType: string;
  datafieldsEnumerator: tJsonObject.TEnumerator;
  currField: tField;
  Data: Tjsonarray;

begin
  //
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

        tFieldType.ftString:
          begin
            Result.Edit;
            Result[currField.DisplayName] :=
              currentJsonObj.GetValue(currField.DisplayName).Value;
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

// allows a user to send a rating from 1 to 5 on an item
procedure TDataModule1.sendRating(username, itemid, token: string;
  rating: integer);
var
  dsResult: tADODataSet;
  requestBody: tJsonObject;
begin

end;

function TDataModule1.sendRequest(url: string;
  method: trestrequestmethod = rmGET; body: TObject = nil;
  authorization: string = '';
  contentType: TRESTContentType = ctAPPLICATION_JSON;
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

    url := format('%s/users/%s/profileImage', [baseUrl, username]);

    response := sendRequest(url, rmPOST, strmImageBytes, token,
      TRESTContentType.ctIMAGE_PNG);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

  finally
    strmImageBytes.Free;
  end;

end;

procedure TDataModule1.setProfilePicture(username, token: string;
  imgPfp: tImage);
var
  strmImageBytes: tBytesStream;
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  strmImageBytes := tBytesStream.Create;
  try
    imgPfp.Picture.SaveToStream(strmImageBytes);

    url := format('%s/users/%s/profileImage', [baseUrl, username]);

    response := sendRequest(url, rmPOST, strmImageBytes, token,
      TRESTContentType.ctIMAGE_PNG);

    if response.StatusCode <> 200 then
    begin
      responseJson := tJsonObject.ParseJSONValue(response.Content)
        as tJsonObject;
      raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
    end;

  finally
    strmImageBytes.Free;
  end;

end;

// a function used to create a new user in the database and return the new user's userid for use by the program
procedure TDataModule1.SignUp(username, password, usertype, homeAddress,
  certificationcode: string; imgPfp: tImage);
var
  url: string;
  response: TRESTResponse;
  bodyJson, responseJson: tJsonObject;
begin

  url := format('%s/signup', [baseUrl]);

  bodyJson := tJsonObject.Create;

  bodyJson.AddPair('Username', username);
  bodyJson.AddPair('Password', password);
  bodyJson.AddPair('UserType', usertype);
  bodyJson.AddPair('HomeAddress', homeAddress);

  try
    response := sendRequest(url, rmPOST, bodyJson);

    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

    if response.StatusCode <> 200 then
    begin
      raise Exception.Create
        ((responseJson.GetValue('error') as tJsonString).Value);
    end;

    jwtToken := (responseJson.P['data[0].token'] as tJsonString).Value;

    // set the profile picture
    setProfilePicture(username, jwtToken, imgPfp);

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
    end;

    if Image <> nil then
    begin
      // send request to update image if indicated
      setItemImage(itemid, token, Image);

    end;
  finally
    freeandnil(response);
  end;

end;

function TDataModule1.userInfo(username: string): tADODataSet;
var
  url: string;
  response: TRESTResponse;
begin;

  url := format('%s/users/%s', [baseUrl, username]);

  try
    response := sendRequest(url);

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

// function used to retrieve all important information on an item
// so that is can be displayed on the VIEW ITEM screen and ADDitemScreen
function TDataModule1.viewItem(itemid: string): tADODataSet;
var
  sql, url: string;
  response: TRESTResponse;
  params: tObjectDictionary<string, variant>;
begin

  url := format('%s/item/%s', [baseUrl, itemid]);

  try
    response := sendRequest(url);

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

// warns user that their cart will soon expire if they don't checkout soon
procedure TDataModule1.warnUser;
begin
  if not warnedUser then
  begin
    warnedUser := True;
    showMessage('You have less than 30s before your cart expires.');
  end;
end;

end.
