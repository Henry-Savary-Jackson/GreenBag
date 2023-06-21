unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart,
  VclTee.TeeChartLayout, VclTee.Series, DmUnit_u, Data.Win.ADODB,
  System.Generics.Collections, DateUtils, Data.DB, Vcl.Grids, Vcl.DBGrids;

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
    chrtStats: TChart;
    chrtLayoutStats: TChartLayout;
    srsStats: TBarSeries;
    btnLeft: TButton;
    btnRight: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnViewProductsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure showTotals(UserType: string);
    procedure categoryClickStats(Sender: TObject);
    procedure NameTOCategString(sName: string);
    procedure UpdateChart();
    procedure btnLeftClick(Sender: TObject);
    procedure changeChartDateRange(direction: integer);
    procedure btnRightClick(Sender: TObject);
  private
    { Private declarations }
    NameToCateg: TObjectDictionary<string, string>;
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;
  dateRangeBegin, dateRangeEnd: tDateTime;
  sType: string;

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

procedure TfrmProfile.btnLeftClick(Sender: TObject);

begin
  changeChartDateRange(-1);
  UpdateChart;
end;

procedure TfrmProfile.btnRightClick(Sender: TObject);
begin
  changeChartDateRange(1);
  UpdateChart;
end;

procedure TfrmProfile.btnViewProductsClick(Sender: TObject);
begin
  frmProfile.Hide;
  frmYourProducts.Show;
end;

procedure TfrmProfile.categoryClickStats(Sender: TObject);
var
  sCategory: string;
  dsResult: TADODataSet;
  i: integer;
  ds: TDataSource;
begin
  if Sender is TButton then
  begin

    // get the code for this category
    sType := NameToCateg.ExtractPair(TButton(Sender).Caption).Value;

    chrtStats.Title.Caption := 'Your ' + TButton(Sender).Caption;

    UpdateChart;

  end;

end;

procedure TfrmProfile.changeChartDateRange(direction: integer);
begin

  dateRangeBegin := IncMonth(dateRangeBegin, direction);
  dateRangeEnd :=IncMonth(dateRangeEnd, direction);
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
  dsResult: TADODataSet;
  dateLowerLimit: tDateTime;
begin
  //

  NameToCateg := TObjectDictionary<string, string>.Create();

  NameToCateg.Add('Sales', 'SAL');
  NameToCateg.Add('Spending', 'SPE');
  NameToCateg.Add('Carbon Footprint', 'CF');
  NameToCateg.Add('Energy Usage', 'EU');
  NameToCateg.Add('Water Usage', 'WU');
  NameToCateg.Add('Balance', 'BAL');
  NameToCateg.Add('Revenue', 'REV');

  dsResult := DataModule1.userInfo(DataModule1.userID);

  showTotals(dsResult['UserType']);

  lblUsername.Caption := dsResult['Username'];

  lblBalance.Caption := 'Current Balance: ' + floatToStrf(dsResult['Balance'],
    ffCurrency, 8, 2);

  lblSpendingTotal.Caption := 'Total Spending:' +
    floatToStrf(dsResult['TotalSpending'], ffCurrency, 8, 2);

  lblTotalCF.Caption := 'Total Carbon Footprint:' +
    floatToStrf(dsResult['TotalCF'], ffFixed, 8, 2);

  lblTotalEU.Caption := 'Total Energy Usage:' + floatToStrf(dsResult['TotalEU'],
    ffFixed, 8, 2);

  lblTotalWU.Caption := 'Total Water Usage:' + floatToStrf(dsResult['TotalWU'],
    ffFixed, 8, 2);

  if dsResult['UserType'] = 'SELLER' then
  begin

    lblRevenueTotal.Caption := 'Total Revenue: ' +
      floatToStrf(dsResult['Revenue'], ffCurrency, 8, 2);

    lblSales.Caption := 'Total Sales: ' + intTOstr(dsResult['TotalSales']);

  end;

  dateLowerLimit := IncMonth(date, -9);

  dateRangeEnd := StrToDate(intTOstr(YearOf(date)) + '/' +
    intTOstr(MonthOf(date) + 1) + '/01');
  dateRangeBegin := StrToDate(intTOstr(YearOf(dateLowerLimit)) + '/' +
    intTOstr(MonthOf(dateLowerLimit)) + '/01');

  srsStats.Marks.Visible := False;

end;

// Takes the caption of the button and returns thestring value
// that is used in the database to represent that category of stats
procedure TfrmProfile.NameTOCategString(sName: string);
begin

  //
end;

procedure TfrmProfile.showTotals(UserType: string);
begin
  lblBalance.Show;
  lblSpendingTotal.Show;
  lblTotalCF.Show;
  lblTotalEU.Show;
  lblTotalWU.Show;

  if UserType = 'SELLER' then
  begin
    lblRevenueTotal.Show;
    lblSales.Show;
    btnViewProducts.Show;

  end
  else
  begin
    lblRevenueTotal.Hide;
    lblSales.Hide;
    btnViewProducts.Hide;
  end;

end;

procedure TfrmProfile.UpdateChart;
var
  dsResult: TADODataSet;
  i: integer;
  dValue: double;
  currentDate: tDateTime;
  ds: TDataSource;
begin


  dsResult := DataModule1.obtainStats(DataModule1.userID, sType, dateRangeBegin,
    dateRangeEnd);

  srsStats.Clear;

  dsResult.First;
  currentDate := dateRangeBegin;
  for i := 0 to 9 do
  begin

    if (YearOf(currentDate) = dsResult['y']) and
      (MonthOf(currentDate) = dsResult['m']) then
    begin
      srsStats.Add(dsResult['TotalMonth'], intTOstr(dsResult['y']) + '-' +
        intTOstr(dsResult['m']), clTeeColor);
      dsResult.Next;
    end
    else
    begin
      srsStats.Add(0, intTOstr(YearOf(currentDate)) + '-' +
        intTOstr(MonthOf(currentDate)), clTeeColor);
    end;
    currentDate := IncMonth(currentDate, 1);

  end;
end;

end.
