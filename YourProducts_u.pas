unit YourProducts_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.Win.ADODB,
  Vcl.ExtCtrls,
  System.ImageList, DMUnit_u, Vcl.ImgList, Vcl.Imaging.pngimage,
  System.Generics.Collections, ProductItem_u;

type
  TfrmYourProducts = class(TForm)
    btnAddItem: TButton;
    flpnlProducts: TFlowPanel;
    scrbxProducts: TScrollBox;
    btnBack: TButton;
    procedure btnAddItemClick(Sender: TObject);
    procedure imgRemoveProductClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    userID: string;
    items: array of ProductItem;
  end;

var
  frmYourProducts: TfrmYourProducts;

implementation

uses
  Profile_u,
  Additem_u;

{$R *.dfm}

procedure TfrmYourProducts.btnAddItemClick(Sender: TObject);
begin
  frmYourProducts.Hide;
  frmAddItem.userID := userID;
  frmAddItem.Show;
end;

procedure TfrmYourProducts.btnBackClick(Sender: TObject);
begin
  //
  frmYourProducts.Hide;
  frmProfile.Show;
end;

procedure TfrmYourProducts.btnViewItemClick(Sender: TObject);
begin
  frmYourProducts.Hide;
  frmAddItem.Show;
end;

procedure TfrmYourProducts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  Application.Terminate;
end;

procedure TfrmYourProducts.FormShow(Sender: TObject);
var
  dsResult: tADODataSet;

begin

  dsResult := DataModule1.getProducts(userID);

//  if dsResult.FieldDefs.('Status') <> nil then
//  begin
//    showMessage(dsResult['Status']);
//    Exit;
//  end;

  dsResult.First;
  setLength(items, dsResult.RecordCount);

  while not dsResult.Eof do
  begin
    items := items + [ProductItem.Create(self, flpnlProducts, dsResult['ItemID'])];
    dsResult.Next;
  end;

  dsResult.Free;

end;

procedure TfrmYourProducts.imgRemoveProductClick(Sender: TObject);
begin
  // remove a product
end;

end.
