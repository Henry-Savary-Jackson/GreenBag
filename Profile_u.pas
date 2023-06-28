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
    procedure imgProfilePicClick(Sender: TObject);
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
begin
  if Sender is TButton then
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

procedure TfrmProfile.showTotals(UserType: string);
begin

  if UserType = 'SELLER' then
  begin
    btnViewProducts.Show;
    lblSales.Show;
    lblRevenueTotal.Show;
  end
  else
  begin
    btnViewProducts.Hide;
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
