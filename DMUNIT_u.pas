unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB,
  sCrypt, System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.Graphics, Vcl.ExtCtrls, System.Variants, PngImage, System.Win.ComObj,
  dateutils;

type
  TDataModule1 = class(TDataModule)
    Connection: TADOConnection;
    Query: TADOQuery;
    UserTB: TADOTable;
    ItemTB: TADOTable;
    StatsTB: TADOTable;
    TransactionItemTB: TADOTable;
    TransactionTB: TADOTable;
    SellerTB: TADOTable;
    dsUserTB: TDataSource;
    dsSellerTB: TDataSource;
    dsItemTB: TDataSource;
    dsTransactionTB: TDataSource;
    dsStatsTB: TDataSource;
    dsTransactionItemTB: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public


    { Public declarations }
    // stores these global vairables for all screen
    userID: string;
    CartID: string;
    dDate: tDate;

    procedure findInTable(table: TADOTable; pk: string; pkVal: string);

    function runSQL(sql: string;
      params: tObjectDictionary<string, Variant> = nil): tADODataSet;

    function Login(Username, password: string): string;
    function SignUp(Username, password, usertype, homeAddress, certificationcode
      : string): string;

    function userInfo(userID: string): tADODataSet;

    function obtainStats(userID, statType: string;
      DateBegin, DateEnd: tDateTime): tADODataSet;

    function viewItem(itemID: string): tADODataSet;

    procedure insertItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; Image: tPngImage);

    procedure updateItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce, EUProduce,
      WUProduce: double; Image: tPngImage);

    procedure deleteItem(itemID: string);

    function getCategories(): tADODataSet;

    procedure sendRating(itemID: string; rating: integer);

    function getProducts(userID: string): tADODataSet;

    function getSearchResults(searchQuery, category: string): tADODataSet;

    function isInTable(pkValue: array of Variant; pkName: array of string;
      tbName: string): boolean;

    // methods relating to transaction management
    function CreateUserCart(userID: string): string;

    procedure CancelCart(ShoppingCartID: string);

    procedure CheckoutCart(ShoppingCartID: string);

    function addToCart(ShoppingCartID, itemID: string;
      quantity: integer): string;

    function getCartItems(ShoppingCartID: string): tADODataSet;
    procedure removeFromCart(ShoppingCartItemID: string);

    function getItemInCart(itemID, ShoppingCartID: string): string;

    procedure CommitTransaction();

    procedure RollBack();

    procedure BeginTransaction();

    procedure updateStats(ShoppingCartID: string);

    procedure insertStatData(userID: string; statDate: tDateTime;
      statType: string; value: double);
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

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
      raise e
    end;

  end;

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('Quantity', quantity);

  if ShoppingCartItemID <> '' then
  begin
    // update if item is in user's cart
    params.Add('ShoppingCartItemID', ShoppingCartItemID);
    sql := 'UPDATE ShoppingCartItemsTB' +
      ' SET Quantity = Quantity + :Quantity WHERE ShoppingCartItemID = :ShoppingCartItemID  ';
    Result := '';
  end
  else
  begin
    // insertitem into user's cart if doesn't exist

    // generate new ShoppingCartitemID
    ShoppingCartItemID := ShoppingCartID[1] + itemID[2];
    for i := 1 to 8 do
    begin
      ShoppingCartItemID := ShoppingCartItemID + intToStr(random(10));
    end;
    sql := 'INSERT INTO ShoppingCartItemsTB (ShoppingCartItemID, ItemID, Quantity, ShoppingCartID ) '
      + 'VALUES ( :ShoppingCartItemID, :ItemID, :Quantity, :ShoppingCartID )';

    params.Add('ItemID', itemID);
    params.Add('ShoppingCartItemID', ShoppingCartItemID);
    params.Add('ShoppingCartID', ShoppingCartID);
    Result := ShoppingCartItemID;
  end;

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    // deallocate memory for query result
    dsResult.Free;
    // raise exception
    raise Exception.Create(dsResult['Status']);
  end;


  // update stock

  // check if  there is enough stock to withdraw that quantity

  // DAFUCK IS UP WITH PARAMETERS NOT WORKING

  sql := 'SELECT ItemTB.Stock, ItemTB.MaxWithdrawableStock, ShoppingCartItemsTB.Quantity '
    + 'FROM ShoppingCartItemsTB, ItemTB' + ' WHERE ItemTB.ItemID = :ItemID AND '
    + ' ShoppingCartItemID = "' + ShoppingCartItemID + '"';

  params.clear;
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin

    raise Exception.Create(dsResult['Status']);
  end;

  if dsResult['Stock'] - quantity < 0 then
  begin
    // if not enough stock
    // rollback changes
    showMessage(dsResult['Stock']);
    RollBack;
    // deallocate memory for query result
    dsResult.Free;
    raise Exception.Create('Not enough Stock for this item');
  end
  // if the amount of stock the user wishes to get is over the limit
  // set by the buyer, rollback transaction
  else if dsResult['MaxWithdrawableStock'] < dsResult['Quantity'] then
  begin
    RollBack;
    dsResult.Free;
    raise Exception.Create
      ('You are not permitted to withdraw more units at once.');
  end;

  // if all goes well, remove that withdrawn stock from the buyer
  sql := 'UPDATE ItemTB SET Stock = Stock - :Quantity WHERE ItemID = :ItemID';
  params.clear;
  params.Add('Quantity', quantity);
  params.Add('ItemID', itemID);
  dsResult := runSQL(sql, params);
  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    // deallocate memory for query result
    dsResult.Free;
    // raise exception
    raise Exception.Create(dsResult['Status']);
  end;

  // commit changes to DB
  CommitTransaction;
  dsResult.Free;

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

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    // deallocate memory for query result
    dsResult.Free;
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
      dsResult.Free;
      raise Exception.Create(dsResultUpdateItem['Status']);
    end;
    dsResult.Next;

  end;

  // deallocate memory for query result
  dsResult.Free;


  // After you put back the stock, delete the records of
  // the user's current shopping cart from the database

  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params.clear;

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    exit;
  end;

  // commit changes to db
  CommitTransaction;
  dsResult.Free;

end;

procedure TDataModule1.CommitTransaction;
begin

  Connection.CommitTrans;

end;

// For when the users checks out the cart at the metaphorical "till"
procedure TDataModule1.CheckoutCart(ShoppingCartID: string);
var
  sql, sqlUpdateBuyer, sqlUpdateItem, sqlUpdateSeller: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateItem, dsResultUpdateSeller, dsResultUpdateBuyer
    : tADODataSet;
  BuyerID: string;
  buyerBalance, itemPrice: double;
  MyClass: TComponent;
begin

  BeginTransaction;

  // copy data of user's shopping cart TransactionTB and TransactionItemTB for record-keeping
  // first do it for TRANSACTIONTB
  sql := 'INSERT INTO TransactionTB (TransactionID, BuyerID) ' +
    'SELECT ShoppingCartID, BuyerID FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;
  dsResult.Free;

  // Then for TransactionItemTB
  sql := 'INSERT INTO TransactionItemTB (CartItemID, ItemID, Quantity, TransactionID) '
    + 'SELECT ShoppingCartItemID, ItemID, Quantity, ShoppingCartID FROM ShoppingCartItemsTB WHERE ShoppingCartID  = :ShoppingCartID ';

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  dsResult.Free;

  // Next, select user's id and balance

  sql := 'SELECT BuyerID, UserTB.Balance FROM ShoppingCartTB' +
    ' INNER JOIN UserTB ON UserTB.UserID = ShoppingCartTB.BuyerID ' +
    'WHERE ShoppingCartID = :ShoppingCartID  ';

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  BuyerID := dsResult['BuyerID'];
  buyerBalance := dsResult['Balance'];

  // Select all relevant data on the items and Seller for each item in user's cart

  sql := 'SELECT Quantity, ShoppingCartItemsTB.ItemID, ItemTB.Cost' +
    ' , ItemTB.SellerID, BuyerID ' +

    ' FROM (((ShoppingCartItemsTB ' + ' INNER JOIN ShoppingCartTB ' +
    'ON ShoppingCartItemsTB.ShoppingCartID = ShoppingCartTB.ShoppingCartID) ' +
    'INNER JOIN UserTB ' + 'ON ShoppingCartTB.BuyerID = UserTB.UserID )' +
    'INNER JOIN ItemTB ' + 'ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID )' +
    'WHERE ShoppingCartItemsTB.ShoppingCartID = :ShoppingCartID';

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  params.clear;

  // Once you have all of the necessary data
  // transfer money from buyer to sender

  // update number of sales of each item
  sqlUpdateItem :=
    'UPDATE ItemTB SET Sales = Sales + :Sales WHERE ItemID = :ItemID';

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

    itemPrice := (dsResult['Quantity'] * dsResult['Cost']);
    buyerBalance := buyerBalance - itemPrice;

    if buyerBalance < 0 then
    begin
      // Rollback in case of insufficient funds from user
      RollBack;
      raise Exception.Create('Out of balance');
    end;

    // if sufficient funds add remove from user's account
    params.clear;
    params.Add('Balance', buyerBalance);
    params.Add('UserID', BuyerID);

    dsResultUpdateBuyer := runSQL(sqlUpdateBuyer, params);

    if dsResultUpdateBuyer['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    dsResultUpdateBuyer.Free;

    // update item's number of units sold

    params.clear;

    params.Add('ItemID', dsResult['ItemID']);

    params.Add('Sales', dsResult['Quantity']);
    dsResultUpdateItem := runSQL(sqlUpdateItem, params);

    if dsResultUpdateItem['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;
    dsResultUpdateItem.Free;


    // update seller's revenue amount

    params.clear;
    params.Add('Revenue', itemPrice);
    params.Add('SellerID', dsResult['SellerID']);

    dsResultUpdateSeller := runSQL(sqlUpdateSeller, params);
    if dsResultUpdateSeller['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);

    end;

    dsResultUpdateSeller.Free;

    dsResult.Next;
  end;

  // update The user's  and buyers' statistics  based on these transactions

  try
    updateStats(ShoppingCartID);
  except
    on e: Exception do
    begin
      if Connection.InTransaction then
        RollBack;
      raise e;
    end;
  end;

  // Now, Delete all temporary shopping cart records from the database

  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params.clear;

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  dsResult.Free;

  // commit transaction

  CommitTransaction;

end;

// once the user has checked out a cart or has logged in
// generate a new shopping cart for the user
function TDataModule1.CreateUserCart(userID: string): string;
var
  sShoppingCartID, sql: string;
  i: integer;
  params: tObjectDictionary<string, Variant>;
  currDate: tDateTime;
  dsResult: tADODataSet;
begin

  BeginTransaction;

  currDate := Date;

  // generate a unique code for the shopping cart
  sShoppingCartID := userID[2];

  for i := 1 to 9 do
  begin
    sShoppingCartID := sShoppingCartID + intToStr(random(10));
  end;

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ShoppingCartID', sShoppingCartID);
  params.Add('Date', Date);
  params.Add('UserID', userID);

  // insert user's shopping cart into database
  sql := 'INSERT INTO ShoppingCartTB (ShoppingCartID, BuyerID, DateCreated) VALUES (:ShoppingCartID, :UserID , :Date)';

  dsResult := runSQL(sql, params);

  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;
  // commit changes
  CommitTransaction;

  Result := sShoppingCartID;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  Connection.Close;
  // scroll to the right and add in your database name
  Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
    + ExtractFilePath(ParamStr(0)) + 'GreenBagTB.mdb' +
    ';Persist Security Info=False';

  Connection.LoginPrompt := False;

  Connection.Open;

  // Connection for every table you have
  UserTB.Connection := Connection;
  // ADOTable1 must be named ADOtablename(your associated table)
  SellerTB.Connection := Connection;
  ItemTB.Connection := Connection;
  TransactionItemTB.Connection := Connection;
  TransactionTB.Connection := Connection;
  StatsTB.Connection := Connection;

  // Each ADOTable is associated with each table name in access
  UserTB.TableName := 'UserTB'; // table name spelled as in in MS access
  SellerTB.TableName := 'SellerTB'; // table name spelled as in in MS access
  ItemTB.TableName := 'ItemTB';
  TransactionItemTB.TableName := 'TransactionItemTB';
  TransactionTB.TableName := 'TransactionTB';
  StatsTB.TableName := 'StatsTB';

  // a data source is named DSTableName.
  // each data source must be associated with the correct ADOtable
  dsUserTB.DataSet := UserTB;
  dsSellerTB.DataSet := SellerTB;
  dsItemTB.DataSet := ItemTB;
  dsTransactionItemTB.DataSet := TransactionItemTB;
  dsTransactionTB.DataSet := TransactionTB;
  dsStatsTB.DataSet := StatsTB;

  Query.Connection := Connection;
end;

// Mark an item as deleted
// do not remove any actual records, we need to maintain referential integrity
// between other tables
procedure TDataModule1.deleteItem(itemID: string);
begin
  with DataModule1 do
  begin
    ItemTB.Open;
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
  table.First;
  if not bFound then
  begin
    raise Exception.Create('Could not find record');
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

  sql := 'SELECT ShoppingCartItemID FROM ShoppingCartItemsTB WHERE ShoppingCartID = :ShoppingCartID';

  params.Add('ShoppingCartID', ShoppingCartID);

  // retur nsql result
  Result := runSQL(sql, params);

  // handle db errors
  if Result.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(Result['Status']);
  end;

end;

// get all the categories of items that exist
function TDataModule1.getCategories: tADODataSet;
var
  sql: string;
begin
  sql := 'SELECT DISTINCT Category FROM ItemTB;';

  Result := runSQL(sql, nil);

end;

// get the all the products made by a particular seller
function TDataModule1.getProducts(userID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
begin
  sql := 'SELECT ItemID FROM ItemTB WHERE SellerID = :SellerID AND Deleted = False';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('SellerID', userID);

  try
    Result := runSQL(sql, params);
  finally
    params.Free;
  end;

end;

// Search for items with a specific string and category
function TDataModule1.getSearchResults(searchQuery, category: string)
  : tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin

  // sql statement and params
  // does not show deleted items
  sql := 'SELECT ItemID FROM ItemTB WHERE ItemName LIKE :SearchQuery AND Deleted = False ';

  params := tObjectDictionary<string, Variant>.Create();;
  params.Add('SearchQuery', '%' + searchQuery + '%');

  // if the user has specifed a category, use that as a condition as well
  if category <> '' then
  begin
    sql := sql + ' AND Category = :Category';
    params.Add('Category', category);
  end;

  // return the results
  Result := runSQL(sql, params);
  params.Free;

end;

// returns the shoppingcartItemID of a particular item in a user's cart
// this is so that the program can properly update and read that record
// in the shoppingcartItemTb
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

  // run sql
  dsResult := runSQL(sql, params);

  // handle errors
  if dsResult.Fields.FindField('Status') <> nil then
  begin
    dsResult.Free;
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

  dsResult.Free;

end;

// procedure to insert a new item into the database
procedure TDataModule1.insertItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce,
  EUProduce, WUProduce: double; Image: tPngImage);
var
  memStream: tMemoryStream;
begin

  ItemTB.Insert;
  ItemTB.edit;

  ItemTB['ItemID'] := itemID;
  ItemTB['ItemName'] := name;
  ItemTB['Cost'] := Price;
  ItemTB['CarbonFootprintProduction'] := CFProduce;
  ItemTB['WaterUsageProduction'] := WUProduce;

  ItemTB['EnergyUsageProduction'] := EUProduce;
  ItemTB['CarbonFootprintUsage'] := CF;
  ItemTB['WaterFootprintUsage'] := WU;
  ItemTB['EnergyFootprintUsage'] := EU;
  ItemTB['SellerID'] := SellerID;
  ItemTB['Description'] := Desc;
  ItemTB['Category'] := category;
  ItemTB['Stock'] := stock;
  ItemTB['MaxWithdrawableStock'] := maxwithdrawstock;
  memStream := tMemoryStream.Create;
  try
    Image.SaveToStream(memStream);
    memStream.Position := 0;
    ItemTB.edit;
    TBlobField(ItemTB.FieldByName('Image')).LoadFromStream(memStream);
  finally
    memStream.Free;
  end;

  ItemTB.Post;
  ItemTB.Refresh;

end;

procedure TDataModule1.insertStatData(userID: string; statDate: tDateTime;
  statType: string; value: double);
var
  statid, sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  i: integer;
begin
  // generate unqiue statId
  statid := userID[2] + intToStr(DayOf(Date))[1];

  for i := 1 to 12 do
  begin
    statid := statid + intToStr(random(10));
  end;

  sql := 'INSERT INTO StatsTB (StatID, UserID, statDate, Type, statValue)' +
    ' VALUES (:statID, :UserID, :statDate, :statType, :statValue) ';

  // get paramater for query

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('statID', statid);
  params.Add('UserID', userID);
  params.Add('statDate', statDate);
  params.Add('statType', statType);
  params.Add('statValue', value);

  // send sql insert statement
  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
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
  dParams := tObjectDictionary<String, Variant>.Create();
  for i := 1 to length(pkValue) do
  begin
    paramName := 'pkVal' + intToStr(i);
    dParams.Add(paramName, pkValue[i]);
    sql := sql + pkName[i] + ' = :' + paramName;
    if not(i = length(pkName)) then
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

    dParams.Free;

    Result := not dsResult.IsEmpty;
  finally
    dsResult.Free;
  end;

end;

// function used to check credentials entered and login a user if successful
function TDataModule1.Login(Username, password: string): string;
var
  sql: string;
  sqlResult: tADODataSet;
  Parameters: tObjectDictionary<string, Variant>;
  b: boolean;
begin

  sql := 'SELECT UserID, Password, Salt FROM UserTB WHERE Username = :Username';
  Parameters := tObjectDictionary<string, Variant>.Create();
  Parameters.Add('Username', Username);

  sqlResult := runSQL(sql, Parameters);
  Parameters.Free;

  // handle error occuring whilst trying to access database
  if sqlResult.Fields.FindField('Status') <> nil then
  begin
    Result := 'Error: ' + sqlResult['Status'];
    showMessage(Result);
    exit;
  end;


  // check if any users with matching username

  if sqlResult.IsEmpty then
  begin
    Result := 'Error: User does not Exist';
    exit;
  end;

  // check password match
  b := False;
  if not tScrypt.CheckPassword(UpperCase(Username) + password +
    sqlResult['Salt'], sqlResult['Password'], b) then
  begin
    Result := 'Error: Incorrect Password';
    exit;
  end;

  // return the corresponding user id of the user that the program can use
  // for functions
  Result := sqlResult['UserID'];
  sqlResult.Free;

end;

function TDataModule1.obtainStats(userID, statType: string;
   DateBegin, DateEnd: tDateTime): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
begin;
  sql := 'SELECT YEAR(statDate) AS y, MONTH(statDate) as m , SUM(statValue) AS TotalMonth FROM StatsTB'
    + ' WHERE UserID = :UserID AND Type = :Type '
    + 'GROUP BY YEAR(statDate), MONTH(statDate) ORDER BY YEAR(statDate) ASC, MONTH(statDate) ASC';
  params := tObjectDictionary<string, Variant>.Create();
  //statDate BETWEEN :MonthBegin AND :MonthEnd
  //UserID = :UserID AND Type = :Type AND statDate
  params.Add('UserID', userID);
  params.Add('Type', statType);
 // params.Add('MonthBegin', DateBegin);
  //params.Add('MonthEnd', DateEnd);

  Result := runSQL(sql, params);

  sql := '';

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

  dsResultItemInfo := runSQL(sql, params);

  if dsResultItemInfo.Fields.FindField('Status') <> nil then
  begin
    // deallocate memory for query result
    dsResult.Free;
    // raise exception
    raise Exception.Create(dsResult['Status']);
  end;

  if dsResultItemInfo.IsEmpty then
  begin
    RollBack;
    showMessage('Error: Could not find ShoppingCart Item');
    // rollback
    exit;
  end;
  quantity := dsResultItemInfo['Quantity'];
  itemID := dsResultItemInfo['ItemID'];

  dsResultItemInfo.Free;
  params.clear;

  // update stock

  sql := 'UPDATE ItemTB SET Stock = Stock + :Quantity WHERE ItemID = :ItemID';
  params.Add('Quantity', quantity);
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);
  params.clear;

  if dsResult['Status'] <> 'Success' then
  begin
    // deallocate memory for query result
    dsResult.Free;
    // raise exception
    raise Exception.Create(dsResult['Status']);
  end;

  params.clear;

  // delete from shoppingcart

  sql := 'DELETE FROM ShoppingCartItemsTB WHERE ShoppingCartItemID = :ShoppingCartItemID';

  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  dsResult := runSQL(sql, params);

  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    // deallocate memory for query result
    dsResult.Free;
    // raise exception
    raise Exception.Create(dsResult['Status']);
  end;

  // commit changes if no error occurs
  CommitTransaction;

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
  if assigned(params) then
  begin
    for Item in params do
    begin

      Query.Parameters.ParamByName(Item.Key).value := Item.value;
    end;

  end;
  // create output dataset to show result
  dsOutput := tADODataSet.Create(Nil);
  dsOutput.FieldDefs.Add('Status', ftString, 100);
  dsOutput.CreateDataSet;
  try
    try
      begin
        if UpperCase(copy(trim(sql), 1, 6)) = 'SELECT' then
        begin
          // read
          // read data from sql into output dataset
          Query.Open;
          dsOutput.Free;
          dsOutput := tADODataSet.Create(Nil);
          dsOutput.Recordset := Query.Recordset.Clone(1);
        end
        else
        begin
          // Create update delete
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
// todo : currently a user can send as many ratings as they want
// pls fix this
procedure TDataModule1.sendRating(itemID: string; rating: integer);
var
  numRatings: integer;
  avgRatings: double;
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin

  sql := 'SELECT (Rating * RatingsAmount) AS totalRating , RatingsAmount FROM ItemTB WHERE ItemID = :ItemID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    dsResult.Free;
    exit;
  end;

  numRatings := dsResult['RatingsAmount'] + 1;

  avgRatings := (dsResult['totalRating'] + rating) / numRatings;

  sql := 'UPDATE ItemTB SET Rating = :Rating, RatingsAmount = :RatingsAmount WHERE ItemID = :ItemID ';

  params.Add('Rating', avgRatings);
  params.Add('RatingsAmount', numRatings);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
  end;

  dsResult.Free;

end;

// a function used to create a new user in the database and return the new user's userid for use by the program
function TDataModule1.SignUp(Username, password, usertype, homeAddress,
  certificationcode: string): string;
var
  hash, salt: string;
  userID, sql: string;
  params: tObjectDictionary<String, Variant>;
  i: integer;
  sqlResult: tADODataSet;
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
  sql := 'INSERT INTO UserTB ([UserID], [Username], [Password], [UserType], [HomeAddress], [Salt]) VALUES'
    + ' ( :UserID, :Username, :Password, :UserType, :HomeAddress, :Salt);';

  // input parameters
  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);
  params.Add('Username', Username);
  params.Add('Password', hash);
  params.Add('UserType', usertype);
  params.Add('HomeAddress', homeAddress);
  params.Add('Salt', salt);

  sqlResult := runSQL(sql, params);

  // handle errors
  if sqlResult['status'] <> 'Success' then
  begin
    Result := sqlResult['status'];
    exit;
  end;

  // if user is a seller, set up a corresponding record in seller tb as well
  if usertype = 'SELLER' then
  begin
    try

      with SellerTB do
      begin
        SellerTB.Open;
        SellerTB.Insert;

        SellerTB['UserID'] := userID;
        SellerTB['Revenue'] := 0.0;
        SellerTB['CertificationCode'] := certificationcode;

        SellerTB.Post;
        SellerTB.Refresh;
        SellerTB.First;
      end;

    except
      on e: EADOError do
      begin
        Result := 'Error: ' + e.Message;
      end;
      on e: EOleException do
      begin
        Result := 'Error: ' + e.Message;
      end;

    end;

  end;

  Result := userID;

end;

procedure TDataModule1.updateItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce,
  EUProduce, WUProduce: double; Image: tPngImage);
var
  memStream: tMemoryStream;
begin

  try
    findInTable(ItemTB, 'ItemID', itemID);

  except
    on e: Exception do
    begin
      raise e;
    end;

  end;
  ItemTB.Edit;

  ItemTB['ItemName'] := name;
  ItemTB['Cost'] := Price;
  ItemTB['CarbonFootprintProduction'] := CFProduce;
  ItemTB['WaterUsageProduction'] := WUProduce;
  ItemTB['EnergyUsageProduction'] := EUProduce;
  ItemTB['CarbonFootprintUsage'] := CF;
  ItemTB['WaterFootprintUsage'] := WU;
  ItemTB['EnergyFootprintUsage'] := EU;
  ItemTB['SellerID'] := SellerID;
  ItemTB['Description'] := Desc;
  ItemTB['Category'] := category;
  ItemTB['Stock'] := stock;
  ItemTB['MaxWithdrawableStock'] := maxwithdrawstock;

  memStream := tMemoryStream.Create;
  try
    Image.SaveToStream(memStream);
    memStream.Position := 0;
    TBlobField(ItemTB.FieldByName('Image')).LoadFromStream(memStream);
  finally
    memStream.Free;
  end;

  ItemTB.Post;
  ItemTB.Refresh;

end;

// used every time a user checksout a shopping cart
// updates the statistics of the user and the sellers involved in all
// the transactions
procedure TDataModule1.updateStats(ShoppingCartID: string);
var
  sql, BuyerID: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultStats: tADODataSet;
  SellerID: string;
  CFItem, WUItem, EUItem, CostItem: double;
  quantityItem: integer;
begin

  // get the buyer ID from this cart
  sql := 'SELECT BuyerID FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  BuyerID := dsResult['BuyerID'];

  // for each item in this cart, select all relevant data
  sql := 'SELECT ShoppingCartItemsTB.ItemID, Quantity, ItemTB.SellerID, ItemTB.Cost, '
    + ' (CarbonFootprintProduction + CarbonFootprintUsage) AS CF , ' +
    '(WaterUsageProduction + WaterFootprintUsage) AS WU, ' +
    '(EnergyUsageProduction + EnergyFootprintUsage) AS EU ' +
    'FROM  ShoppingCartItemsTB, ItemTB ' +
    'WHERE ShoppingCartID = :ShoppingCartID AND ShoppingCartItemsTB.ItemID = ItemTB.ItemID ';

  dsResult := runSQL(sql, params);

  // handle database errors
  if dsResult.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  dsResult.First;
  // loop through all transactions and update stats accordingly
  while not dsResult.Eof do
  begin
    // get data from one transaction
    SellerID := dsResult['SellerID'];
    CFItem := dsResult['CF'];
    WUItem := dsResult['WU'];
    EUItem := dsResult['EU'];
    quantityItem := dsResult['Quantity'];
    CostItem := dsResult['Cost'];
    // insert records into statsTB
    try
      insertStatData(SellerID, dDate, 'REV', CostItem * quantityItem);
      insertStatData(SellerID, dDate, 'SAL', quantityItem);
      insertStatData(BuyerID, dDate, 'SPE', CostItem * quantityItem);
      insertStatData(BuyerID, dDate, 'CF', CFItem * quantityItem);
      insertStatData(BuyerID, dDate, 'EU', EUItem * quantityItem);
      insertStatData(BuyerID, dDate, 'WU', WUItem * quantityItem);

    except
      on e: Exception do
      begin
        raise e;
      end;

    end;

    dsResult.Next;

  end;

  dsResult.Free;
  params.Free;
end;

function TDataModule1.userInfo(userID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  dRevenue, dBalance, dTotalSpending, dTotalCF, dTotalEU, dTotalWU: double;
  sUserType: string;
begin

  // select user's current balance and type of user
  sql := 'SELECT Username, UserType, Balance FROM UserTB WHERE UserID = :UserID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', userID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    exit;
  end;

  if dsResult.IsEmpty then
  begin
    showMessage('No user with userID');
    exit;
  end;

  Result := tADODataSet.Create(nil);
  Result.FieldDefs.Add('Username', ftString, 100);
  Result.FieldDefs.Add('UserType', ftString, 10);
  Result.FieldDefs.Add('Balance', ftFloat);
  Result.FieldDefs.Add('Revenue', ftFloat);
  Result.FieldDefs.Add('TotalSales', ftInteger);
  Result.FieldDefs.Add('TotalEU', ftFloat);
  Result.FieldDefs.Add('TotalWU', ftFloat);
  Result.FieldDefs.Add('TotalCF', ftFloat);
  Result.FieldDefs.Add('TotalSpending', ftCurrency);
  Result.CreateDataSet;

  Result.Insert;
  Result.Edit;
  Result['UserType'] := dsResult['UserType'];
  Result.Edit;
  Result['Balance'] := dsResult['Balance'];
  Result.Edit;
  Result['Username'] := dsResult['Username'];

  Result.First;

  // if user is a seller, get sales and revenue
  if dsResult['UserType'] = 'SELLER' then
  begin

    sql := 'SELECT Revenue FROM SellerTB WHERE UserID = :UserID';

    dsResult := runSQL(sql, params);

    if dsResult.Fields.FindField('Status') <> nil then
    begin
      showMessage(dsResult['Status']);
      exit;
    end;

    if dsResult.IsEmpty then
      showMessage('uh oh');

    Result.Edit;
    Result['Revenue'] := dsResult['Revenue'];

    sql := 'SELECT Sum(Sales) AS TotalSales from ItemTB WHERE SellerID = :UserID';

    dsResult := runSQL(sql, params);
    Result.Edit;
    Result['TotalSales'] := dsResult['TotalSales'];

  end;

  // select total spending

  sql := 'SELECT Sum(statValue) AS total FROM StatsTB WHERE UserID = :UserID AND Type = :statType ';
  params.clear;
  params.Add('UserID', userID);
  params.Add('statType', 'SPE');

  dsResult := runSQL(sql, params);
  Result.Edit;
  Result['TotalSpending'] := dsResult['total'];

  // select total cf

  params.AddOrSetValue('statType', 'CF');

  dsResult := runSQL(sql, params);

  Result.Edit;
  Result['TotalCF'] := dsResult['total'];
  // select total eu

  params.AddOrSetValue('statType', 'EU');

  dsResult := runSQL(sql, params);
  Result.Edit;
  Result['TotalEU'] := dsResult['total'];

  // select total wu
  params.AddOrSetValue('statType', 'WU');

  dsResult := runSQL(sql, params);
  Result.Edit;
  Result['TotalWU'] := dsResult['total'];

  params.Free;

end;

// function used to retrieve all important information on an item
// so that is can be displayed on the VIEW ITEM screen and ADDitemScreen
function TDataModule1.viewItem(itemID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  sql := 'SELECT * , UserTB.Username AS SellerName FROM ItemTB ' +
    'INNER JOIN UserTB ON ItemTb.SellerID = UserTB.UserID' +
    ' WHERE ItemID = :ItemID ';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    exit;
  end;

  if dsResult.IsEmpty then
  begin
    dsResult.Close;
    dsResult.FieldDefs.Add('Status', ftString, 100);
    dsResult.CreateDataSet;
    dsResult.Insert;
    dsResult['Status'] := 'Error: Item does not exist.'
  end;

  Result := dsResult;

end;

end.
