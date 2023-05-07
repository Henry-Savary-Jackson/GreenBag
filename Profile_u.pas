unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart,
  VclTee.TeeChartLayout, VclTee.Series, DmUnit_u, Data.Win.ADODB;

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
    procedure FormShow(Sender: TObject);
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
  try
    try
      DataModule1.CancelCart(DataModule1.CartID);

    except
      on e: exception do
      begin
        showMessage(e.Message);
      end;

    end;

  finally
    Application.Terminate;
  end;
end;

procedure TfrmProfile.FormShow(Sender: TObject);
var
  dsResult: tAdoDataset;
begin
  //
  dsResult :=  DataModule1.userInfo(DataModule1.userID);

  if dsResult['UserType'] = 'BUYER' then
  begin
    lblRevenueTotal.Hide;
    lblSales.Hide;
    btnViewProducts.Hide;
  end
  else
  begin
    //if user is a seller

    lblRevenueTotal.Show;
    lblSales.Show;
    btnViewProducts.Show;

    lblRevenueTotal.Caption := 'Total Revenue: ' + floatToStrf(dsResult['Revenue'],ffCurrency, 8, 2);

    lblSales.Caption := 'Total Sales: ' + intTostr(dsResult['TotalSales']);

  end;

  lblUsername.Caption := dsResult['Username'];

  lblBalance.Caption := 'Current Balance: ' + floatTostrf(dsResult['Balance'],ffCurrency, 8, 2);

  lblSpendingTotal.Caption := 'Total Spending:' +floatTostrf(dsResult['TotalSpending'],ffCurrency, 8, 2);

  lblTotalCF.Caption := 'Total Carbon Footprint:' +floatTostrf(dsResult['TotalCF'],ffFixed,8,2);

  lblTotalEU.Caption :='Total Energy Usage:' + floatTostrf(dsResult['TotalEU'],ffFixed,8,2);

  lblTotalWU.Caption :=  'Total Water Usage:' + floatTostrf(dsResult['TotalWU'],ffFixed,8,2)

end;

end.
