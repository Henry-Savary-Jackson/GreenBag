unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  VCLTee.TeeChartLayout, VCLTee.Series;

type
  TfrmProfile = class(TForm)
    btnBack: TButton;
    imgProfilePic: TImage;
    lblUsername: TLabel;
    btnSalesCategory: TButton;
    btnCFCategory: TButton;
    btnWUCategory: TButton;
    flpnlCategories: TFlowPanel;
    btnEUcategory: TButton;
    btnBalanceCategory: TButton;
    btnSpendCategory: TButton;
    btnViewProducts: TButton;
    lblBalance: TLabel;
    lblRevenueTotal: TLabel;
    lblSales: TLabel;
    lblSpendingTotal: TLabel;
    lblTotalCF: TLabel;
    lblTotalWU: TLabel;
    lblTotalEU: TLabel;
    pnlInfo: TPanel;
    Chart1: TChart;
    ChartLayout1: TChartLayout;
    Series1: TBarSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnViewProductsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    userID : string;
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
frmBrowse.userID := userID;
frmProfile.Hide;
frmBrowse.Show;
end;

procedure TfrmProfile.btnViewProductsClick(Sender: TObject);
begin
//
frmYourProducts.userID := userID;
frmProfile.Hide;
frmYourProducts.Show;
end;

procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
