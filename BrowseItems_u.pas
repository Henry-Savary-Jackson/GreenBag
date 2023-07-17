unit BrowseItems_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, DMUnit_u, Data.win.ADODB, Vcl.Imaging.pngimage,
  BrowseItemContainer_u, System.Generics.Collections, Data.DB, Vcl.Samples.Spin,
  Vcl.Buttons;

type
  TfrmBrowse = class(TForm)
    grpSideBar: TGroupBox;
    srchSearchItems: TSearchBox;
    grpHeader: TGroupBox;
    scrbxCategories: TScrollBox;
    flpnlItems: TFlowPanel;
    scrbxItems: TScrollBox;
    imgProfile: TImage;
    grpMain: TGroupBox;
    grpCheckout: TGroupBox;
    lblCheckout: TLabel;
    Image3: TImage;
    flpnlCategories: TFlowPanel;
    lblCFRange: TLabel;
    lbWURange: TLabel;
    lblEURange: TLabel;
    spnCFMin: TSpinEdit;
    spnEUMin: TSpinEdit;
    spnWUMin: TSpinEdit;
    lblAndCF: TLabel;
    lblToEU: TLabel;
    lblToWU: TLabel;
    spnCFMax: TSpinEdit;
    spnEUMax: TSpinEdit;
    spnWUMax: TSpinEdit;
    chbCFEnable: TCheckBox;
    chbEUEnable: TCheckBox;
    chbWUEnable: TCheckBox;
    chbRatingsEnable: TCheckBox;
    lblMinRating: TLabel;
    spnMinRating: TSpinEdit;
    pnlHelp: TPanel;
    spnHelp: TSpeedButton;
    pnlLogout: TPanel;
    sbtnLogout: TSpeedButton;
    lblCFUnit: TLabel;
    Label1: TLabel;
    lblEuUnit: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
    procedure imgProfileClick(Sender: TObject);
    procedure grpCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure onSearchBoxClick(Sender: TObject);
    procedure SearchItems();
    procedure ViewItem(sellerID, itemID: string);
    procedure chbCFEnableClick(Sender: TObject);
    procedure spnCFMinChange(Sender: TObject);
    procedure spnEUMinChange(Sender: TObject);
    procedure spnWUMinChange(Sender: TObject);
    procedure chbEUEnableClick(Sender: TObject);
    procedure chbWUEnableClick(Sender: TObject);
    procedure chbRatingsEnableClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnLoadMoreItemsClick(Sender: TObject);
    procedure addQueryResult(dsResult: tAdoDataset; numResults: integer);

  private
    { Private declarations }
  public
    items: TObjectList<BrowseItem>;
    // these 2 variables specify the range in which items must be loaded
    // for example, load the the items between the 40th (including) and 50th item
    scrollRangeMin: integer;
    scrollRangeMax: integer;
    // button to allow use to load more items
    btnLoadMoreitems: tButton;

  const
    // all the current categories
    categoryList: array[0..5] of string = ( 'Toileteries', 'Food', 'Electronics', 'Containers', 'Clothes', 'Other');

    { Public declarations }

  end;

var
  frmBrowse: TfrmBrowse;
  categoryCheckboxes: TObjectList<TCheckBox>;

implementation

uses
  Login_u, CheckOut_u, profile_u, ViewItem_u, Additem_u, HelpScreen_u;

{$R *.dfm}

// this is the read the results of a query for items, and instantiate gui for the results
procedure TfrmBrowse.addQueryResult(dsResult: tAdoDataset; numResults: integer);
var
  iMinRating: integer;
begin

  // the rating filtering is done here instead of in sql, because the query is too complex
  if chbRatingsEnable.Checked then
  begin
    iMinRating := spnMinRating.Value;

  end
  else
  begin
    iMinRating := -1;
  end;

  if Assigned(btnLoadMoreitems) then
    btnLoadMoreitems.Free;

  btnLoadMoreitems := nil;

  dsResult.First;

  // add the items to gui
  while not dsResult.Eof do
  begin
    if not(chbRatingsEnable.Enabled and dsResult['avgRating'] >= iMinRating)
    then
    begin
      dsResult.Next;
      continue;
    end
    else if not(chbRatingsEnable.Enabled) then
    begin
      dsResult.Next;
      continue;
    end;

    items.Add(BrowseItem.Create(self, flpnlItems, dsResult, self.ViewItem));
    dsResult.Next;

  end;

  // only add the load more button if this is not the end of the items in the query
  if (numResults > items.Count) and (items.Count <> 0)then
  begin
    btnLoadMoreitems := tButton.Create(self.Owner);
    btnLoadMoreitems.Caption := 'load More items';
    btnLoadMoreitems.OnClick := btnLoadMoreItemsClick;
    btnLoadMoreitems.Parent := flpnlItems;
    btnLoadMoreitems.Width := 500;
  end;

  scrollRangeMin := scrollRangeMin + 10;
  scrollRangeMax := scrollRangeMin + 10;

end;

procedure TfrmBrowse.btnCheckoutClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmCheckout.Show;
end;

procedure TfrmBrowse.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmBrowse.btnLoadMoreItemsClick(Sender: TObject);
begin
  if Sender is tButton then
  begin
    SearchItems;
  end;
end;

procedure TfrmBrowse.btnLogoutClick(Sender: TObject);
begin
  try
    DataModule1.CancelCart(DataModule1.CartID);

    if items <> nil then
      items.Clear;

    srchSearchItems.Text := '';

    spnCFMin.Value := 0;
    spnWUMin.Value := 0;
    spnEUMin.Value := 0;
    spnCFMax.Value := 0;
    spnWUMax.Value := 0;
    spnEUMax.Value := 0;

    spnMinRating.Value := 0;

    chbCFEnable.Checked := False;
    chbEUEnable.Checked := False;
    chbWUEnable.Checked := False;
    chbRatingsEnable.Checked := False;

    if btnLoadMoreitems <> nil then
    begin
      btnLoadMoreitems.Free;
      btnLoadMoreitems := nil;
    end;

    frmBrowse.Hide;
    frmLogin.Show;

  except
    on e: exception do
    begin
      showMessage(e.Message);
    end;

  end;
end;

procedure TfrmBrowse.btnProfileClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmProfile.Show;
end;

procedure TfrmBrowse.btnViewItemClick(Sender: TObject);
begin
  frmBrowse.Hide;

  frmViewItem.Show;
end;

procedure TfrmBrowse.chbCFEnableClick(Sender: TObject);
begin
  spnCFMin.Enabled := not spnCFMin.Enabled;
  spnCFMax.Enabled := not spnCFMax.Enabled;
end;

procedure TfrmBrowse.chbEUEnableClick(Sender: TObject);
begin
  spnEUMin.Enabled := not spnEUMin.Enabled;
  spnEUMax.Enabled := not spnEUMax.Enabled;
end;

procedure TfrmBrowse.chbRatingsEnableClick(Sender: TObject);
begin
  spnMinRating.Enabled := not spnMinRating.Enabled;
end;

procedure TfrmBrowse.chbWUEnableClick(Sender: TObject);
begin
  spnWUMin.Enabled := not spnWUMin.Enabled;
  spnWUMax.Enabled := not spnWUMax.Enabled;
end;

procedure TfrmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
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

procedure TfrmBrowse.FormShow(Sender: TObject);
var
  dsResult: tAdoDataset;
  currentCheckbox: TCheckBox;
  i: integer;
begin

  // add all the categories to gui
  dsResult := DataModule1.getCategories;

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
  end
  else
  begin
    dsResult.First;

    if categoryCheckboxes <> nil then
      categoryCheckboxes.Free;

     categoryCheckboxes:= TObjectList<TCheckBox>.Create();

    // add the checkboxes
    for I := 0 to length(categoryList)-1 do

    begin
      currentCheckbox := TCheckBox.Create(self);
      currentCheckbox.Parent := flpnlCategories;
      currentCheckbox.Caption := categoryList[i];
      categoryCheckboxes.add(currentCheckbox);

      dsResult.Next;
    end;

    dsResult.Free;

    // load profile picture
    DataModule1.loadProfilePicture(DataModule1.userID, imgProfile);
  end;

end;

procedure TfrmBrowse.grpCheckoutClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmCheckout.Show;
end;

procedure TfrmBrowse.imgProfileClick(Sender: TObject);
begin
  frmBrowse.Hide;
  DataModule1.lastForm := self;
  frmProfile.Show;
end;




procedure TfrmBrowse.onSearchBoxClick(Sender: TObject);
begin
  if items <> nil then
  begin
    items.Free;
    items := nil;
  end;
  if btnLoadMoreitems <> nil then
  begin
    btnLoadMoreitems.Free;
    btnLoadMoreitems := nil;
  end;
  scrollRangeMin := 0;
  scrollRangeMax := 10;
  SearchItems;
  if items.Count = 0 then
  begin
    showMessage('There no items matching your query');
  end;
end;

// use this to get the query info from gui and get a tadodataset with search results
procedure TfrmBrowse.SearchItems();
var
  dsResult: tAdoDataset;
  searchQuery: string;
  arrCategories: TList<string>;
  I, iNumResults, iMinRating: integer;
  cfRange, euRange, wuRange: array of integer;

begin

  searchQuery := srchSearchItems.Text;

  if searchQuery = '' then
  begin
    showMessage('Please enter a search query');
    Exit;
  end;

  /// / get fitler info
  arrCategories := TList<String>.Create();

  for I := 0 to categoryCheckboxes.Count - 1 do
  begin
    if categoryCheckboxes[I].Checked then
    begin
      arrCategories.Add(categoryCheckboxes[I].Caption);
    end;

  end;

  if chbCFEnable.Checked then
  begin
    SetLength(cfRange, 2);
    cfRange[0] := spnCFMin.Value;
    cfRange[1] := spnCFMax.Value;

  end;

  if chbEUEnable.Checked then
  begin
    SetLength(euRange, 2);
    euRange[0] := spnEUMin.Value;
    euRange[1] := spnEUMax.Value;

  end;

  if chbWUEnable.Checked then
  begin

    SetLength(wuRange, 2);
    wuRange[0] := spnWUMin.Value;
    wuRange[1] := spnWUMax.Value;

  end;

  try
    try
      // get results as table
      dsResult := DataModule1.getSearchResults(searchQuery, arrCategories,
        cfRange, euRange, wuRange, [scrollRangeMin, scrollRangeMax],
        iNumResults);

      if items = nil then
        items := TObjectList<BrowseItem>.Create();

      if dsResult.Fields.FindField('Status') <> nil then
      begin
        showMessage(dsResult['Status']);
        Exit;
      end;

      if dsResult.IsEmpty then
      begin
        Exit;
      end;

      // add to gui
      addQueryResult(dsResult, iNumResults);

    except
      on e: exception do
      begin
        showMessage(e.Message);
      end;

    end;

  finally
    if Assigned(dsResult) then
      dsResult.Free;
  end;

end;

// this code ensures you never has a situation where the min value is bigger than max value
procedure TfrmBrowse.spnCFMinChange(Sender: TObject);
begin

  spnCFMax.MinValue := spnCFMin.Value;
  if spnCFMax.Value < spnCFMin.Value then
  begin
    spnCFMax.Value := spnCFMin.Value;

  end;
  spnCFMax.Enabled := spnCFMax.MinValue <> spnCFMax.MaxValue
end;

procedure TfrmBrowse.spnEUMinChange(Sender: TObject);
begin
  spnEUMax.MinValue := spnEUMin.Value;

  if spnEUMax.Value < spnEUMin.Value then
  begin
    spnEUMax.Value := spnEUMin.Value;

  end;
  spnEUMax.Enabled := spnEUMax.MinValue <> spnEUMax.MaxValue
end;

procedure TfrmBrowse.spnWUMinChange(Sender: TObject);
begin

  spnWUMax.MinValue := spnWUMin.Value;

  if spnWUMax.Value < spnWUMin.Value then
  begin
    spnWUMax.Value := spnWUMin.Value;
  end;

  spnWUMax.Enabled := spnWUMax.MinValue <> spnWUMax.MaxValue
end;

// procedure given to all browse item containers
// if the user is the object's seller, rather show them the screen that allows them to edit
procedure TfrmBrowse.ViewItem(sellerID, itemID: string);
begin
  if DataModule1.userID = sellerID then
  begin
    frmAddItem.itemID := itemID;
    frmAddItem.Show;

  end
  else
  begin
    frmViewItem.itemID := itemID;
    frmViewItem.Show;

  end;
  DataModule1.lastForm := self;

  frmBrowse.Hide;

end;

end.
