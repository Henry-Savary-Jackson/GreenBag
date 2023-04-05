unit YourProducts_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Imaging.pngimage;

type
  TfrmYourProducts = class(TForm)
    btnAddItem: TButton;
    flpnlProducts: TFlowPanel;
    ScrollBox1: TScrollBox;
    grpProduct: TGroupBox;
    Image1: TImage;
    btnViewItem: TButton;
    lblName: TLabel;
    lblRevenue: TLabel;
    lblSales: TLabel;
    imgRemoveProduct: TImage;
    grpRemoveProduct: TGroupBox;
    GroupBox1: TGroupBox;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Image3: TImage;
    GroupBox3: TGroupBox;
    Image4: TImage;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button2: TButton;
    GroupBox4: TGroupBox;
    Image5: TImage;
    btnBack: TButton;
    procedure btnAddItemClick(Sender: TObject);
    procedure imgRemoveProductClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
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

procedure TfrmYourProducts.imgRemoveProductClick(Sender: TObject);
begin
//remove a product
end;

end.
