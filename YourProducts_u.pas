unit YourProducts_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage, ProductItem_u;

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
    userID : string;
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
products : array[1..8] of ProductItem;
  i: Integer;
begin
//
for i := 1 to 8 do
begin
  products[i] := ProductItem.Create(self,flpnlProducts, 'Null');
end;
end;

procedure TfrmYourProducts.imgRemoveProductClick(Sender: TObject);
begin
//remove a product
end;

end.
