unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB,
  sCrypt, System.Generics.Collections, Datasnap.Provider, Vcl.dialogs,
  Vcl.Graphics, System.Variants, PngImage;

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
    sCrypt: tScrypt;
  public

    { Public declarations }
    function runSQL(sql: string; params: TDictionary<string, Variant> = nil)
      : tADODataSet;
    function Login(Username, password: string): string;
    function SignUp(Username, password, usertype, homeAddress, certificationcode
      : string): string;

    function userInfo(UserId: string): tADODataSet;
    function obtainStats(UserId, statType: string): tADODataSet;

    function viewItem(itemID: string): tADODataSet;
    procedure insertItem(itemID, Name, SellerID, category, Desc: string;
      Price, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
      Image: tPngImage);

    procedure updateItem(itemID, Name, SellerID, category, Desc: string;
      Price, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
      Image: tPngImage);
    procedure deleteItem(itemID: string);
    function getCategories(): tADODataSet;
    procedure sendRating(itemID: string; rating: integer);

    function getProducts(UserId: string): tADODataSet;

    function getSearchResults(searchQuery, category: string): tADODataSet;

    function isInTable(pkValue, pkName, tbName: string): boolean;

  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  //
  Connection.Close;

  // scroll to the right and add in your database name
  Connection.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='
    + ExtractFilePath(ParamStr(0)) + 'GreenBagTB.mdb' +
    ';Persist Security Info=False';

  Connection.LoginPrompt := FALSE;

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

    while not ItemTB.Eof do
    begin
      if ItemTB['ItemID'] = itemID then
      begin
        ItemTB['Deleted'] := True;
      end;
      ItemTB.Next;
    end;
    ItemTB.Post;
    ItemTB.Refresh;
    ItemTB.First;
  end;
end;

function TDataModule1.getCategories: tADODataSet;
begin
  //
end;

function TDataModule1.getProducts(UserId: string): tADODataSet;
var
sql :string;
params : tDictionary<string,Variant> ;
begin
  sql := 'SELECT ItemID FROM ItemTB WHERE SellerID = :SellerID' ;

  params := tDictionary<string,Variant>.Create();
  params.Add('SellerID', userID);

  try
     Result := runSQL(sql, params);
  finally
    params.Free;
  end;


end;

function TDataModule1.getSearchResults(searchQuery, category: string)
  : tADODataSet;
begin

end;

procedure TDataModule1.insertItem(itemID, Name, SellerID, category,
  Desc: string; Price, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
  Image: tPngImage);

var
  sql: string;
  params: TDictionary<string, Variant>;
  dsResult: tADODataSet;
  imageBytes: tBytes;
  memStream: TMemoryStream;
begin

  sql := 'INSERT INTO ItemTB (ItemID, ItemName, Cost, CarbonFootprintProduction, WaterUsageProduction, EnergyUsageProduction, CarbonFootprintUsage, WaterFootprintUsage, EnergyFootprintUsage, SellerID, Description, Category) '
    + ' VALUES ( :ItemID, :ItemName, :Cost, :CarbonFootprintProduction, :WaterUsageProduction, :EnergyUsageProduction, :CarbonFootprintUsage, :WaterFootprintUsage, :EnergyFootprintUsage, :SellerID, :Description , :Category);';

  params := TDictionary<string, Variant>.Create();
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

  try
  //TODO: adding image doesn't work yet
//     memStream := TMemoryStream.Create();
//     try
//     // save the png image as an OLE object
//     Image.SaveToStream(memStream);
//     SetLength(imageBytes, memStream.Size);
//     memStream.Position := 0;
//     memStream.ReadBuffer(imageBytes[0], Length(imageBytes));
//
//
//     // add to parameters
//     params.Add('Image', imageBytes);
//     finally
//     memStream.Free;
//     end;

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      showMessage(dsResult['Status']);
    end;

  finally
    dsResult.Free;
    params.Free;
  end;
end;

function TDataModule1.isInTable(pkValue, pkName, tbName: string): boolean;
var
  sql: string;
  dParams: TDictionary<String, Variant>;
  dsResult: tADODataSet;
begin
  //
  dParams := TDictionary<String, Variant>.Create();
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
  Parameters: TDictionary<string, Variant>;
  b: boolean;
begin

  sql := 'SELECT UserID, Password, Salt FROM UserTB WHERE Username = :Username';
  Parameters := TDictionary<string, Variant>.Create();
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
  b := FALSE;
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

function TDataModule1.runSQL(sql: string;
  params: TDictionary<string, Variant> = nil): tADODataSet;
var
  dsOutput: tADODataSet;
  Item: TPair<string, Variant>;
begin
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
          Query.Open;
          dsOutput.Free;
          dsOutput := tADODataSet.Create(Nil);
          dsOutput.Recordset := Query.Recordset.Clone(1);
        end
        else
        begin
          Query.ExecSQL;
          dsOutput.InsertRecord(['Success']);
        end;

      end;
    except
      on e: EADOError do
      begin
        dsOutput.InsertRecord([e.Message]);

      end;
    end;
  finally
    Result := dsOutput;
  end;

end;

procedure TDataModule1.sendRating(itemID: string; rating: integer);
begin

end;

function TDataModule1.SignUp(Username, password, usertype, homeAddress,
  certificationcode: string): string;
var
  hash, salt: string;
  UserId, sql: string;
  params: TDictionary<String, Variant>;
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
  params := TDictionary<string, Variant>.Create();

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
    end;

  end;

  Result := UserId;

end;

procedure TDataModule1.updateItem(itemID, Name, SellerID, category,
  Desc: string; Price, CF, EU, WU, CFProduce, EUProduce, WUProduce: double;
  Image: tPngImage);
var
  sql: string;
  params: TDictionary<string, Variant>;
  dsResult: tADODataSet;
  imageBytes: tBytes;
  memStream: tStream;
begin
  sql := 'UPDATE ItemTB SET ItemName = :ItemName, Cost = :Cost,' +
    ' CarbonFootprintProduction = :CarbonFootprintProduction, WaterUsageProduction = :WaterUsageProduction, EnergyUsageProduction = :EnergyUsageProduction, '
    + 'CarbonFootprintUsage = :CarbonFootprintUsage, WaterFootprintUsage = :WaterFootprintUsage, EnergyFootprintUsage = :EnergyFootprintUsage,'
    + ' SellerID = :SellerID , Description =  :Description, Image = :Image , Category = :Category '
    + 'WHERE ItemID = :ItemID';

  params.Create();
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

  try
    memStream := TMemoryStream.Create();
    try
      // save the png image as an OLE object
      Image.SaveToStream(memStream);
      SetLength(imageBytes, memStream.Size);
      memStream.Position := 0;
      memStream.Read(imageBytes, Length(imageBytes));
      // add to parameters
      params.Add('Image', imageBytes);
    finally
      memStream.Free;
    end;

    dsResult := runSQL(sql, params);

    if dsResult['Status'] <> 'Success' then
    begin
      showMessage(dsResult['Status']);
    end;
  finally
    dsResult.Free;
    params.Free;
  end;

end;

function TDataModule1.userInfo(UserId: string): tADODataSet;
begin

end;

function TDataModule1.viewItem(itemID: string): tADODataSet;
begin

end;

end.
