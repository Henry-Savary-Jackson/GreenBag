unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.Imaging.pngimage, CartItem_u;

type
  TfrmCheckout = class(TForm)
    btnBack: TButton;
    flpnlItems: TFlowPanel;
    grpItem: TGroupBox;
    btnCheckout: TButton;
    scrbxItems: TScrollBox;
    redItemInfo: TRichEdit;
    spnQuantity: TSpinEdit;
    lblQuantity: TLabel;
    lblTotalCost: TLabel;
    lblTotalCF: TLabel;
    lblTotalEU: TLabel;
    lblTotalWU: TLabel;
    grpRemoveItem: TGroupBox;
    imgRemoveItem: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure imgRemoveItemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCheckout: TfrmCheckout;

implementation
uses
BrowseItems_u;

{$R *.dfm}

procedure TfrmCheckout.btnBackClick(Sender: TObject);
begin
frmCheckout.Hide;
frmBrowse.Show;
end;

procedure TfrmCheckout.btnCheckoutClick(Sender: TObject);
begin
frmCheckout.Hide;
frmBrowse.Show;
end;

procedure TfrmCheckout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TfrmCheckout.FormShow(Sender: TObject);
var
item :  CartItem;
begin
item := CartItem.Create(frmCheckout, flpnlItems, 'lol', 10);
end;

procedure TfrmCheckout.imgRemoveItemClick(Sender: TObject);
var
item :  CartItem;
begin
item := CartItem.Create(frmCheckout, flpnlItems, 'lol', 10);
end;

end.
