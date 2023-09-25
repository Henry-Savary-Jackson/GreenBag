unit Profile_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  VclTee.TeeGDIPlus, VclTee.TeEngine, VclTee.TeeProcs, VclTee.Chart,
  VclTee.TeeChartLayout, VclTee.Series, DmUnit_u, Data.Win.ADODB,
  System.Generics.Collections, DateUtils, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Buttons, System.threading, ActiveX;

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
    pnlImage: TPanel;
    pnlMain: TPanel;
    pnlChart: TPanel;
    pnlChangeUsername: TPanel;
    btnChangePassword: TSpeedButton;
    Panel1: TPanel;
    btnChangeUsername: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnViewProductsClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure showTotals(UserType: string);
    procedure categoryClickStats(caption: string);
    procedure NameTOCategString(sName: string);
    procedure UpdateChart();
    procedure btnLeftClick(Sender: TObject);
    procedure changeChartDateRange(direction: integer);
    procedure btnRightClick(Sender: TObject);
    procedure imgProfilePicClick(Sender: TObject);
    procedure btnAddFundsClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure ShowCategButtons(UserType: string);
    procedure btnCFClick(Sender: TObject);
    procedure btnEUClick(Sender: TObject);
    procedure btnRevenueClick(Sender: TObject);
    procedure btnSalesClick(Sender: TObject);
    procedure btnSpendingClick(Sender: TObject);
    procedure btnWUClick(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
    procedure btnChangeUsernameClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;
  dateRangeBegin, dateRangeEnd: tDateTime;
  // this used by the graph to determine what kind of field to analyse
  statType: integer;
  balance: double;

implementation

uses
  BrowseItems_u, YourProducts_u, HelpScreen_u;

{$R *.dfm}

procedure TfrmProfile.btnBackClick(Sender: TObject);
begin
  frmProfile.Hide;
  frmBrowse.Show;
end;

procedure TfrmProfile.btnCFClick(Sender: TObject);
begin
  // this sets the forms statType variable to the needed value
  statType := DataModule1.stCF;
  // calls function to update chart based on button pressed
  categoryClickStats(TSpeedButton(Sender).caption);
end;

procedure TfrmProfile.btnChangePasswordClick(Sender: TObject);
var
  sOldPassword, sNewPassword: string;
begin
  sOldPassword := InputBox('Password Change', 'Enter your old password', '');

  if sOldPassword.IsEmpty then
  begin
    showMessage('Cannot enter an empty password');
    exit;
  end;

  sNewPassword := InputBox('Password Change', 'Enter your new password', '');

  case DataModule1.securePassword(sNewPassword) of
    DataModule1.noSpecial:
      begin
        showMessage('Your password must have atleast one special character.');
        exit;

      end;
    DataModule1.noNums:
      begin
        showMessage('Your password must have atleast one number.');
        exit;

      end;
    DataModule1.tooShort:
      begin
        showMessage('Your password must have be atleast 8 characters long.');
        exit;

      end;
  end;

  ttask.Run(
    procedure
    begin
      DataModule1.changePassword(DataModule1.username, sOldPassword,
        sNewPassword);

      showMessage('Changed your password successfully');
    end);

end;

procedure TfrmProfile.btnChangeUsernameClick(Sender: TObject);
var
  snewusername: string;
begin
  //
  snewusername := InputBox('Change username', 'Enter your new username', '');

  if snewusername.IsEmpty then
  begin
    showMessage('Your username cannot be empty');
    exit
  end;

  ttask.Run(
    procedure
    begin
      CoInitialize(nil);
      try
        try
          DataModule1.Changeusername(DataModule1.username, snewusername,
            DataModule1.jwtToken);

          showMessage('Successfully changed username');

          tthread.Synchronize(nil,
            procedure
            begin
              lblUsername.caption := snewusername;
              DataModule1.username := snewusername;
            end);
        except
          on e: exception do
          begin
            showMessage(e.Message);
          end
        end
      finally

        CounInitialize;
      end
    end)

end;

procedure TfrmProfile.btnEUClick(Sender: TObject);
begin
  statType := DataModule1.stEU;
  categoryClickStats(TSpeedButton(Sender).caption);
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
  UpdateChart();
end;

procedure TfrmProfile.btnRevenueClick(Sender: TObject);
begin
  statType := DataModule1.stRevenue;
  categoryClickStats(TSpeedButton(Sender).caption);
end;

procedure TfrmProfile.btnRightClick(Sender: TObject);
begin
  changeChartDateRange(1);
  UpdateChart;
end;

procedure TfrmProfile.btnSalesClick(Sender: TObject);
begin
  statType := DataModule1.stSales;
  categoryClickStats(TSpeedButton(Sender).caption);
end;

procedure TfrmProfile.btnSpendingClick(Sender: TObject);
begin
  statType := DataModule1.stSpending;
  categoryClickStats(TSpeedButton(Sender).caption);
end;

procedure TfrmProfile.btnViewProductsClick(Sender: TObject);
begin
  frmProfile.Hide;
  frmYourProducts.Show;
end;

procedure TfrmProfile.btnWUClick(Sender: TObject);
begin
  statType := DataModule1.stWU;
  categoryClickStats(TSpeedButton(Sender).caption);
end;

procedure TfrmProfile.btnAddFundsClick(Sender: TObject);
var
  dExtra: double;
begin
  // get amount
  try
    dExtra := strtofloat(InputBox('Funds', 'Add funds:', ''));
  except
    on e: ECONVERTERROR do
    begin
      showMessage
        ('Please format your extra funds as a valid number. Remember to use commas as a decimal point.');
      exit;
    end;
  end;

  ttask.Run(
    procedure
    begin
      CoInitialize(nil);
      try
        try
          // add that amount to user

          DataModule1.addFunds(DataModule1.username,
            DataModule1.jwtToken, dExtra);

          // update gui
          tthread.Synchronize(nil,
            procedure
            begin
              balance := balance + dExtra;

              lblBalance.caption := 'Current Balance: ' + floatToStrf(balance,
                ffCurrency, 8, 2);
            end);

        except
          on e: exception do
          begin
            showMessage(e.Message);
          end;
        end;
      finally
        CounInitialize;
      end

    end);

end;

// code for all buttons to set up the graph and populate it
procedure TfrmProfile.categoryClickStats(caption: string);
begin
  // get the code for this category

  chrtStats.Title.caption := 'Your ' + caption;

  srsStats.XLabel[0] := caption;

  if (statType = DataModule1.stRevenue) or (statType = DataModule1.stSpending)
  then
  begin
    srsStats.XLabel[0] := srsStats.XLabel[0] + '(Rands)';
  end
  else if (statType = DataModule1.stCF) then
  begin
    srsStats.XLabel[0] := srsStats.XLabel[0] + ' (tonnes) ';
  end
  else if (statType = DataModule1.stEU) then
  begin
    srsStats.XLabel[0] := srsStats.XLabel[0] + ' (kWh) ';
  end
  else if (statType = DataModule1.stWU) then
  begin
    srsStats.XLabel[0] := srsStats.XLabel[0] + ' (L) ';
  end
  else if (statType = DataModule1.stSales) then
  begin
    srsStats.XLabel[0] := srsStats.XLabel[0] + ' (units) ';
  end;

  UpdateChart;

end;

procedure TfrmProfile.changeChartDateRange(direction: integer);
begin

  dateRangeBegin := IncMonth(dateRangeBegin, direction);
  dateRangeEnd := IncMonth(dateRangeEnd, direction);
end;

procedure TfrmProfile.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  Application.Terminate;

end;

procedure TfrmProfile.FormShow(Sender: TObject);
var
  dsResult: TADODataSet;
  dateLowerLimit: tDateTime;
  imageStream: tMemoryStream;
begin

  ttask.Run(
    procedure
    begin
      CoInitialize(nil);
      try
        dsResult := DataModule1.userInfo(DataModule1.username);
        try
          tthread.Synchronize(nil,
            procedure
            begin
              showTotals(dsResult['UserType']);
              ShowCategButtons(dsResult['UserType']);

              lblUsername.caption := dsResult['Username'];

              balance := dsResult['Balance'];

              lblBalance.caption := 'Current Balance: ' + floatToStrf(balance,
                ffCurrency, 8, 2);

              lblSpendingTotal.caption := 'Total Spending: ' +
                floatToStrf(dsResult['TotalSpending'], ffCurrency, 8, 2);

              lblTotalCF.caption := 'Total Carbon Footprint: ' +
                floatToStrf(dsResult['TotalCF'], ffFixed, 8, 2) + ' t';

              lblTotalEU.caption := 'Total Energy Usage: ' +
                floatToStrf(dsResult['TotalEU'], ffFixed, 8, 2) + ' kWh';

              lblTotalWU.caption := 'Total Water Usage: ' +
                floatToStrf(dsResult['TotalWU'], ffFixed, 8, 2) + ' L';

              if dsResult['UserType'] = 'SELLER' then
              begin

                lblRevenueTotal.caption := 'Total Revenue: ' +
                  floatToStrf(dsResult['revenue'], ffCurrency, 8, 2);

                lblSales.caption := 'Total Sales: ' +
                  intTOstr(dsResult['TotalSales']);
                if dsResult['TotalSales'] = 1 then
                begin
                  lblSales.caption := lblSales.caption + ' unit'
                end
                else
                begin
                  lblSales.caption := lblSales.caption + ' units'
                end;

              end;
              // decrease current date by 9 months
              dateLowerLimit := IncMonth(Now, -9);
              // date is first day of the month
              dateRangeEnd := StrToDate(intTOstr(YearOf(Now)) + '/' +
                intTOstr(MonthOf(Now) + 1) + '/01');

              // date is first day of next month
              dateRangeBegin := StrToDate(intTOstr(YearOf(dateLowerLimit)) + '/'
                + intTOstr(MonthOf(dateLowerLimit)) + '/01');

              // init chart
              srsStats.Marks.Visible := False;

              chrtStats.Title.caption := '';
              srsStats.Clear;
            end);

          imageStream := DataModule1.loadProfilePicture(DataModule1.username);
          try
            tthread.Synchronize(nil,
              procedure
              begin
                imgProfilePic.Picture.LoadFromStream(imageStream);
              end);
          finally
            imageStream.Free;
          end;
        finally
          dsResult.Free;
        end
      finally
        CounInitialize();
      end

    end);

end;

procedure TfrmProfile.imgProfilePicClick(Sender: TObject);
begin
  // open filchooser
  DataModule1.loadImageFromFile(imgProfilePic, self);

  try
    DataModule1.setProfilePicture(DataModule1.username, DataModule1.jwtToken,
      imgProfilePic);

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
  pnlEu.Show;
  pnlWU.Show;
end;

// show the labels showing total and hide them based on usertype
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

procedure TfrmProfile.UpdateChart();
var
  dsResult: TADODataSet;
  i: integer;
  currentDate: tDateTime;
begin

  // get the statistic
  flpnlCategories.Enabled := False;
  btnLeft.Enabled := False;
  btnRight.Enabled := False;

  ttask.Run(
    procedure
    begin

      CoInitialize(nil);
      tthread.Sleep(2500);
      try
        dsResult := DataModule1.obtainStats(DataModule1.username,
          DataModule1.jwtToken, statType, dateRangeBegin, dateRangeEnd);

        if dsResult.Fields.FindField('Status') <> nil then
        begin
          showMessage(dsResult['Status']);
          FreeAndNil(dsResult);
          exit;
        end;

        tthread.Synchronize(nil,
          procedure
          var
            i: integer;
          begin

            srsStats.Clear;

            dsResult.First;
            currentDate := dateRangeBegin;

            for i := 0 to 9 do
            begin

              if (YearOf(currentDate) = dsResult['y']) and
                (MonthOf(currentDate) = dsResult['m']) then
              begin
                // if there is a month in that data for this month, add data to chart
                srsStats.Add(dsResult['TotalMonth'], intTOstr(dsResult['y']) +
                  '-' + intTOstr(dsResult['m']), clTeeColor);
                dsResult.Next;
              end
              else
              begin
                // if there is no data for that month, put 0 for that month on the chart
                srsStats.Add(0, intTOstr(YearOf(currentDate)) + '-' +
                  intTOstr(MonthOf(currentDate)), clTeeColor);
              end;

              currentDate := IncMonth(currentDate, 1);

            end;
          end);

      finally
        // this is good practice apparently
        CounInitialize();
        // renable chart buttons

        tthread.Synchronize(nil,
          procedure
          begin
            flpnlCategories.Enabled := true;
            btnLeft.Enabled := true;
            btnRight.Enabled := true;
          end);

      end

    end);

end;

end.
