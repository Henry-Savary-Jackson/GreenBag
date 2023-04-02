unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmProfile = class(TForm)
    btnBack: TButton;
    Image1: TImage;
    lblUsername: TLabel;
    btnSalesCategory: TButton;
    btnCFCategory: TButton;
    btnWUCategory: TButton;
    flpnlCategories: TFlowPanel;
    btnEUcategory: TButton;
    flpnlInfo: TFlowPanel;
    btnBalanceCategory: TButton;
    btnSpendCategory: TButton;
    btnViewProducts: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnViewProductsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;

implementation
uses
BrowseItems_u, YourProducts_u;

{$R *.dfm}

procedure TfrmProfile.btnBackClick(Sender: TObject);
begin
//
frmProfile.Hide;
frmBrowse.Show;
end;

procedure TfrmProfile.btnViewProductsClick(Sender: TObject);
begin
//
frmProfile.Hide;
frmYourProducts.Show;
end;

procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
