unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, System.Variants, Data.Win.ADODB, Data.DB,
  sCrypt, System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.ComCtrls,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.ExtCtrls, PngImage,
  System.Win.ComObj, ADOInt,
  dateutils, stdctrls, System.JSON, System.Threading, REST.Types,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Client, IdServerIOHandler;

type
  TDataModule1 = class(TDataModule)
    Connection: TADOConnection;
    Query: TADOQuery;
    SellerTB: TADOTable;
    restCLient: TRESTClient;
    restRequest: TRESTRequest;
    restResponse: TRESTResponse;
    timeCheckTimer: TTimer;
    ItemTB: TADOTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure checkIFCartOutdated(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
    // stores these global vairables for all screen
    userID: string;
    // sotres the user's current shopping cart
    CartID: string;
    // used to store the previous form
    // this var is ony changed a few times in the app
    // this is to make sure that pressing back button on Add item screen
    // will go back to the previous screen, as you can access add item screen
    // from either browse items screen or your products screen.
    lastForm: TForm;

  const
    stRevenue = 0;
    stSales = 1;
    stSpending = 2;
    stCF = 3;
    stEU = 4;
    stWU = 5;

    procedure findInTable(table: TADOTable; pk: string; pkVal: string);

    function runSQL(sql: string;
      params: tObjectDictionary<string, Variant> = nil): tADODataSet;

    function Login(Username, password: string): string;
    function SignUp(Username, password, usertype, homeAddress, certificationcode
      : string; imgPfp: tImage): string;

    procedure loadProfilePicture(userID: string; Image: tImage);

    procedure setProfilePicture(userID: string; imgPfp: tImage);

    function userInfo(userID: string): tADODataSet;

    function hasUserBoughtItem(itemID, userID: string): boolean;

    function obtainStats(userID: string; statType: integer;
      DateBegin, DateEnd: tDateTime): tADODataSet;

    function viewItem(itemID: string): tADODataSet;

    procedure insertItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; Image: tImage);

    procedure updateItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; Image: tImage);

    procedure deleteItem(itemID: string);

    function getCategories(): tADODataSet;

    procedure sendRating(userID, itemID: string; rating: integer);

    function getProducts(userID: string; iMin, iMax: integer;
      var numproducts: integer): tADODataSet;

    function getSearchResults(searchQuery: string; categories: TList<string>;
      CFRange, EURange, WURange, resultRange: array of integer;
      var numResults: integer): tADODataSet;

    function isInTable(pkValue: array of Variant; pkName: array of string;
      tbName: string): boolean;

    // methods relating to transaction management
    function CreateUserCart(buyerID: string): string;

    procedure CancelCart(ShoppingCartID: string);

    procedure CheckoutCart(ShoppingCartID: string);

    procedure updateSellerAndBuyer(ShoppingCartID: string);

    procedure EraseCart(ShoppingCartID: string);

    procedure StoreShoppingCart(ShoppingCartID: string);

    function addToCart(ShoppingCartID, itemID: string;
      quantity: integer): string;

    function getCartItems(ShoppingCartID: string): tADODataSet;
    procedure removeFromCart(ShoppingCartItemID: string);

    function getItemInCart(itemID, ShoppingCartID: string): string;

    procedure CommitTransaction();

    procedure RollBack();

    procedure BeginTransaction();

    procedure loadImageFromFile(img: tImage; window: TForm);

    function ImageToVariant(Image: tImage): Variant;

    procedure addFunds(userID: string; amount: double);

    procedure updateRating(userID, itemID: string; rating: integer);
    procedure insertRating(userID, itemID: string; rating: integer);

    function CloneRecordset(const Data: _Recordset): _Recordset;

    function ResizeImage(Image: tImage; width, height: integer): tpngImage;

    function getCartDate(CartID: string): tDateTime;

    function getUserCart(userID: string): string;

    procedure resetCart();

    procedure warnUser();

    procedure addImage(itemID: string; Image: tImage);

    procedure getImage(itemID: string; Image: tImage);

  end;

var
  DataModule1: TDataModule1;
  warnedUser: boolean;

const
  ianaTimezone = 'Africa/Johannesburg';
  maxTimeWithCart = 5;
  timeUntilWarn = 4.5;

implementation

uses
  Checkout_u;

{$R *.dfm}

// increase a given user's balance by a given amount
procedure TDataModule1.addFunds(userID: string; amount: double);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  sql := 'UPDATE UserTB SET Balance = Balance + :Balance WHERE UserID = :UserID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('Balance', amount);
  params.Add('UserID', userID);

  try
    dsResult := runSQL(sql, params);

    // handle db errors
    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally
    FreeAndNil(dsResult);
    FreeAndNil(params);
  end;
end;

// add an item to a user's shopping cart
procedure TDataModule1.addImage(itemID: string; Image: tImage);
begin
  ItemTB.Locate('ItemID', itemID, []);
  ItemTB.Edit;
  ItemTB.FieldByName('Image').Assign(Image.Picture);
  ItemTB.Post;
  ItemTB.Refresh;

end;

function TDataModule1.addToCart(ShoppingCartID, itemID: string;
  quantity: integer): string;
var
  ShoppingCartItemID, sql: string;
  params: tObjectDictionary<string, Variant>;
  i: integer;
  dsResult: tADODataSet;
begin
  BeginTransaction;

  // get the ShoppingCartItemID of a particular item in the user's cart
  try
    ShoppingCartItemID := self.getItemInCart(itemID, ShoppingCartID);

  except
    on e: Exception do
    begin
      raise e;
    end;

  end;

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('Quantity', quantity);

  if ShoppingCartItemID <> '' then
  begin
    // update if item is in user's cart

    sql := 'UPDATE ShoppingCartItemsTB' +
      ' SET Quantity = Quantity + :Quantity WHERE ShoppingCartItemID = :ShoppingCartItemID  ';
    Result := '';
  end
  else
  begin
    // insert item into user's cart if doesn't exist

    // generate new ShoppingCartitemID
    ShoppingCartItemID := ShoppingCartID[1] + itemID[2];
    for i := 1 to 8 do
    begin
      ShoppingCartItemID := ShoppingCartItemID + intToStr(random(10));
    end;
    sql := 'INSERT INTO ShoppingCartItemsTB (ShoppingCartItemID, ItemID, Quantity, ShoppingCartID ) '
      + 'VALUES ( :ShoppingCartItemID, :ItemID, :Quantity, :ShoppingCartID )';

    params.Add('ItemID', itemID);
    params.Add('ShoppingCartID', ShoppingCartID);
  end;

  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  try
    dsResult := runSQL(sql, params);
    if dsResult['Status'] <> 'Success' then
    begin
      RollBack;
      // raise exception
      raise Exception.Create(dsResult['Status']);
    end;


    // update stock
    // check if  there is enough stock to withdraw that quantity

    // Note : not using parameters because it kept giving me bugs
    // this works, and it is unlikely someone will use a shopping cart item id for an sql injection

    sql := 'SELECT ItemTB.Stock, ItemTB.MaxWithdrawableStock, ShoppingCartItemsTB.Quantity '
      + 'FROM ShoppingCartItemsTB, ItemTB WHERE ItemTB.ItemID = :ItemID AND ' +
      ' ShoppingCartItemID = "' + ShoppingCartItemID + '"';

    params.clear;
    params.Add('ItemID', itemID);

    // free memory
    FreeAndNil(dsResult);

    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      RollBack;
      raise Exception.Create(dsResult['Status']);
    end;

    // if retrieving more stock would be impossible
    if dsResult['Stock'] - quantity < 0 then
    begin
      // if not enough stock
      // rollback changes
      RollBack;
      raise Exception.Create('Not enough Stock for this item');
    end
    // if the amount of stock the user wishes to get is over the limit
    // set by the buyer, rollback transaction
    else if dsResult['MaxWithdrawableStock'] < dsResult['Quantity'] then
    begin
      RollBack;
      raise Exception.Create
        ('You are not permitted to withdraw more units at once.');
    end;

    // if all goes well, remove that withdrawn stock from the buyer
    sql := 'UPDATE ItemTB SET Stock = Stock - :Quantity WHERE ItemID = :ItemID';
    params.clear;
    params.Add('Quantity', quantity);
    params.Add('ItemID', itemID);

    FreeAndNil(dsResult);

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin

      // raise exception

      RollBack;
      raise Exception.Create(dsResult['Status']);
    end;

    // commit changes to DB
    CommitTransaction;

    Result := ShoppingCartItemID;

  finally
    FreeAndNil(dsResult);

    FreeAndNil(params);
  end;

end;

procedure TDataModule1.BeginTransaction;
begin
  if not Connection.InTransaction then
    Connection.BeginTrans;
end;

// removes the user's current cart from the database
procedure TDataModule1.CancelCart(ShoppingCartID: string);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateItem: tADODataSet;
begin

  BeginTransaction;
  params := tObjectDictionary<string, Variant>.Create();

  // get the quantity of each iteam in the shopping cart

  sql := 'SELECT ItemID, Quantity FROM ShoppingCartItemsTB WHERE ShoppingCartID = :ShoppingCartID';

  params.Add('ShoppingCartID', ShoppingCartID);

  try
    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      // raise exception
      raise Exception.Create(dsResult['Status']);
    end;

    dsResult.First;

    // for each item in shopping cart, return the withdrawn stock back to the buyer
    sql := 'UPDATE ItemTB SET Stock = Stock + :Quantity WHERE ItemID = :ItemID';

    while not dsResult.Eof do
    begin
      params.clear;

      params.Add('Quantity', dsResult['Quantity']);
      params.Add('ItemID', dsResult['ItemID']);
      dsResultUpdateItem := runSQL(sql, params);

      if dsResultUpdateItem['Status'] <> 'Success' then
      begin
        raise Exception.Create(dsResultUpdateItem['Status']);
      end;
      dsResult.Next;

    end;


    // After you put back the stock, delete the records of
    // the user's current shopping cart from the database

    EraseCart(ShoppingCartID);

    // commit changes to db
    CommitTransaction;

  finally
    FreeAndNil(dsResult);
    FreeAndNil(params);
  end;

end;

procedure TDataModule1.CommitTransaction;
begin

  Connection.CommitTrans;

end;

// For when the users checks out the cart at the metaphorical "till"
procedure TDataModule1.CheckoutCart(ShoppingCartID: string);
begin
  try

    BeginTransaction;

    // copy data of user's shopping cart TransactionTB and TransactionItemTB for record-keeping

    StoreShoppingCart(ShoppingCartID);

    // transfer funds
    updateSellerAndBuyer(ShoppingCartID);


    // Now, Delete all temporary shopping cart records from the database

    EraseCart(ShoppingCartID);

    CommitTransaction;

  except
    on e: Exception do
    begin
      if Connection.InTransaction then
        RollBack;
      raise Exception.Create(e.Message);
    end;

  end;

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
function TDataModule1.CreateUserCart(buyerID: string): string;
var
  sShoppingCartID, sql: string;
  i: integer;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  try
    BeginTransaction;

    // check if user already has a cart
    try
      Result := getUserCart(buyerID);
    except
      on e: Exception do
      begin
        raise Exception.Create(e.Message);
      end
    end;

    if Result <> '' then
      Exit;

    // generate a unique code for the shopping cart
    sShoppingCartID := userID[2];

    for i := 1 to 9 do
    begin
      sShoppingCartID := sShoppingCartID + intToStr(random(10));
    end;

    params := tObjectDictionary<string, Variant>.Create();
    params.Add('ShoppingCartID', sShoppingCartID);
    params.Add('Date', Now);
    params.Add('UserID', buyerID);

    // insert user's shopping cart into database
    sql := 'INSERT INTO ShoppingCartTB (ShoppingCartID, BuyerID, DateCreated) VALUES (:ShoppingCartID, :UserID , :Date)';

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;
    // commit changes
    CommitTransaction;

    Result := sShoppingCartID;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;

end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  Connection.Close;
  // scroll to the right and add in your database name
  Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
    + ExtractFilePath(ParamStr(0)) + 'GreenBagDB.mdb' +
    ';Persist Security Info=False';

  Connection.LoginPrompt := False;

  Connection.Open;

  // Connection for every table you have
  // ADOTable1 must be named ADOtablename(your associated table)
  SellerTB.Connection := Connection;
  ItemTB.Connection := Connection;
  // Each ADOTable is associated with each table name in access
  SellerTB.TableName := 'SellerTB'; // table name spelled as in in MS access
  ItemTB.TableName := 'ItemTB';

  Query.Connection := Connection;

  // open dataset
  SellerTB.Open;
  ItemTB.Open;

  // There reason many tables and datasets are not here is because they were
  // never used without sql, so they are unnecessary and would use
  // unnecessary memory
end;

// Mark an item as deleted
// do not remove any actual records, we need to maintain referential integrity
// between other tables

procedure TDataModule1.deleteItem(itemID: string);
begin
  with DataModule1 do
  begin
    ItemTB.First;

    ItemTB.Edit;

    while not ItemTB.Eof do
    begin
      if ItemTB['ItemID'] = itemID then
      begin
        ItemTB.Edit;
        ItemTB['Deleted'] := True;
      end;
      ItemTB.Next;
    end;
    ItemTB.Edit;
    ItemTB.Post;
    ItemTB.Refresh;
    ItemTB.First;
  end;
end;

// delete all record related to a shopping cart
// this is simplified by setting the ON CASCADE DELETE to true in MS ACCESS
procedure TDataModule1.EraseCart(ShoppingCartID: string);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ShoppingCartID', ShoppingCartID);

  try

    dsResult := runSQL(sql, params);

    // handle db errors
    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally

    FreeAndNil(params);
    FreeAndNil(dsResult);

  end;
end;

// change the cursor of an Adotable to a record with a given field with a given value of string
procedure TDataModule1.findInTable(table: TADOTable; pk, pkVal: string);
var
  bFound: boolean;
begin
  bFound := False;
  table.Open;
  table.First;
  while not table.Eof do
  begin
    if table[pk] = pkVal then
    begin
      bFound := True;
      break;

    end;
    table.Next;
  end;
  if not bFound then
  begin
    raise Exception.Create('Could not find record');
  end;
end;

// get the date that a user's cart was created
function TDataModule1.getCartDate(CartID: string): tDateTime;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  MyClass: TComponent;
begin

  sql := 'SELECT DateCreated FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ShoppingCartID', CartID);

  try

    dsResult := runSQL(sql, params);

    // handle database errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    Result := dsResult['DateCreated'];

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;
end;

// get the list of items in a user's shopping cart
function TDataModule1.getCartItems(ShoppingCartID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin
  // params and sql setup
  params := tObjectDictionary<string, Variant>.Create();

  sql := 'SELECT ShoppingCartItemID, ShoppingCartItemsTB.Quantity,  ' +
    'ShoppingCartItemsTB.ItemID , ItemTB.ItemName ,' +
    ' ItemTB.Cost, ItemTB.MaxWithdrawableStock as MaxStock,  ' +
    ' (ItemTB.CarbonFootprintProduction + ItemTB.CarbonFootprintUsage) AS CF , '
    + ' ( ItemTB.WaterUsageProduction + ItemTB.WaterFootprintUsage) AS WU , ' +
    ' (ItemTB.EnergyUsageProduction + ItemTB.EnergyFootprintUsage) AS EU ' +
    'FROM ShoppingCartItemsTB INNER JOIN ItemTB ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID'
    + ' WHERE ShoppingCartID = :ShoppingCartID';

  params.Add('ShoppingCartID', ShoppingCartID);

  try
    // return sql result
    Result := runSQL(sql, params);

    // handle db errors
    if Result.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(Result['Status']);
    end;

  finally
    FreeAndNil(params);
  end;

end;

// get all the categories of items that exist
function TDataModule1.getCategories: tADODataSet;
var
  sql: string;
begin
  sql := 'SELECT DISTINCT Category FROM ItemTB;';

  Result := runSQL(sql);

end;

// get the all the products made by a particular seller
function TDataModule1.getProducts(userID: string; iMin, iMax: integer;
  var numproducts: integer): tADODataSet;
var
  sql, lastItemId: string;
  params: tObjectDictionary<string, Variant>;
  i: integer;
begin
  sql := 'SELECT ItemTB.ItemID, Sales, Image, ItemName, Revenue ' +
    'FROM ItemTB LEFT JOIN ( SELECT ItemID, ' +
  // iif is a function that takes a condtion, the value to give if true,and the value to give if false
  // this is incase there are no records, preventing null pointer
    ' IIF(SUM(Cost) IS NULL, 0, SUM(Cost)) AS Revenue, ' +
    ' IIF(SUM(Quantity) IS NULL, 0, SUM(Quantity)) AS Sales ' +
    ' FROM TransactionItemTB GROUP BY ItemID ) AS revenueTB  ' +
    ' ON revenueTB.ItemID = ItemTB.ItemID ' +
    ' WHERE SellerID = :SellerID AND Deleted = False ';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('SellerID', userID);

  try
    Result := runSQL(sql, params);

    // handle database errors
    if Result.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(Result['Status']);
    end;

    numproducts := Result.RecordCount;

    // only select the products of a user in the specified range
    if Result.IsEmpty then
      Exit;

    // delete items before lower bound
    Result.First;
    for i := 1 to iMin do
    begin
      Result.Delete;
    end;

    // skip items you want to keep
    for i := 1 to iMax - iMin - 1 do
    begin
      Result.Next;
    end;

    // delete all the items after upper bound

    lastItemId := Result['ItemID'];
    Result.Last;

    while not(lastItemId = Result['ItemID']) do
    begin
      Result.Delete;

    end;

    Result.First;

  finally
    FreeAndNil(params);
  end;

end;

procedure TDataModule1.loadProfilePicture(userID: string; Image: tImage);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  imageStream: tstream;
begin

  sql := 'SELECT ProfileImage FROM UserTB WHERE UserID = :UserID';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('UserID', userID);

  try
    dsResult := runSQL(sql, params);

    // handle database errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    // serialise image into a stream
    imageStream := dsResult.CreateBlobStream
      (dsResult.FieldByName('ProfileImage'), bmRead);
    try
      try
        // set that stream to the image's picture
        Image.Picture.LoadFromStream(imageStream);
      finally
        FreeAndNil(imageStream);
      end;

    except
      raise Exception.Create('Failed to load profile Image');
    end;

  finally
    FreeAndNil(dsResult);
    FreeAndNil(params);

  end;

end;

// Search for items with a specific string and category
function TDataModule1.getSearchResults(searchQuery: string;
  categories: TList<string>; CFRange, EURange, WURange,
  resultRange: array of integer; var numResults: integer): tADODataSet;
var
  sql, categoryParamName: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  i, iNumResults: integer;
  finalItemId: string;

begin

  // sql statement and params
  // does not show deleted items
  sql := ' SELECT  ItemTB.ItemID, ItemName, Cost, Image,' +
    ' (SELECT IIF( Avg(RatingsTB.rating) IS NULL, 0, Avg(RatingsTB.rating) )' +
    ' FROM RatingsTB WHERE RatingsTB.ItemID = ItemTB.ItemID ' +
    ') as avgRating , ' +
    ' (CarbonFootprintProduction + CarbonFootprintUsage) AS CF, ' +
    ' ( EnergyUsageProduction + EnergyFootprintUsage ) AS EU,' +
    '(WaterUsageProduction + WaterFootprintUsage) AS WU, ' +
    ' UserTB.Username as SellerName, SellerID ' +
    'FROM ItemTB INNER JOIN UserTB ON UserTB.UserID = ItemTB.SellerID ' +
    ' WHERE ItemName LIKE :SearchQuery AND (Deleted = False) ';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('SearchQuery', '%' + searchQuery + '%');

  // if the user has specifed a category, use that as a condition as well
  if categories.Count > 0 then
  begin
    for i := 0 to categories.Count - 1 do
    begin
      if i = 0 then
      begin
        sql := sql + ' AND ( ';
      end
      else
      begin
        sql := sql + ' OR ';
      end;

      categoryParamName := 'Category' + intToStr(i);
      sql := sql + ' Category = :' + categoryParamName + ' ';

      if i = categories.Count - 1 then
      begin
        sql := sql + ')';
      end;

      params.Add(categoryParamName, categories.Items[i]);
    end;
  end;


  // parameters are not used here because it bugs out and doesn't work
  // ms access is terrible bugged software

  if length(CFRange) > 0 then
  begin
    sql := sql +
      ' AND ( (CarbonFootprintProduction + CarbonFootprintUsage) BETWEEN ' +
      intToStr(CFRange[0]) + ' AND  ' + intToStr(CFRange[1]) + '  ) ';
  end;

  if length(EURange) > 0 then
  begin
    sql := sql +
      ' AND (( EnergyUsageProduction + EnergyFootprintUsage ) BETWEEN ' +
      intToStr(EURange[0]) + ' AND  ' + intToStr(EURange[1]) + '  ) ';

  end;

  if length(WURange) > 0 then
  begin
    sql := sql + ' AND ( (WaterUsageProduction + WaterFootprintUsage) BETWEEN '
      + intToStr(WURange[0]) + ' AND  ' + intToStr(WURange[1]) + '  ) ';

  end;

  try
    // return the results   within the specified range

    Result := runSQL(sql, params);

    numResults := Result.RecordCount;

    if Result.IsEmpty then
      Exit;

    // select top values in a range
    // not using sql cause it was too buggy and complicated and not worth my time
    Result.First;
    Result.Edit;
    for i := 1 to resultRange[0] do
    begin
      Result.Delete;
    end;

    // skip the ones we want to keep
    for i := 1 to resultRange[1] - resultRange[0] - 1 do
    begin
      Result.Next;
    end;

    if Result.Eof then
      Exit;
    // delete the rest
    finalItemId := Result['ItemID'];

    Result.Last;

    while Result['ItemID'] <> finalItemId do
    begin
      Result.Delete;
    end;

    Result.First;

  finally
    FreeAndNil(params);
  end;

end;

// get the shopping cart that the current user has, if any;
function TDataModule1.getUserCart(userID: string): string;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  //
  sql := 'SELECT ShoppingCartID FROM ShoppingCartTB WHERE buyerId = :UserID';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('UserID', userID);
  try

    dsResult := runSQL(sql, params);
    // handle db errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    // user has no cart
    if dsResult.IsEmpty then
    begin
      Result := '';
      Exit;
    end;

    Result := dsResult['ShoppingCartID'];

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;
end;

function TDataModule1.hasUserBoughtItem(itemID, userID: string): boolean;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  sql := 'SELECT * FROM (SELECT TransactionItemTB.ItemID, BuyerID FROM TransactionTB '
    + ' INNER JOIN TransactionItemTB ON TransactionItemTB.TransactionID ' +
    ' = TransactionTB.TransactionID) WHERE ItemID = :ItemID AND BuyerID = :UserID ';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  params.Add('UserID', userID);

  try
    dsResult := runSQL(sql, params);

    // handle db errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    Result := not dsResult.IsEmpty;
  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;

end;

function TDataModule1.ImageToVariant(Image: tImage): Variant;
var
  imageStream: TBytesStream;

begin

  imageStream := TBytesStream.Create;
  try
    Image.Picture.SaveToStream(imageStream);
    Result := imageStream.Bytes;

  finally
    FreeAndNil(imageStream);
  end;

end;

// returns the shoppingcartItemID of a particular item in a user's cart
// this is so that the program can properly update and read that record
// in the shoppingcartItemTb
procedure TDataModule1.getImage(itemID: string; Image: tImage);
var
  stream: tstream;
begin

  ItemTB.Locate('ItemID', itemID, []);
  stream := ItemTB.CreateBlobStream(ItemTB.FieldByName('Image'), bmRead);
  Image.Picture.LoadFromStream(stream);

end;

function TDataModule1.getItemInCart(itemID, ShoppingCartID: string): STRING;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  // sql statement and params setup
  sql := 'SELECT ShoppingCartItemID FROM ShoppingCartItemsTB WHERE ItemID = :ItemID AND ShoppingCartID = :ShoppingCartID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  params.Add('ShoppingCartID', ShoppingCartID);

  try
    // run sql
    dsResult := runSQL(sql, params);

    // handle errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    if dsResult.IsEmpty then
    begin
      // return emtpy string if the item is not in the cart
      Result := '';
    end
    else
    begin
      // if the item is present in that cart, return its shoppingcartItemID
      Result := dsResult['ShoppingCartItemID'];
    end;
  finally

    FreeAndNil(dsResult);
    FreeAndNil(params);
  end;

end;

// procedure to insert a new item into the database
procedure TDataModule1.insertItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce,
  EUProduce, WUProduce: double; Image: tImage);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;

begin

  sql := 'INSERT INTO ItemTB ( [ItemID], [ItemName], [Cost], ' +
    ' [CarbonFootprintProduction], [WaterUsageProduction], [EnergyUsageProduction], '
    + ' [CarbonFootprintUsage], [WaterFootprintUsage], [EnergyFootprintUsage],'
    + ' [SellerID], [Description], [Category], [Stock], [MaxWithdrawableStock], [Image] ) '
    + 'VALUES ( :ItemID, :ItemName, :Cost, ' +
    ':CarbonFootprintProduction, :WaterUsageProduction, :EnergyUsageProduction, '
    + ':CarbonFootprintUsage, :WaterFootprintUsage, :EnergyFootprintUsage, ' +
    ':SellerID, :Description, :Category, :Stock, :MaxWithdrawableStock, :Image )';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ItemID', itemID);
  params.Add('ItemName', name);
  params.Add('Cost', Price);
  params.Add('CarbonFootprintProduction', CFProduce);
  params.Add('WaterUsageProduction', WUProduce);
  params.Add('EnergyUsageProduction', EUProduce);
  params.Add('CarbonFootprintUsage', CF);
  params.Add('WaterFootprintUsage', WU);
  params.Add('EnergyFootprintUsage', EU);
  params.Add('SellerID', SellerID);
  params.Add('Description', Desc);
  params.Add('Category', category);
  params.Add('Stock', stock);
  params.Add('MaxWithdrawableStock', maxwithdrawstock);
  params.Add('Image', ImageToVariant(Image));

  try

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);

  end;

end;

// insert a new rating from a user if this is the first time rating the item
procedure TDataModule1.insertRating(userID, itemID: string; rating: integer);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  sql := ' INSERT INTO RatingsTB (UserID, ItemID, rating) VALUES ( :UserID, :ItemID, :rating ) ';
  params := tObjectDictionary<string, Variant>.Create();

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  params.Add('UserID', userID);
  params.Add('rating', rating);

  try
    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);

  end;
end;

// a function used to check for whether any records mtching certain conditions
// in a specified table exists
function TDataModule1.isInTable(pkValue: array of Variant;
  pkName: array of string; tbName: string): boolean;
var
  sql: string;
  dParams: tObjectDictionary<String, Variant>;
  dsResult: tADODataSet;
  i: integer;
  paramName: string;
begin
  //
  sql := 'SELECT 1 FROM ' + tbName + ' WHERE ';

  // generate all the parameters
  dParams := tObjectDictionary<string, Variant>.Create();
  for i := 0 to length(pkValue) - 1 do
  begin
    paramName := 'pkVal' + intToStr(i);
    dParams.Add(paramName, pkValue[i]);
    sql := sql + pkName[i] + ' = :' + paramName;
    if not(i = length(pkName) - 1) then
    begin
      sql := sql + ' AND ';
    end;

  end;

  try
    // run sql
    dsResult := runSQL(sql, dParams);

    // handle db errors
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    Result := not dsResult.IsEmpty;

  finally
    FreeAndNil(dsResult);
    FreeAndNil(dParams);
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

// function used to check credentials entered and login a user if successful
function TDataModule1.Login(Username, password: string): string;
var
  sql: string;
  dsResult: tADODataSet;
  params: tObjectDictionary<string, Variant>;
  b: boolean;
begin

  sql := 'SELECT UserID, Password, Salt FROM UserTB WHERE Username = :Username';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('Username', Username);

  try
    dsResult := runSQL(sql, params);

    // handle error occuring whilst trying to access database
    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
      Exit;
    end;


    // check if any users with matching username

    if dsResult.IsEmpty then
    begin
      raise Exception.Create('User does not Exist');
      Exit;
    end;

    // check password match
    b := False;
    if not tScrypt.CheckPassword(UpperCase(Username) + password +
      dsResult['Salt'], dsResult['Password'], b) then
    begin
      raise Exception.Create('Incorrect Password');
      Exit;
    end;

    // return the corresponding user id of the user that the program can use
    // for functions
    Result := dsResult['UserID'];

  finally
    FreeAndNil(dsResult);
    FreeAndNil(params);
  end;

end;

// this table doesn't use StatsTB, as it is unnecessary and full of redundancy
// and calculated fields, so i deleted the table and instead calculated using
// transaction history
function TDataModule1.obtainStats(userID: string; statType: integer;
  DateBegin, DateEnd: tDateTime): tADODataSet;
var
  fieldToAnalyse: string;
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin;

  // based on what the category of statistic you want to get
  // choose which field in the transactionTB to analyse in order to get statistics
  case statType of
    stRevenue:
      begin
        fieldToAnalyse := 'TransactionItemTB.Cost';
      end;
    stSales:
      begin
        fieldToAnalyse := 'Quantity';
      end;
    stSpending:
      begin
        fieldToAnalyse := 'TransactionItemTB.Cost';
      end;
    stCF:
      begin
        fieldToAnalyse := 'CF';
      end;
    stEU:
      begin
        fieldToAnalyse := 'EU';
      end;
    stWU:
      begin
        fieldToAnalyse := 'WU';
      end;

  end;

  sql := 'SELECT SUM(' + fieldToAnalyse + ') as TotalMonth , ' +
    'YEAR(TransactionDate) as y , MONTH(TransactionDate) as m ' + 'FROM ';

  // create sql based on whether your looking from the perspective of the seller
  // or the buyer
  if (statType <> stRevenue) and (statType <> stSales) then
  begin
    sql := sql + ' TransactionItemTB ' +
      'INNER JOIN TransactionTB ON TransactionItemTB.TransactionID = TransactionTB.TransactionID '
      + ' WHERE BuyerID = :UserID AND TransactionDate BETWEEN :MonthBegin AND :MonthEnd';
  end
  else
  begin
    sql := sql + '( TransactionItemTB ' +
      'INNER JOIN TransactionTB ON TransactionItemTB.TransactionID = TransactionTB.TransactionID ) '
      + ' INNER JOIN ItemTB ON TransactionItemTB.ItemID = ItemTB.ItemID ' +
      'WHERE SellerID = :UserID AND TransactionDate BETWEEN :MonthBegin AND :MonthEnd';
  end;

  sql := sql + ' GROUP BY YEAR(TransactionDate), MONTH(TransactionDate)' +
    ' ORDER BY YEAR(TransactionDate) ASC, MONTH(TransactionDate) ASC';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);
  params.Add('MonthBegin', DateBegin);
  params.Add('MonthEnd', DateEnd);

  try

    Result := runSQL(sql, params);

  finally
    FreeAndNil(params);
  end;

end;

// remove an item from a user's cart
procedure TDataModule1.removeFromCart(ShoppingCartItemID: string);
var
  sql: string;
  dsResult, dsResultItemInfo: tADODataSet;
  params: tObjectDictionary<string, Variant>;
  quantity: integer;
  itemID: string;
begin

  // use transaction processing to ensure that if any problem occurs
  // all transactions will be rolled back
  BeginTransaction;


  // get cart item's details

  sql := 'SELECT Quantity, ItemID FROM ShoppingCartItemsTB WHERE ShoppingCartItemID = :ShoppingCartItemID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  try
    dsResultItemInfo := runSQL(sql, params);

    if dsResultItemInfo.Fields.FindField('Status') <> nil then
    begin
      // raise exception
      raise Exception.Create(dsResult['Status']);
    end;

    if dsResultItemInfo.IsEmpty then
    begin
      RollBack;
      showMessage('Error: Could not find ShoppingCart Item');
      // rollback
      Exit;
    end;
    quantity := dsResultItemInfo['Quantity'];
    itemID := dsResultItemInfo['ItemID'];

    FreeAndNil(dsResultItemInfo);
    params.clear;

    // update stock

    sql := 'UPDATE ItemTB SET Stock = Stock + :Quantity WHERE ItemID = :ItemID';
    params.Add('Quantity', quantity);
    params.Add('ItemID', itemID);

    dsResult := runSQL(sql, params);
    params.clear;

    if dsResult['Status'] <> 'Success' then
    begin
      // raise exception
      raise Exception.Create(dsResult['Status']);
    end;

    params.clear;

    // delete from shoppingcart

    sql := 'DELETE FROM ShoppingCartItemsTB WHERE ShoppingCartItemID = :ShoppingCartItemID';

    params.Add('ShoppingCartItemID', ShoppingCartItemID);

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      // raise exception
      raise Exception.Create(dsResult['Status']);
    end;

    // commit changes if no error occurs
    CommitTransaction;

  finally
    FreeAndNil(dsResult);
    FreeAndNil(dsResultItemInfo);
    FreeAndNil(params);
  end;

end;

// method to call to update the gui after a cart has expired
procedure TDataModule1.resetCart;
begin
  warnedUser := False;
  self.CancelCart(self.CartID);
  self.CartID := self.CreateUserCart(self.userID);
  if frmCHeckout.Items <> nil then
    frmCHeckout.Items.clear;
  showMessage('Your cart has expired! You are now using a new cart.');
end;

// to prevent users from permanently holding onto items in their cart
// the Ttimer  will check every set interval once the user logs in
// to check whether the user's cart has expired
// to do this, we sened an http get request to an api to get the current time
// for our timezone
// the reason we do this is in case a user changes their system date and time
// to prevent our program from returning stock.
// LINK TO THE API: https://timeapi.io/swagger/index.html
procedure TDataModule1.checkIFCartOutdated;
var
  sBody, sDate: string;
  jsonObject: tJsonObject;
  serverDateTime, cartDateTime, minutesSinceCartCreation: tDateTime;
  sql: string;
  dsResult: tADODataSet;

begin

  try

    // this runs the code in a separate thread to prevent blocking the main
    // thread which is responsible for gui
    TTask.Run(
      procedure()
      begin

        // set the timezone for the api request
        restRequest.params[0].value := ianaTimezone;

        // execute request
        restRequest.Execute;

        // extract the body of the response
        sBody := restResponse.Content;

        // parse the body of the response as a json
        jsonObject := tJsonObject.ParseJSONValue(sBody) as tJsonObject;

        // get date as string and format it correclty
        jsonObject.Values['dateTime'].TryGetValue(sDate);
        sDate := copy(sDate.Replace('T', ' ').Replace('-', '/'), 1,
          LastDelimiter('.', sDate) - 1);

        // convert the date from the api to a datetime object
        serverDateTime := strtodatetime(sDate);

        // get that date the cart was created

        TThread.CurrentThread.Synchronize(nil,
          procedure()
          begin
            cartDateTime := self.getCartDate(self.CartID);
          end);

        minutesSinceCartCreation := ((serverDateTime - cartDateTime) * 1440);

        // check if enough time has elapsed
        if minutesSinceCartCreation > maxTimeWithCart then
        begin
          // return cart once it has expired
          // ensure this is thread safe with gui rendering screen
          TThread.CurrentThread.Synchronize(nil,
            procedure
            begin
              warnedUser := False;
              self.CancelCart(self.CartID);
              self.CartID := self.CreateUserCart(self.userID);
              if frmCHeckout.Items <> nil then
                frmCHeckout.Items.clear;
              showMessage
                ('Your cart has expired! You are now using a new cart.');
            end);

        end
        else if (minutesSinceCartCreation < maxTimeWithCart) and
          (minutesSinceCartCreation > timeUntilWarn) then
        begin
          TThread.Current.Synchronize(nil,
            procedure()
            begin
              // warn user their cart is soon expiring \
              if not warnedUser then
              begin
                warnedUser := True;
                showMessage('You have less than 30s before your cart expires.');
              end;
            end);
        end;

      end);

  except
    on e: Exception do
    begin
      raise e;
    end

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
    FreeAndNil(ResizedImage);

  end;

end;

procedure TDataModule1.RollBack;
begin
  // Rollbacks any transactions
  Connection.RollbackTrans;
end;

// general function that is used to send any sql to the databse and return a result
function TDataModule1.runSQL(sql: string;
params: tObjectDictionary<string, Variant> = nil): tADODataSet;
var
  dsOutput: tADODataSet;
  Item: TPair<string, Variant>;
begin

  // close previous query
  Query.Close;
  Query.sql.clear;
  Query.sql.Add(sql);

  // assign parameters to query
  if Assigned(params) then
  begin
    for Item in params do
    begin
      Query.Parameters.ParamByName(Item.Key).value := Item.value;
    end;

  end;
  // create output dataset to show result
  dsOutput := tADODataSet.Create(Nil);
  dsOutput.FieldDefs.Add('Status', TFieldType(1), 100);
  dsOutput.CreateDataSet;
  // dsOutput.ExecuteOptions := [eoAsyncExecute, eoAsyncFetchNonBlocking];
  try
    try
      begin
        if UpperCase(copy(trim(sql), 1, 6)) = 'SELECT' then
        begin
          // read
          // read data from sql into output dataset
          Query.Open;
          dsOutput := tADODataSet.Create(Nil);
          dsOutput.Recordset := CloneRecordset(Query.Recordset);
        end
        else
        begin
          // Create update delete
          Query.Prepared := True;
          Query.ExecSQL;

          dsOutput.InsertRecord(['Success']);
        end;

      end;
    except
      // catch any errors that occur
      on e: EADOError do
      begin
        // if there query is in a group of transactions,
        // rollback all other transactions in the case of an error
        if Connection.InTransaction then
          RollBack;

        dsOutput.InsertRecord([e.Message]);

      end;
      on e: EDatabaseError do
      begin
        if Connection.InTransaction then
          RollBack;
        dsOutput.InsertRecord([e.Message]);

      end;
      on e: EOleException do
      begin
        if Connection.InTransaction then
          RollBack;
        dsOutput.InsertRecord([e.Message]);

      end;
    end;
  finally
    Result := dsOutput;
  end;

end;

// allows a user to send a rating from 1 to 5 on an item
procedure TDataModule1.sendRating(userID, itemID: string; rating: integer);
var
  dsResult: tADODataSet;
begin

  try

    if not hasUserBoughtItem(itemID, userID) then
    begin
      raise Exception.Create('You must first buy an item before rating it!');
    end;

    if isInTable([userID, itemID], ['UserID', 'ItemID'], 'RatingsTB') then
    begin
      updateRating(userID, itemID, rating);
    end
    else
    begin
      insertRating(userID, itemID, rating);
    end;

  except
    on e: Exception do
    begin
      raise Exception.Create(e.Message);
    end;

  end;

end;

// set the profile picture of a given use using a given image
procedure TDataModule1.setProfilePicture(userID: string; imgPfp: tImage);
var
  sql: string;
  params: tObjectDictionary<String, Variant>;
  dsResult: tADODataSet;
begin
  sql := 'UPDATE UserTB SET ProfileImage = :ProfileImage WHERE UserID = :UserID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);
  params.Add('ProfileImage', ImageToVariant(imgPfp));

  try
    dsResult := runSQL(sql, params);

    // handle db errors

    if dsResult['status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['status']);
    end;

  finally
    // free memory
    FreeAndNil(dsResult);
    FreeAndNil(params);
  end;

end;

// a function used to create a new user in the database and return the new user's userid for use by the program
function TDataModule1.SignUp(Username, password, usertype, homeAddress,
  certificationcode: string; imgPfp: tImage): string;
var
  hash, salt: string;
  userID, sql: string;
  params: tObjectDictionary<String, Variant>;
  i: integer;
  dsResult: tADODataSet;
begin

  // generate the random salt
  salt := '';
  for i := 0 to 9 do
  begin

    case random(3) of

      0:
        salt := salt + chr(ord('a') + random(26));
      1:
        salt := salt + chr(ord('A') + random(26));
      2:
        salt := salt + intToStr(random(10));

    end;

  end;

  // salt the password, as well as add the uppercase username to act as a pepper for extra security
  // this helps prevent dictionary attacks
  hash := tScrypt.HashPassword(UpperCase(Username) + password + salt);
  // generate random userID

  userID := UpperCase(usertype[1] + Username[1]);

  for i := 1 to 8 do
  begin
    userID := userID + intToStr(random(10))
  end;

  // sql statement
  sql := 'INSERT INTO UserTB ([UserID], [Username], [Password], [UserType], [HomeAddress], [Salt], [ProfileImage]) VALUES'
    + ' ( :UserID, :Username, :Password, :UserType, :HomeAddress, :Salt, :ProfileImage);';

  // input parameters
  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);
  params.Add('Username', Username);
  params.Add('Password', hash);
  params.Add('UserType', usertype);
  params.Add('HomeAddress', homeAddress);
  params.Add('Salt', salt);
  params.Add('ProfileImage', ImageToVariant(imgPfp));

  try
    try
      dsResult := runSQL(sql, params);

      // handle errors
      if dsResult['Status'] <> 'Success' then
      begin
        raise Exception.Create(dsResult['Status']);
      end;



      // if user is a seller, set up a corresponding record in seller tb as well

      if usertype = 'SELLER' then
      begin

        with SellerTB do
        begin
          SellerTB.Insert;

          SellerTB['UserID'] := userID;
          SellerTB['Revenue'] := 0.0;
          SellerTB['CertificationCode'] := certificationcode;

          SellerTB.Post;
          SellerTB.Refresh;
          SellerTB.First;
        end;

      end;

      Result := userID;

    except

      on e: Exception do
      begin
        raise Exception.Create(e.Message);
      end;

    end;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;

end;

// copy the records for temporary ShoppingCartTB and ShoppingCartItemsTB
// must be part of a transaction group so it can be rolled back in the case of errors
procedure TDataModule1.StoreShoppingCart(ShoppingCartID: string);
var
  sql: string;
  dsResult: tADODataSet;
  params: tObjectDictionary<String, Variant>;
begin

  // copy fist into transactionTB
  sql := 'INSERT INTO TransactionTB (TransactionID, BuyerID, TransactionDate ) '
    + 'SELECT ShoppingCartID, BuyerID, DateCreated FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';

  params := tObjectDictionary<String, Variant>.Create();
  params.Add('ShoppingCartID', ShoppingCartID);
  try
    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    FreeAndNil(dsResult);

    // Then for TransactionItemTB
    sql := 'INSERT INTO TransactionItemTB (CartItemID, ItemID, Quantity, TransactionID, Cost, CF, EU, WU) '
      + 'SELECT ShoppingCartItemID, ShoppingCartItemsTB.ItemID, Quantity, ' +
      'ShoppingCartID, (Cost * Quantity) AS TotalCost,' +
      ' (( CarbonFootprintProduction + CarbonFootprintUsage )* Quantity ) AS CF , '
      + ' (( EnergyUsageProduction + EnergyFootprintUsage )* Quantity ) AS EU, '
      + ' (( WaterUsageProduction + WaterFootprintUsage )* Quantity ) AS WU ' +
      'FROM ShoppingCartItemsTB ' +
      ' INNER JOIN ItemTB ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID ' +
      ' WHERE ShoppingCartID  = :ShoppingCartID ';

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;
end;

procedure TDataModule1.updateItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce,
  EUProduce, WUProduce: double; Image: tImage);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  sql := 'UPDATE ItemTB SET [ItemName] = :ItemName, [Cost] = :Cost, ' +
    ' [CarbonFootprintProduction] = :CarbonFootprintProduction,' +
    ' [WaterUsageProduction] = :WaterUsageProduction,' +
    ' [EnergyUsageProduction] = :EnergyUsageProduction, ' +
    ' [CarbonFootprintUsage] = :CarbonFootprintUsage' +
    ' , [WaterFootprintUsage] = :WaterFootprintUsage,' +
    ' [EnergyFootprintUsage] = :EnergyFootprintUsage, [SellerID] = :SellerID,' +
    ' [Description] = :Description, [Category] = :Category, [Stock] = :Stock, '
    + ' [MaxWithdrawableStock] = :MaxWithdrawableStock , [Image] = :Image  ' +
    ' WHERE [ItemID] = :ItemID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ItemID', itemID);
  params.Add('ItemName', name);
  params.Add('Cost', Price);
  params.Add('CarbonFootprintProduction', CFProduce);
  params.Add('WaterUsageProduction', WUProduce);
  params.Add('EnergyUsageProduction', EUProduce);
  params.Add('CarbonFootprintUsage', CF);
  params.Add('WaterFootprintUsage', WU);
  params.Add('EnergyFootprintUsage', EU);
  params.Add('SellerID', SellerID);
  params.Add('Description', Desc);
  params.Add('Category', category);
  params.Add('Stock', stock);
  params.Add('MaxWithdrawableStock', maxwithdrawstock);
  params.Add('Image', ImageToVariant(Image));

  try

    dsResult := runSQL(sql, params);

    // handle db errors
    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;

end;

// use this if a user has already given a review, and want to change their review
procedure TDataModule1.updateRating(userID, itemID: string; rating: integer);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  sql := ' UPDATE RatingsTB SET rating = :rating WHERE ItemID = :ItemID AND UserID = :UserID';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  params.Add('UserID', userID);
  params.Add('rating', rating);

  try
    dsResult := runSQL(sql, params);

    // handle db errors
    if dsResult['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;
  finally

    // free memory
    FreeAndNil(params);
    FreeAndNil(dsResult);

  end;

end;

// bill the buyer for their shopping cart
// and pay each of the sellers that the buyer bought from
// must be done in a transaction group
procedure TDataModule1.updateSellerAndBuyer(ShoppingCartID: string);
var
  sql, sqlUpdateBuyer, sqlUpdateItem, sqlUpdateSeller: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateSeller, dsResultUpdateBuyer: tADODataSet;
  buyerID: string;
  buyerBalance, itemPrice: double;
begin
  try
    // select user's id and balance

    sql := 'SELECT BuyerID, UserTB.Balance FROM ShoppingCartTB' +
      ' INNER JOIN UserTB ON UserTB.UserID = ShoppingCartTB.BuyerID ' +
      'WHERE ShoppingCartID = :ShoppingCartID  ';

    params := tObjectDictionary<string, Variant>.Create();
    params.Add('ShoppingCartID', ShoppingCartID);

    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    buyerID := dsResult['BuyerID'];
    buyerBalance := dsResult['Balance'];

    FreeAndNil(dsResult);

    // Select all relevant data on the items and Seller for each item in user's cart

    sql := 'SELECT ShoppingCartItemsTB.Quantity, ShoppingCartItemsTB.ItemID, ItemTB.Cost'
      + ' , ItemTB.SellerID ' +
      ' FROM ((ShoppingCartItemsTB INNER JOIN ShoppingCartTB ' +
      'ON ShoppingCartItemsTB.ShoppingCartID = ShoppingCartTB.ShoppingCartID) '
      + 'INNER JOIN ItemTB ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID )' +
      'WHERE ShoppingCartItemsTB.ShoppingCartID = :ShoppingCartID';

    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    params.clear;

    // Once you have all of the necessary data
    // transfer money from buyer to sender

    // lower the user's balance
    sqlUpdateBuyer :=
      'UPDATE UserTB SET Balance = :Balance WHERE UserID = :UserID ';

    // increase the seller's revenue
    sqlUpdateSeller :=
      'UPDATE SellerTB SET Revenue = Revenue + :Revenue WHERE UserID = :SellerID';

    dsResult.First;

    while not dsResult.Eof do
    begin
      // update buyer

      itemPrice := dsResult['Cost'] * dsResult['Quantity'];
      buyerBalance := buyerBalance - itemPrice;

      if buyerBalance < 0 then
      begin
        // Rollback in case of insufficient funds from user
        RollBack;
        raise Exception.Create('Out of balance');
      end;

      // if sufficient funds remove from user's account
      params.clear;
      params.Add('Balance', buyerBalance);
      params.Add('UserID', buyerID);

      dsResultUpdateBuyer := runSQL(sqlUpdateBuyer, params);

      if dsResultUpdateBuyer['Status'] <> 'Success' then
      begin
        raise Exception.Create(dsResult['Status']);
      end;

      FreeAndNil(dsResultUpdateBuyer);

      // update seller's revenue amount

      params.clear;
      params.Add('Revenue', itemPrice);
      params.Add('SellerID', dsResult['SellerID']);

      dsResultUpdateSeller := runSQL(sqlUpdateSeller, params);
      if dsResultUpdateSeller['Status'] <> 'Success' then
      begin
        raise Exception.Create(dsResult['Status']);

      end;

      FreeAndNil(dsResultUpdateSeller);

      dsResult.Next;
    end;

  finally

    FreeAndNil(dsResultUpdateBuyer);

    FreeAndNil(dsResultUpdateSeller);

    FreeAndNil(dsResult);

    FreeAndNil(params);

  end;

end;

function TDataModule1.userInfo(userID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  // select user's current balance and type of user
  sql := 'SELECT Username, UserType, Balance, ProfileImage FROM UserTB WHERE UserID = :UserID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);

  try
    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      Exit;
    end;

    if dsResult.IsEmpty then
    begin
      showMessage('No user with userID');
      Exit;
    end;

    Result := tADODataSet.Create(nil);
    Result.FieldDefs.Add('Username', TFieldType(1), 100);
    Result.FieldDefs.Add('UserType', TFieldType(1), 10);
    Result.FieldDefs.Add('ProfileImage', ftBlob);
    Result.FieldDefs.Add('Balance', ftFloat);
    Result.FieldDefs.Add('Revenue', ftFloat);
    Result.FieldDefs.Add('TotalSales', TFieldType(3));
    Result.FieldDefs.Add('TotalEU', ftFloat);
    Result.FieldDefs.Add('TotalWU', ftFloat);
    Result.FieldDefs.Add('TotalCF', ftFloat);
    Result.FieldDefs.Add('TotalSpending', TFieldType(7));
    Result.CreateDataSet;

    // todo : clean this maybe
    Result.Insert;
    Result.Edit;
    Result['UserType'] := dsResult['UserType'];
    Result.Edit;
    Result['Balance'] := dsResult['Balance'];
    Result.Edit;
    Result['Username'] := dsResult['Username'];
    Result.Edit;
    Result['ProfileImage'] := dsResult['ProfileImage'];

    Result.First;

    // if user is a seller, get sales and revenue
    if dsResult['UserType'] = 'SELLER' then
    begin

      sql := 'SELECT Revenue FROM SellerTB WHERE UserID = :UserID';

      dsResult := runSQL(sql, params);

      if dsResult.Fields.FindField('Status') <> nil then
      begin
        showMessage(dsResult['Status']);
        Exit;
      end;

      if dsResult.IsEmpty then
        showMessage('Empty sql result');

      Result.Edit;
      Result['Revenue'] := dsResult['Revenue'];

      sql := 'SELECT IIF(SUM(Sales) IS NULL, 0, SUM(Sales) ) ' +
        'AS TotalSales FROM ItemTB LEFT JOIN ' +
        ' ( SELECT ItemID, IIF(SUM(Quantity) IS NULL, 0, SUM(Quantity)) AS Sales '
        + 'FROM TransactionItemTB GROUP BY ItemID ) ' +
        'as salesTB ON salesTB.ItemID = ItemTB.ItemID  ' +
        'WHERE SellerID = :UserID';

      dsResult := runSQL(sql, params);
      Result.Edit;
      Result['TotalSales'] := dsResult['TotalSales'];

    end;

    // for all users
    // select total spending

    sql := 'SELECT IIF(Sum(Cost) IS NULL ,0 ,Sum(Cost)) AS totalCost, ' +
      ' IIF(Sum(CF) IS NULL ,0 ,Sum(CF)) AS totalCF, ' +
      ' IIF(Sum(EU) IS NULL ,0 ,Sum(EU)) AS totalEU,' +
      ' IIF(Sum(WU) IS NULL ,0 ,Sum(WU)) AS totalWU ' +
      'FROM TransactionItemTB INNER JOIN TransactionTB ON TransactionTB.TransactionID = TransactionItemTB.TransactionID'
      + ' WHERE BuyerID = :UserID ';
    params.clear;
    params.Add('UserID', userID);

    dsResult := runSQL(sql, params);

    Result.Edit;

    Result['TotalSpending'] := dsResult['totalCost'];
    Result['TotalCF'] := dsResult['totalCF'];
    Result['TotalEU'] := dsResult['totalEU'];
    Result['TotalWU'] := dsResult['totalWU'];

  finally
    FreeAndNil(params);
    FreeAndNil(dsResult);
  end;

end;

// function used to retrieve all important information on an item
// so that is can be displayed on the VIEW ITEM screen and ADDitemScreen
function TDataModule1.viewItem(itemID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  sql := 'SELECT *, UserTB.Username AS SellerName, ' +
    '(SELECT IIF(Avg(rating) IS NULL, -1,Avg(rating) ) FROM RatingsTB WHERE RatingsTB.ItemID = ItemTB.ItemID ) AS avgRating FROM '
    + 'ItemTB INNER JOIN UserTB ON ItemTb.SellerID = UserTB.UserID ' +
    'WHERE ItemTB.ItemID = :ItemID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);

  try
    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
    end;

    if dsResult.IsEmpty then
    begin
      dsResult.Close;
      dsResult.FieldDefs.Add('Status', TFieldType(1), 100);
      dsResult.CreateDataSet;
      dsResult.Insert;
      dsResult['Status'] := 'Error: Item does not exist.'
    end;

    Result := dsResult;

  finally
    FreeAndNil(params);
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
