unit DMUNIT_u;

interface

uses
  System.SysUtils, System.Classes, Data.Win.ADODB, Data.DB;

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
  end;

var
  DataModule1: TDataModule1;
  d : TCustomADODataSet;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
//
Connection.Close;

    //scroll to the right and add in your database name
   Connection.ConnectionString :='Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+ExtractFilePath(ParamStr(0))+'GreenBagTB.mdb'+';Persist Security Info=False';

   Connection.LoginPrompt := FALSE;

   Connection.Open;

   //Connection for every table you have
   UserTB.Connection := Connection;//ADOTable1 must be named ADOtablename(your associated table)
   SellerTB.Connection := Connection;
   ItemTB.Connection := Connection;
   TransactionItemTB.Connection := Connection;
   TransactionTB.Connection := Connection;
   StatsTB.Connection := Connection;

   //Each ADOTable is associated with each table name in access
   UserTB.TableName := 'UserTB';//table name spelled as in in MS access
   SellerTB.TableName := 'SellerTB';//table name spelled as in in MS access
   ItemTB.TableName := 'ItemTB';
   TransactionItemTB.TableName := 'TransactionItemTB';
   TransactionTB.TableName := 'TransactionTB';
   StatsTB.TableName := 'StatsTB';

   //a data source is named DSTableName.
   //each data source must be associated with the correct ADOtable
   dsUserTB.DataSet := UserTB;
   dsSellerTB.DataSet:= SellerTB;
   dsItemTB.DataSet := ItemTB;
   dsTransactionItemTB.DataSet := TransactionItemTB;
   dsTransactionTB.DataSet := TransactionTB;
   dsStatsTB.DataSet := StatsTB;

  //leave this line of code commented
  Query.Connection := Connection;

  with dsuserTB do
  begin
  end;
end;



end.
