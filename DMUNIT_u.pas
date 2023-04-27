unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB,
  sCrypt, System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.Graphics, Vcl.ExtCtrls, System.Variants, PngImage, System.Win.ComObj;

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

    function runSQL(sql: string;
      params: tObjectDictionary<string, Variant> = nil): tADODataSet;

    procedure CommitTransaction();

    procedure RollBack();

    procedure BeginTransaction();

    function Login(Username, password: string): string;
    function SignUp(Username, password, usertype, homeAddress, certificationcode
      : string): string;

    function userInfo(userID: string): tADODataSet;
    function obtainStats(userID, statType: string): tADODataSet;

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

    function isInTable(pkValue, pkName, tbName: string): boolean;

    // methods relating to transaction management
    function CreateUserCart(userID: string): string;

    procedure CancelCart(ShoppingCartID: string);

    procedure completeTransactions(ShoppingCartID: string);

    function addToCart(ShoppingCartID, itemID: string;
      quantity: integer): string;

    function getCartItems(ShoppingCartID: string): tADODataSet;
    procedure removeFromCart(ShoppingCartItemID: string);

    function getItemInCart(itemID, ShoppingCartID: string): string;

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
    // update
    params.Add('ShoppingCartItemID', ShoppingCartItemID);
    sql := 'UPDATE ShoppingCartItemsTB' +
      ' SET Quantity = Quantity + :Quantity WHERE ShoppingCartItemID = :ShoppingCartItemID  ';
    Result := '';
  end
  else
  begin
    // insert
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

  // check if enough stock

  //DAFUCK IS UP WITH PARAMETERS NOT WORKING

  sql := 'SELECT ItemTB.Stock, ItemTB.MaxWithdrawableStock, ShoppingCartItemsTB.Quantity '
    + 'FROM ShoppingCartItemsTB, ItemTB' +
    ' WHERE ItemTB.ItemID = :ItemID AND '+
    ' ShoppingCartItemID = "' + ShoppingCartItemID + '"' ;

  params.clear;
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin

    raise Exception.Create(dsResult['Status']);
  end;

  if dsResult['Stock'] - quantity < 0 then
  begin
    // not enough stock
    // rollback changes
    showMessage(dsResult['Stock']);
    RollBack;
    // deallocate memory for query result
    dsResult.Free;
    raise Exception.Create('Not enough Stock for this item');
  end
  else if dsResult['MaxWithdrawableStock'] < dsResult['Quantity'] then
  begin
    RollBack;
    dsResult.Free;
    raise Exception.Create('You are not permitted to withdraw more units at once.');
  end;

  sql := 'UPDATE ItemTB SET Stock = Stock - :Quantity WHERE ItemID = :ItemID';
  params.Clear;
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

  CommitTransaction;
  dsResult.Free;

end;

procedure TDataModule1.BeginTransaction;
begin
  //
  if not Connection.InTransaction then
    Connection.BeginTrans;
end;

procedure TDataModule1.CancelCart(ShoppingCartID: string);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateItem: tADODataSet;
begin

  BeginTransaction;
  params := tObjectDictionary<string, Variant>.Create();

  // put stock back again

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

  sql := 'UPDATE ItemTB SET Stock = Stock + :Quantity WHERE ItemID = :ItemID';

  while not dsResult.Eof do
  begin
    params.clear;

    params.Add('Quantity', dsResult['Quantity']);
    params.Add('ItemID', dsResult['ItemID']);
    dsResultUpdateItem := runSQL(sql, params);

    if dsResultUpdateItem['Status'] <> 'Success' then
    begin
      // deallocate memory for query result
      dsResult.Free;
      // raise exception
      raise Exception.Create(dsResultUpdateItem['Status']);
    end;
    dsResult.Next;

  end;

  dsResult.Free;


  // delete temp record

  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params.clear;

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    exit;
  end;

  CommitTransaction;
  dsResult.Free;

end;

procedure TDataModule1.CommitTransaction;
begin

  Connection.CommitTrans;

end;

procedure TDataModule1.completeTransactions(ShoppingCartID: string);
var
  sql, sqlUpdateBuyer, sqlUpdateItem, sqlUpdateSeller: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateItem, dsResultUpdateSeller, dsResultUpdateBuyer
    : tADODataSet;
  BuyerID: string;
  buyerBalance, itemPrice: double;
begin

  BeginTransaction;

  // copy data into TransactionTB and TransactionItemTB
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

  sql := 'INSERT INTO TransactionItemTB (CartItemID, ItemID, Quantity, TransactionID) '
    + 'SELECT ShoppingCartItemID, ItemID, Quantity, ShoppingCartID FROM ShoppingCartItemsTB WHERE ShoppingCartID  = :ShoppingCartID ';

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  dsResult.Free;

  // Select user's balance and userID

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

  // Select all relevant data on the items, buyer and Seller for each item in user's cart

  sql := 'SELECT Quantity, ShoppingCartItemsTB.ItemID, ItemTB.Cost' +
    ' , ItemTB.SellerID, BuyerID FROM ' + '(((ShoppingCartItemsTB ' +
    ' INNER JOIN ShoppingCartTB ' +
    'ON ShoppingCartItemsTB.ShoppingCartID = ShoppingCartTB.ShoppingCartID) ' +
    'INNER JOIN UserTB ' + 'ON ShoppingCartTB.BuyerID = UserTB.UserID )' +
    'INNER JOIN ItemTB ' + 'ON ItemTB.ItemID = ShoppingCartItemsTB.ItemID )' +
    'WHERE ShoppingCartItemsTB.ShoppingCartID = :ShoppingCartID';

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(dsResult['Status']);
    exit;
  end;

  params.clear;

  // update balance of seller and buyer accordingly

  sqlUpdateItem :=
    'UPDATE ItemTB SET Sales = Sales + :Sales WHERE ItemID = :ItemID';
  sqlUpdateBuyer :=
    'UPDATE UserTB SET Balance = :Balance WHERE UserID = :UserID ';
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
      // Rollback in case of insufficient funds
      RollBack;
      raise Exception.Create('Out of balance');
    end;
    params.clear;
    params.Add('Balance', buyerBalance);
    params.Add('UserID', BuyerID);

    dsResultUpdateBuyer := runSQL(sqlUpdateBuyer, params);

    if dsResultUpdateBuyer['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;

    dsResultUpdateBuyer.Free;

    // update item

    params.clear;

    params.Add('ItemID', dsResult['ItemID']);

    params.Add('Sales', dsResult['Quantity']);
    dsResultUpdateItem := runSQL(sqlUpdateItem, params);

    if dsResultUpdateItem['Status'] <> 'Success' then
    begin
      raise Exception.Create(dsResult['Status']);
    end;
    dsResultUpdateItem.Free;


    // update seller

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

  // delete temp record

  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params.clear;

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;

  dsResult.Free;

  CommitTransaction;

end;

function TDataModule1.CreateUserCart(userID: string): string;
var
  sShoppingCartID, sql: string;
  i: integer;
  params: tObjectDictionary<string, Variant>;
  currDate: tDateTIme;
  dsResult: tADODataSet;
begin

  BeginTransaction;

  currDate := Date;

  sShoppingCartID := userID[2];

  for i := 1 to 9 do
  begin
    sShoppingCartID := sShoppingCartID + intToStr(random(10));
  end;

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ShoppingCartID', sShoppingCartID);
  params.Add('Date', Date);
  params.Add('UserID', userID);

  sql := 'INSERT INTO ShoppingCartTB (ShoppingCartID, BuyerID, DateCreated) VALUES (:ShoppingCartID, :UserID , :Date)';

  dsResult := runSQL(sql, params);

  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    raise Exception.Create(dsResult['Status']);
  end;
  CommitTransaction;

  Result := sShoppingCartID;
end;

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  //
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

function TDataModule1.getCartItems(ShoppingCartID: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin
  //
  params := tObjectDictionary<string, Variant>.Create();

  sql := 'SELECT ShoppingCartItemID FROM ShoppingCartItemsTB WHERE ShoppingCartID = :ShoppingCartID';

  params.Add('ShoppingCartID', ShoppingCartID);

  Result := runSQL(sql, params);

  if Result.Fields.FindField('Status') <> nil then
  begin
    raise Exception.Create(Result['Status']);
  end;

end;

function TDataModule1.getCategories: tADODataSet;
var
  sql: string;
begin
  //
  sql := 'SELECT DISTINCT Category FROM ItemTB;';

  Result := runSQL(sql, nil);

end;

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

function TDataModule1.getSearchResults(searchQuery, category: string)
  : tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;

begin

  sql := 'SELECT ItemID FROM ItemTB WHERE ItemName LIKE :SearchQuery AND Deleted = False ';

  params := tObjectDictionary<string, Variant>.Create();;
  params.Add('SearchQuery', '%' + searchQuery + '%');

  if category <> '' then
  begin
    sql := sql + ' AND Category = :Category';
    params.Add('Category', category);
  end;

  Result := runSQL(sql, params);
  params.Free;

end;

function TDataModule1.getItemInCart(itemID, ShoppingCartID: string): STRING;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  //
  sql := 'SELECT ShoppingCartItemID FROM ShoppingCartItemsTB WHERE ItemID = :ItemID AND ShoppingCartID = :ShoppingCartID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ItemID', itemID);
  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    dsResult.Free;
    raise Exception.Create(dsResult['Status']);
  end;

  if dsResult.IsEmpty then
  begin

    Result := '';
  end
  else
  begin
    Result := dsResult['ShoppingCartItemID'];
  end;

  dsResult.Free;

end;

procedure TDataModule1.insertItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, maxwithdrawstock, CF, EU, WU, CFProduce,
  EUProduce, WUProduce: double; Image: tPngImage);

var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  memStream: TMemoryStream;
begin

  sql := 'INSERT INTO ItemTB (ItemID, ItemName, Cost, Stock, MaxWithdrawableStock, CarbonFootprintProduction, WaterUsageProduction, EnergyUsageProduction, CarbonFootprintUsage, WaterFootprintUsage, EnergyFootprintUsage, SellerID, Description, Category, Image) '
    + ' VALUES ' +
    '( :ItemID, :ItemName, :Cost, :Stock, :MaxWithdrawableStock, :CarbonFootprintProduction, :WaterUsageProduction, :EnergyUsageProduction, :CarbonFootprintUsage, :WaterFootprintUsage, :EnergyFootprintUsage, :SellerID, :Description , :Category, :Image);';

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

  try

    memStream := TMemoryStream.Create;
    Image.SaveToStream(memStream);
    Query.Parameters.AddParameter.Name := 'Image';
    Query.Parameters.ParamByName('Image').LoadFromStream(memStream, ftblob);

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      showMessage(dsResult['Status']);
    end;

  finally
    memStream.Free;
    dsResult.Free;
    params.Free;
  end;
end;

function TDataModule1.isInTable(pkValue, pkName, tbName: string): boolean;
var
  sql: string;
  dParams: tObjectDictionary<String, Variant>;
  dsResult: tADODataSet;
begin
  //
  dParams := tObjectDictionary<String, Variant>.Create();
  dParams.Add('pkVal', pkValue);

  sql := 'SELECT 1 FROM ' + tbName + ' WHERE ' + pkName + ' = :pkVal';

  try
    dsResult := runSQL(sql, dParams);
    dParams.Free;

    Result := not dsResult.IsEmpty;
  finally
    dsResult.Free;
  end;

end;

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

  Result := sqlResult['UserID'];
  sqlResult.Free;

end;

function TDataModule1.obtainStats(userID, statType: string): tADODataSet;
begin

end;

procedure TDataModule1.removeFromCart(ShoppingCartItemID: string);
var
  sql: string;
  dsResult, dsResultItemInfo: tADODataSet;
  params: tObjectDictionary<string, Variant>;
  quantity: integer;
  itemID: string;
begin

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

      Query.Parameters.ParamByName(Item.Key).Value := Item.Value;
    end;

  end;
  // create output dataset
  dsOutput := tADODataSet.Create(Nil);
  dsOutput.FieldDefs.Add('Status', ftString, 100);
  dsOutput.CreateDataSet;
  try
    try
      begin
        if UpperCase(copy(trim(sql), 1, 6)) = 'SELECT' then
        begin
          // read data from sql into output dataset
          Query.Open;
          dsOutput.Free;
          dsOutput := tADODataSet.Create(Nil);
          dsOutput.Recordset := Query.Recordset.Clone(1);
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

  // if user is a seller, set up SellerRecord
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
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  imageBytes: tBytes;
  memStream: TMemoryStream;
begin
  sql := 'UPDATE ItemTB SET ItemName = :ItemName, Cost = :Cost, Stock = :Stock, MaxWithdrawableStock = :MaxWithdrawableStock,'
    + ' CarbonFootprintProduction = :CarbonFootprintProduction, WaterUsageProduction = :WaterUsageProduction, EnergyUsageProduction = :EnergyUsageProduction, '
    + 'CarbonFootprintUsage = :CarbonFootprintUsage, WaterFootprintUsage = :WaterFootprintUsage, EnergyFootprintUsage = :EnergyFootprintUsage,'
    + ' Description =  :Description , Category = :Category, Image = :Image' +
    'WHERE ItemID = :ItemID';

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
  params.Add('Description', Desc);
  params.Add('Category', category);
  params.Add('Stock', stock);
  params.Add('MaxWithdrawableStock', maxwithdrawstock);

  try

    memStream := TMemoryStream.Create;
    Image.SaveToStream(memStream);
    Query.Parameters.AddParameter.Name := 'Image';
    Query.Parameters.ParamByName('Image').LoadFromStream(memStream, ftblob);

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      showMessage(dsResult['Status']);
    end;
  finally
    memStream.Free;
    dsResult.Free;
    params.Free;
  end;

end;

function TDataModule1.userInfo(userID: string): tADODataSet;
begin

end;

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
