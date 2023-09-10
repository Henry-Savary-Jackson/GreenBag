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
    restCLient: TRESTClient;
    restRequest: TRESTRequest;
    restResponse: TRESTResponse;
    procedure DataModuleCreate(Sender: TObject);
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

    procedure loadProfilePicture(username: string; Image: tImage);

    procedure setProfilePicture(username, token: string; imgPfp: tImage);

    procedure loadItemImage(itemid: string; Image: tImage);

    procedure setItemImage(itemid, token: string; Image: tImage);

    function userInfo(username: string): tADODataSet;

    function obtainStats(username, token: string; statType: integer;
      DateBegin, DateEnd: tDateTime): tADODataSet;

    function viewItem(itemid: string): tADODataSet;

    procedure insertItem( Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token:string; Image: tImage = nil);

    procedure updateItem(itemid, Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double;token:string; Image: tImage = nil);

    procedure deleteItem(itemid, token :string);

    procedure sendRating(username, itemid, token: string; rating: integer);

    function getProducts(username: string; iMin, iMax: integer;
      var numproducts: integer): tADODataSet;

    function getSearchResults(searchQuery: string; categories: TList<string>;
      CFRange, EURange, WURange, resultRange: array of integer;
      var numResults: integer): tADODataSet;

    // methods relating to transaction management
    function CreateUserCart(buyerusername, token: string): string;

    procedure CancelCart(buyerusername, token: string);

    procedure CheckoutCart(buyerusername, token: string);

    function addToCart(buyerusername: string; itemid, token: string;
      quantity: integer): string;

    function getCartItems(buyerusername, token: string): tADODataSet;

    procedure removeFromCart(ShoppingCartItemID, token: string);

    procedure loadImageFromFile(img: tImage; window: TForm);

    procedure addFunds(username, token: string; amount: double);

    function CloneRecordset(const Data: _Recordset): _Recordset;

    function ResizeImage(Image: tImage; width, height: integer): tpngImage;

    procedure warnUser();

    function sendRequest(url: string; method: trestrequestmethod = rmGET;
      body: TObject = nil; authorization: string = '';
      contentType: TRESTContentType = ctAPPLICATION_JSON): TRESTResponse;

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

  url := format('%s/u/%/cart/return', [baseUrl, username]);

  body := tJsonObject.Create;

  body.AddPair('Username', username);
  body.AddPair('Funds', TJSONNumber.Create(amount));

  response := sendRequest(url, rmPOST, body, token);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

end;

function TDataModule1.addToCart(buyerusername: string; itemid, token: string;
      quantity: integer): string;
var
  ShoppingCartItemID, url: string;

  i: integer;
  response: TRESTResponse;
  responseJson, body: tJsonObject;
begin

  url := format('%s/u/%/cart/return', [baseUrl, buyerusername]);

  body := tJsonObject.Create;

  body.AddPair('ItemID', itemid);
  body.AddPair('Quantity', TJSONNumber.Create(quantity));

  response := sendRequest(url, rmPOST, body, token);

  responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

  if response.StatusCode <> 200 then
  begin
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  Result := (responseJson.P['data[0].ShoppingCartItemID'] as tJsonString).Value;

end;

// removes the user's current cart from the database
procedure TDataModule1.CancelCart(buyerusername, token: string);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  url := format('%s/u/%/cart/return', [baseUrl, buyerusername]);

  response := sendRequest(url, rmDelete, nil, token);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

end;

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

end;

// creates a deep copy of a recordset so as to copy the data from on dataset
// to another
// thanks stack overflow
function TDataModule1.CloneRecordset(const Data: _Recordset): _Recordset;
var
  newRec: _Recordset;
  stm: stream;
begin
  newRec := CoRecordset.Create as _Recordset;
  stm := CoStream.Create;
  Data.Save(stm, adPersistADTG);
  newRec.Open(stm, EmptyParam, CursorTypeEnum(adOpenUnspecified),
    LockTypeEnum(adLockUnspecified), 0);
  Result := newRec;
end;

// once the user has checked out a cart or has logged in
// generate a new shopping cart for the user
function TDataModule1.CreateUserCart(buyerusername, token: string): string;
var
  sShoppingCartID, sql: string;
  i: integer;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  //

end;

// Mark an item as deleted
// do not remove any actual records, we need to maintain referential integrity
// between other tables

procedure TDataModule1.deleteItem(itemid, token :string);
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
begin
  //

  url := format('%s/item/%s', [baseUrl, itemid]);

  response := sendRequest(url, rmDelete, nil, token);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

end;

// get the list of items in a user's shopping cart
function TDataModule1.getCartItems(buyerusername, token: string): tADODataSet;
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;

begin

  url := format('%s/u/%s/cart', [baseUrl, buyerusername]);

  response := sendRequest(url, rmget, nil, token);


  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  Result := responseBodyToDataset(response.Content);


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
  sql, url, lastItemId: string;
begin
  //

end;

procedure TDataModule1.loadProfilePicture(username: string; Image: tImage);
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
  stream: tBytesStream;

begin
  url := format('%s/u/%s/profileImage', [baseUrl, username]);

  response := sendRequest(url);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  try
    stream := tBytesStream.Create(BytesOf(response.Content));
    Image.Picture.LoadFromStream(stream);
  finally

    stream.Free;
  end;

end;

// Search for items with a specific string and category
function TDataModule1.getSearchResults(searchQuery: string;
  categories: TList<string>; CFRange, EURange, WURange,
  resultRange: array of integer; var numResults: integer): tADODataSet;
var
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;

begin

  url := format('%s/search', [baseUrl]);



end;

// procedure to insert a new item into the database
procedure TDataModule1.insertItem( Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; token:string; Image: tImage = nil);
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

  response := sendRequest(url, rmPOST, body, token);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  if Image <> nil then
  begin
    // send request to update image if indicated
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
    FreeAndNil(fileChooser);
  end;

end;

procedure TDataModule1.loadItemImage(itemid: string; Image: tImage);
var
  url: string;
  body, responseJson: tJsonObject;
  response: TRESTResponse;
  stream: tBytesStream;
begin

  url := format('%s/u/%s/image', [baseUrl, itemid]);

  response := sendRequest(url);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  try
    stream := tBytesStream.Create(BytesOf(response.Content));
    Image.Picture.LoadFromStream(stream);
  finally

    stream.Free;
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

  response := sendRequest(url, rmPOST, body);

  responseBody := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;

  if response.StatusCode <> 200 then
  begin
    raise Exception.Create((responseBody.GetValue('error')
      as tJsonString).Value);
    Exit
  end;

  showMessage(responseBody.ToString);
  // get the jwt token from the succsful login attempt
  jwtToken := (responseBody.P['data[0].token'] as tJsonString).Value;
  self.username := username;

end;

// this table doesn't use StatsTB, as it is unnecessary and full of redundancy
// and calculated fields, so i deleted the table and instead calculated using
// transaction history
function TDataModule1.obtainStats(username, token: string; statType: integer;
      DateBegin, DateEnd: tDateTime): tADODataSet;
var
  fieldToAnalyse: string;
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin;
  //
end;

// remove an item from a user's cart
procedure TDataModule1.removeFromCart(ShoppingCartItemID, token: string);
var
  sql: string;
  dsResult, dsResultItemInfo: tADODataSet;
  params: tObjectDictionary<string, Variant>;
  quantity: integer;
  itemid: string;
begin

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
    FreeAndNil(ResizedImage);

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

  // if the body details an error

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
      Result.FieldDefs.Find(currentFieldName).Size := 100;
    end;

  end;

  Result.CreateDataSet;

  // add data as records
  for currentJsonValue in Data do
  begin
    Result.Insert;
    Result.Last;
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
procedure TDataModule1.sendRating(username, itemid, token: string; rating: integer);
var
  dsResult: tADODataSet;
  requestBody: tJsonObject;
begin

end;

function TDataModule1.sendRequest(url: string;
  method: trestrequestmethod = rmGET; body: TObject = nil;
  authorization: string = '';
  contentType: TRESTContentType = ctAPPLICATION_JSON): TRESTResponse;
var
  AParameter: TRESTRequestParameter;
begin

  restCLient.baseUrl := url;

  restRequest.params.clear;

  // TODO : figure out how to modularly handle query params

  restRequest.method := method;

  restRequest.body.ClearBody;

  if body <> nil then
  begin

    if body is tJsonObject then
      restRequest.body.Add(body.ToString, ctAPPLICATION_JSON);

    if contentType = ctIMAGE_PNG then
    begin

      restRequest.body.Add(body as tBytesStream, contentType);
    end;

  end;

  if authorization <> '' then
  begin
    restRequest.params.AddItem('Authorization', 'Bearer ' + authorization,
      pkHttpHeader, [poDonotEncode]);
  end;

  restRequest.Execute;

  Result := restResponse;
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

    url := format('%s/u/%s/profileImage', [baseUrl, username]);

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

procedure TDataModule1.setProfilePicture(username, token: string; imgPfp: tImage);
var
  strmImageBytes: tBytesStream;
  url: string;
  response: TRESTResponse;
  responseJson: tJsonObject;
begin

  strmImageBytes := tBytesStream.Create;
  try
    imgPfp.Picture.SaveToStream(strmImageBytes);

    url := format('%s/u/%s/profileImage', [baseUrl, username]);

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
  restResponse: TRESTResponse;
  bodyJson, responseJson: tJsonObject;
begin

  url := format('%s/signup', [baseUrl]);

  bodyJson := tJsonObject.Create;

  bodyJson.AddPair('Username', username);
  bodyJson.AddPair('Password', password);
  bodyJson.AddPair('UserType', usertype);
  bodyJson.AddPair('HomeAddress', homeAddress);

  restResponse := sendRequest(url, rmPOST, bodyJson);

  responseJson := tJsonObject.ParseJSONValue(restResponse.Content)
    as tJsonObject;

  if restResponse.StatusCode <> 200 then
  begin
    raise Exception.Create((responseJson.GetValue('error')
      as tJsonString).Value);
  end;

  jwtToken := (responseJson.P['data[0].token'] as tJsonString).Value;

  // set the profile picture
  setProfilePicture(username, jwtToken, imgPfp);

end;

procedure TDataModule1.updateItem(itemid, Name, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double;token:string; Image: tImage = nil);
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
  body.AddPair('CarbonFootprintProduction', TJSONNumber.Create(CFProduce));
  body.AddPair('WaterUsageProduction', TJSONNumber.Create(WUProduce));
  body.AddPair('EnergyUsageProduction', TJSONNumber.Create(EUProduce));
  body.AddPair('WaterFootprintUsage', TJSONNumber.Create(WU));
  body.AddPair('EnergyFootprintUsage', TJSONNumber.Create(EU));
  body.AddPair('CarbonFootprintUsage', TJSONNumber.Create(CF));
  body.AddPair('Cost', TJSONNumber.Create(CFProduce));
  body.AddPair('Stock', TJSONNumber.Create(stock));
  body.AddPair('MaxWithdrawableStock', TJSONNumber.Create(maxwithdrawstock));

  response := sendRequest(url, rmPUT, body, token);

  if response.StatusCode <> 200 then
  begin
    responseJson := tJsonObject.ParseJSONValue(response.Content) as tJsonObject;
    raise Exception.Create((responseJson.P['error'] as tJsonString).Value);
  end;

  if Image <> nil then
  begin
    // send request to update image if indicated
  end;

end;

function TDataModule1.userInfo(username: string): tADODataSet;
var
  url: string;
  response: TRESTResponse;
begin;

  url := format('%s/u/%s', [baseUrl, username]);

  response := sendRequest(url, rmGET);

  Result := responseBodyToDataset(response.Content);

  if Result.Fields.FindField('Status') <> nil then
  begin
    showMessage(Result['Status']);
    Exit;
  end;

end;

// function used to retrieve all important information on an item
// so that is can be displayed on the VIEW ITEM screen and ADDitemScreen
function TDataModule1.viewItem(itemid: string): tADODataSet;
var
  sql, url: string;
  restResponse: TRESTResponse;
  params: tObjectDictionary<string, Variant>;
begin

  url := format('%s/item/%s', [baseUrl, itemid]);

  restResponse := sendRequest(url);

  Result := responseBodyToDataset(restResponse.Content);

  if Result.Fields.FindField('Status') <> nil then
  begin
    showMessage(Result['Status']);
    Exit;
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
