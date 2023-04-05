unit ViewItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin;

type
  TfrmViewItem = class(TForm)
    btnBack: TButton;
    Image1: TImage;
    btnAddToCart: TButton;
    redDesc: TRichEdit;
    lblDesc: TLabel;
    lblCategory: TLabel;
    lblCF: TLabel;
    lblEU: TLabel;
    lblWaterUsage: TLabel;
    lblPrice: TLabel;
    lblName: TLabel;
    lblSeller: TLabel;
    spnQuantity: TSpinEdit;
    lblQuantity: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddToCartClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmViewItem: TfrmViewItem;

implementation
uses
BrowseItems_u;

{$R *.dfm}

procedure TfrmViewItem.btnAddToCartClick(Sender: TObject);
begin
frmViewItem.Hide;
frmBrowse.Show;
end;

procedure TfrmViewItem.btnBackClick(Sender: TObject);
begin
  frmViewItem.Hide;
 frmBrowse.Show;
end;

procedure TfrmViewItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
