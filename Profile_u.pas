unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart,
  VclTee.TeeChartLayout, VclTee.Series, DmUnit_u, Data.Win.ADODB,
  System.Generics.Collections, DateUtils, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Buttons;

type
  TfrmProfile = class(TForm)
    imgProfilePic: TImage;
    lblUsername: TLabel;
    flpnlCategories: TFlowPanel;
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
    pnlBack: TPanel;
    SpeedButton1: TSpeedButton;
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    pnlViewYourProducts: TPanel;
    btnViewProducts: TSpeedButton;
    pnlAddFunds: TPanel;
    btnAddFunds: TSpeedButton;
    pnlCF: TPanel;
    btnCF: TSpeedButton;
    pnlEu: TPanel;
    btnEU: TSpeedButton;
    pnlSales: TPanel;
    btnSales: TSpeedButton;
    pnlRevenue: TPanel;
    btnRevenue: TSpeedButton;
    pnlWU: TPanel;
    btnWU: TSpeedButton;
    pnlSpending: TPanel;
    btnSpending: TSpeedButton;
    pnlLeft: TPanel;
    btnLeft: TSpeedButton;
    pnlRight: TPanel;
    btnRight: TSpeedButton;
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
    procedure imgProfilePicClick(Sender: TObject);
    procedure btnAddFundsClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure ShowCategButtons(UserType: string);
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
  balance: double;

implementation

uses
  BrowseItems_u, YourProducts_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmProfile.btnBackClick(Sender: TObject);
begin
  //
  frmProfile.Hide;
  frmBrowse.Show;
end;

procedure TfrmProfile.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  frmHelp.Show;
  self.Hide;
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

procedure TfrmProfile.btnAddFundsClick(Sender: TObject);
var
  dExtra: double;
begin
  dExtra := strtofloat(InputBox('Funds', 'Add funds:', ''));

  try
    DataModule1.addFunds(DataModule1.userID, dExtra);
    balance := balance + dExtra;

    lblBalance.Caption := 'Current Balance: ' + floatToStrf(balance,
      ffCurrency, 8, 2);

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;
  end;
end;

procedure TfrmProfile.categoryClickStats(Sender: TObject);
begin
  if Sender is TSpeedButton then
  begin

    // get the code for this category
    NameToCateg.TryGetValue(TButton(Sender).Caption, sType);

    chrtStats.Title.Caption := 'Your ' + TButton(Sender).Caption;

    UpdateChart;

  end;

end;

procedure TfrmProfile.changeChartDateRange(direction: integer);
begin

  dateRangeBegin := IncMonth(dateRangeBegin, direction);
  dateRangeEnd := IncMonth(dateRangeEnd, direction);
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
  imageStream: tStream;
begin
  //

  NameToCateg := TObjectDictionary<string, string>.Create();

  NameToCateg.Add('Sales', 'SAL');
  NameToCateg.Add('Spending', 'SPE');
  NameToCateg.Add('Carbon Footprint', 'CF');
  NameToCateg.Add('Energy Usage', 'EU');
  NameToCateg.Add('Water Usage', 'WU');
  NameToCateg.Add('Revenue', 'REV');

  dsResult := DataModule1.userInfo(DataModule1.userID);

  showTotals(dsResult['UserType']);
  ShowCategButtons(dsResult['UserType']);

  lblUsername.Caption := dsResult['Username'];

  balance := dsResult['Balance'];

  lblBalance.Caption := 'Current Balance: ' + floatToStrf(balance,
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

  dateLowerLimit := IncMonth(DataModule1.dDate, -9);

  dateRangeEnd := StrToDate(intTOstr(YearOf(DataModule1.dDate)) + '/' +
    intTOstr(MonthOf(DataModule1.dDate) + 1) + '/01');
  dateRangeBegin := StrToDate(intTOstr(YearOf(dateLowerLimit)) + '/' +
    intTOstr(MonthOf(dateLowerLimit)) + '/01');

  srsStats.Marks.Visible := False;

  imageStream := dsResult.CreateBlobStream
    (dsResult.FieldByName('ProfileImage'), bmRead);
  try
    imgProfilePic.Picture.LoadFromStream(imageStream);

  finally
    imageStream.Free;

  end;

end;

procedure TfrmProfile.imgProfilePicClick(Sender: TObject);
begin
  // open filchooser
  DataModule1.loadImageFromFile(imgProfilePic, self);

  try
    DataModule1.setProfilePicture(DataModule1.userID, imgProfilePic);

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;

end;

// Takes the caption of the button and returns thestring value
// that is used in the database to represent that category of stats
procedure TfrmProfile.NameTOCategString(sName: string);
begin

  //
end;

procedure TfrmProfile.ShowCategButtons(UserType: string);
begin
  if UserType = 'SELLER' then
  begin
    pnlSales.Show;
    pnlRevenue.Show;
  end
  else
  begin
    pnlSales.Hide;
    pnlRevenue.Hide;
  end;

  pnlCF.Show;
  pnlEU.Show;
  pnlWu.Show;
end;

procedure TfrmProfile.showTotals(UserType: string);
begin

  if UserType = 'SELLER' then
  begin
    pnlViewYourProducts.Show;
    lblSales.Show;
    lblRevenueTotal.Show;
  end
  else
  begin
    pnlViewYourProducts.Hide;
    lblSales.Hide;
    lblRevenueTotal.Hide;

  end;
  lblTotalWU.Show;
  lblTotalEU.Show;
  lblTotalCF.Show;
  lblSpendingTotal.Show;
  lblBalance.Show;

end;

procedure TfrmProfile.UpdateChart;
var
  dsResult: TADODataSet;
  i: integer;
  currentDate: tDateTime;
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
