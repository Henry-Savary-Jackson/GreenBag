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
    function runSQL(sql: string;
      params: tObjectDictionary<string, Variant> = nil; commit: boolean = True)
      : tADODataSet;

    procedure CommitTransaction();

    procedure RollBack();

    function Login(Username, password: string): string;
    function SignUp(Username, password, usertype, homeAddress, certificationcode
      : string): string;

    function userInfo(UserId: string): tADODataSet;
    function obtainStats(UserId, statType: string): tADODataSet;

    function viewItem(itemID: string): tADODataSet;
    procedure insertItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
      Image: tPngImage);

    procedure updateItem(itemID, Name, SellerID, category, Desc: string;
      Price, stock, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
      Image: tPngImage);
    procedure deleteItem(itemID: string);
    function getCategories(): tADODataSet;
    procedure sendRating(itemID: string; rating: integer);

    function getProducts(UserId: string): tADODataSet;

    function getSearchResults(searchQuery, category: string): tADODataSet;

    function isInTable(pkValue, pkName, tbName: string): boolean;

    // methods relating to transaction management
    function CreateUserCart(UserId: string): string;

    procedure CancelCart(ShoppingCartID: string);

    procedure completeTransactions(ShoppingCartID: string);

    function addToCart(ShoppingCartID, itemID: string;
      quantity: integer): string;

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

  ShoppingCartItemID := self.getItemInCart(itemID);
  if ShoppingCartID = 'Error' then
  begin
    Exit;
  end;

  params := tObjectDictionary<string, Variant>.Create
    ([doOwnsKeys, doOwnsValues]);

  params.Add('Quantity', quantity);
  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  if ShoppingCartItemID <> '' then
  begin
    // update

    sql := 'UPDATE ShoppingCartItemsTB' +
      ' SET Quantity =  Quantity + :Quantity WHERE ShoppingCartItemID = :ShoppingCartItemID  ';
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
      + 'VALUES = ( :ShoppingCartItemID, :ItemID, :Quantity, :ShoppingCartID )';

    params.Add('ItemID', itemID);

    params.Add('ShoppingCartID', ShoppingCartID);
    Result := ShoppingCartItemID;
  end;

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    dsResult.Free;
    Exit;
  end;

  params.Free;

  // update stock

  sql := 'UPDATE ItemTB SET Stock = Stock - :Quantity WHERE ItemID = :ItemID';
  params.Add('Quantity', quantity);
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);
  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    dsResult.Free;
    Exit;
  end;

  dsResult.Free;

end;

procedure TDataModule1.CancelCart(ShoppingCartID: string);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
begin
  params := tObjectDictionary<string, Variant>.Create
    ([doOwnsKeys, doOwnsValues]);

  // put stock back again

  sql := 'SELECT ItemID, Quantity FROM ShoppingCartItemsTB WHERE ShoppingCartID = :ShoppingCartID';

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params, False);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;

  dsResult.First;

  sql := 'UPDATE ItemTB SET Stock = Stock + :Quantity WHERE ItemID = :ItemID';

  while not dsResult.Eof do
  begin
    params.Clear;

    params.Add('Quantity', dsResult['Quantity']);
    params.Add('ItemID', dsResult['ItemID']);
    if runSQL(sql, params, False)['Status'] <> 'Success' then
    begin
      showMessage('ERROR IN OUTTING BACK STOCK');
      Exit;
    end;
    dsResult.Next;

  end;

  dsResult.Free;


  // delete temp record

  sql := 'DELETE FROM ShoppingCartTB WHERE ShoppingCartID = :ShoppingCartID';
  params.Clear;

  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;

  dsResult.Free;

end;

procedure TDataModule1.CommitTransaction;
begin
  if Connection.InTransaction then
    Connection.CommitTrans;

end;

procedure TDataModule1.completeTransactions(ShoppingCartID: string);
var
  sql, sqlUpdateBuyer, sqlUpdateItem, sqlUpdateSeller: string;
  params: tObjectDictionary<string, Variant>;
  dsResult, dsResultUpdateItem, dsResultUpdateSeller, dsResultUpdateBuyer: tADODataSet;
  itemID, SellerID, BuyerID: string;
  quantity: integer;
  buyerBalance, itemCF, itemWU, itemEU, itemPrice, sellerRevenue, itemSales: double;
begin

  // copy data into TransactionTB and TransactionItemTB
  sql := 'SELECT ShoppingCartID, BuyerID FROM ShoppingCartTB INTO TransactionTB WHERE ShoppingCartID = :ShoppingCartID';
  params := tObjectDictionary<string, Variant>.Create();
  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params, False);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;
  dsResult.Free;

  sql := 'SELECT * FROM ShoppingCartItemsTB INTO TransactionItemTB WHERE ShoppingCartID  = :ShoppingCartID ';

  dsResult := runSQL(sql, params, False);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;

  dsResult.Free;

  //Select all relevant data on the items, buyer and Seller for each item in user's cart

  sql := 'SELECT Quantity, ItemID, ItemTB.Cost, ItemTB.Sales' +
    ' (ItemTB.CarbonFootprintProduction + ItemTB.CarbonFootprintUsage)  AS CF '
    + ' (ItemTB.EnergyUsageProduction + ItemTB.EnergyFootprintUsage) AS EU ' +
    ' (ItemTB.WaterUsageProduction + ItemTB.WaterFootprintUsage) AS WU' +
    'ShoppingCartTB.BuyerID, UserTB.Balance ' +
    ' , ItemTB.SellerID, SellerTB.Revenue, FROM ShoppingCartItemsTB WHERE ShoppingCartID = :ShoppingCartID '
    + 'INNER JOIN ShoppingCartTB ON ShoppingCartItemsTB.ShoppingCartID = ShoppingCartTB.ShoppingCartID '
    +  ' INNER JOIN UserTB ON ShoppingCartTB.BuyerID = UserTB.UserID '+
    'INNER JOIN ItemTB ON ItemTb.ItemID = ShoppingCartItemsTB.ItemID ' +
    ' INNER JOIN SellerTB ON SellerTB.SellerID = ItemTB.SellerID ';

  dsResult := runSQL(sql, string, False);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;

  params.Clear;

  // update balance of seller and buyer accordingly

  sqlUpdateItem := 'UPDATE ItemTB SET Sales = :Sales WHERE ItemID = :ItemID';
  sqlUpdateBuyer := 'UPDATE UserTB SET Balance = :Balance WHERE UserID = :UserID';
  sqlUpdateSeller := 'UPDATE SellerTB SET Revenue = Revenue + :Revenue WHERE SellerID = :SellerID';

  dsResult.First;

  while not dsResult.Eof do
  begin
    //update buyer
    itemEU := dsResult['EU'];
    itemCF := dsResult['CF'];
    itemWU := dsResult['WU'];
    itemPrice :=(dsResult['Quantity'] * dsResult['Cost']);
    buyerBalance := dsResult['Balance'];
    buyerBalance := buyerBalance - itemPrice ;

    if buyerBalance < 0 then
    begin
      showMessage();

    end;
    params.Clear;
    params.Add('Balance', dsResult['Sales']);

    dsResultUpdateBuyer := runSQL(sqlUpdateBuyer,params,false);

    if dsResultUpdateBuyer['Status'] <> 'Success' then
    begin
      showMessage(dsResultUpdateBuyer['Status']);
      Exit;
    end;

    dsResultUpdateBuyer.Free;

    //update seller

    //make sure it





    //update item

    dsResult.Next;
  end;


  CommitTransaction;



end;

function TDataModule1.CreateUserCart(UserId: string): string;
var
  sShoppingCartID, sql: string;
  i: integer;
  params: tObjectDictionary<string, Variant>;
  currDate: tDateTIme;
  dsResult: tADODataSet;
begin

  currDate := Date;

  sShoppingCartID := UserId[2];

  for i := 1 to 9 do
  begin
    sShoppingCartID := sShoppingCartID + intToStr(random(10));
  end;

  params := tObjectDictionary<string, Variant>.Create
    ([doOwnsKeys, doOwnsValues]);
  params.Add('ShoppingCartID', sShoppingCartID);
  params.Add('Date', Date);
  params.Add('UserID', UserId);

  sql := 'INSERT INTO ShoppingCartTB (ShoppingCartID, BuyerID, DateCreated) VALUES (:ShoppingCartID, :UserID , :Date)';

  dsResult := runSQL(sql, params);
  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    Result := '';
    Exit;
  end;

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

function TDataModule1.getCategories: tADODataSet;
var
  sql: string;
begin
  //
  sql := 'SELECT DISTINCT Category FROM ItemTB;';

  Result := runSQL(sql, nil);

end;

function TDataModule1.getProducts(UserId: string): tADODataSet;
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
begin
  sql := 'SELECT ItemID FROM ItemTB WHERE SellerID = :SellerID AND Deleted = False';

  params := tObjectDictionary<string, Variant>.Create();
  params.Add('SellerID', UserId);

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
  params := tObjectDictionary<string, Variant>.Create
    ([doOwnsValues, doOwnsKeys]);
  params.Add('ItemID', itemID);
  params.Add('ShoppingCartID', ShoppingCartID);

  dsResult := runSQL(sql, params);

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Result := 'Error';
    Exit;
  end;

  if dsResult.IsEmpty then
  begin
    Result := '';
  end
  else
  begin
    Result := dsResult['ShoppingCartItemID'];
  end;

end;

procedure TDataModule1.insertItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, CF, EU, WU, CFProduce, EUProduce,
  WUProduce: double; Image: tPngImage);

var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  memStream: TMemoryStream;
begin

  sql := 'INSERT INTO ItemTB (ItemID, ItemName, Cost, Stock, CarbonFootprintProduction, WaterUsageProduction, EnergyUsageProduction, CarbonFootprintUsage, WaterFootprintUsage, EnergyFootprintUsage, SellerID, Description, Category, Image) '
    + ' VALUES ( :ItemID, :ItemName, :Cost, :Stock, :CarbonFootprintProduction, :WaterUsageProduction, :EnergyUsageProduction, :CarbonFootprintUsage, :WaterFootprintUsage, :EnergyFootprintUsage, :SellerID, :Description , :Category, :Image);';

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
    Exit;
  end;


  // check if any users with matching username

  if sqlResult.IsEmpty then
  begin
    Result := 'Error: User does not Exist';
    Exit;
  end;

  // check password match
  b := False;
  if not tScrypt.CheckPassword(UpperCase(Username) + password +
    sqlResult['Salt'], sqlResult['Password'], b) then
  begin
    Result := 'Error: Incorrect Password';
    Exit;
  end;

  Result := sqlResult['UserID'];
  sqlResult.Free;

end;

function TDataModule1.obtainStats(UserId, statType: string): tADODataSet;
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

  // get cart item's details

  sql := 'SELECT Quantity, ItemID FROM ShoppingCartItemsTB WHERE ShoppingCartItemID = :ShoppingCartItemID';

  params := tObjectDictionary<string, Variant>.Create();

  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  dsResultItemInfo := runSQL(sql, params);

  if dsResultItemInfo.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResultItemInfo['Status']);
    Exit;
  end;

  if dsResultItemInfo.IsEmpty then
  begin
    showMessage('Error: Could not find ShoppingCart Item');
    // rollback
    Exit;
  end;
  quantity := dsResultItemInfo['Quantity'];
  itemID := dsResultItemInfo['ItemID'];

  dsResultItemInfo.Free;
  params.Clear;

  // update stock

  sql := 'UPDATE ItemTB SET Stock = Stock - :Quantity WHERE ItemID = :ItemID';
  params.Add('Quantity', quantity);
  params.Add('ItemID', itemID);

  dsResult := runSQL(sql, params);
  params.Clear;

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
    dsResult.Free;
    Exit;
  end;

  params.Clear;

  // delete from shoppingcart

  sql := 'DELETE FROM ShoppingCartItemsTB WHERE ShoppingCartItemID = :ShoppingCartItemID';

  params.Add('ShoppingCartItemID', ShoppingCartItemID);

  dsResult := runSQL(sql, params, True);

  params.Free;

  if dsResult['Status'] <> 'Success' then
  begin
    showMessage(dsResult['Status']);
  end;

  // commit changes if no arror occurs
  CommitTransaction;

end;

procedure TDataModule1.RollBack;
begin
//
  Connection.RollbackTrans;
end;

function TDataModule1.runSQL(sql: string;
  params: tObjectDictionary<string, Variant> = nil; commit: boolean = True)
  : tADODataSet;
var
  dsOutput: tADODataSet;
  Item: TPair<string, Variant>;
begin

  if not Connection.InTransaction then
  begin
    Connection.BeginTrans;
  end;

  Query.Close;
  Query.sql.Clear;
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
          // read
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
          if commit then
            Connection.CommitTrans;

          dsOutput.InsertRecord(['Success']);
        end;

      end;
    except
      // catch any errors that occur
      on e: EADOError do
      begin
        Connection.RollbackTrans;
        dsOutput.InsertRecord([e.Message]);

      end;
      on e: EDatabaseError do
      begin
        Connection.RollbackTrans;
        dsOutput.InsertRecord([e.Message]);

      end;
      on e: EOleException do
      begin
        Connection.RollbackTrans;
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
    Exit;
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
  UserId, sql: string;
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

  UserId := UpperCase(usertype[1] + Username[1]);

  for i := 1 to 8 do
  begin
    UserId := UserId + intToStr(random(10))
  end;

  // sql statement
  sql := 'INSERT INTO UserTB ([UserID], [Username], [Password], [UserType], [HomeAddress], [Salt]) VALUES'
    + ' ( :UserID, :Username, :Password, :UserType, :HomeAddress, :Salt);';

  // input parameters
  params := tObjectDictionary<string, Variant>.Create();

  params.Add('UserID', UserId);
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
    Exit;
  end;

  // if user is a seller, set up SellerRecord
  if usertype = 'SELLER' then
  begin
    try

      with SellerTB do
      begin
        SellerTB.Open;
        SellerTB.Insert;

        SellerTB['UserID'] := UserId;
        SellerTB['Revenue'] := 0.0;
        SellerTB['CertificationCode'] := certificationcode;

        SellerTB.Post;
        SellerTB.Refresh;
        SellerTB.First
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

  Result := UserId;

end;

procedure TDataModule1.updateItem(itemID, Name, SellerID, category,
  Desc: string; Price, stock, CF, EU, WU, CFProduce, EUProduce,
  WUProduce: double; Image: tPngImage);
var
  sql: string;
  params: tObjectDictionary<string, Variant>;
  dsResult: tADODataSet;
  imageBytes: tBytes;
  memStream: TMemoryStream;
begin
  sql := 'UPDATE ItemTB SET ItemName = :ItemName, Cost = :Cost, Stock = :Stock'
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

function TDataModule1.userInfo(UserId: string): tADODataSet;
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
    Exit;
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
