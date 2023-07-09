unit BrowseItems_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, DMUnit_u, Data.win.ADODB, Vcl.Imaging.pngimage,
  BrowseItemContainer_u, System.Generics.Collections, Data.DB, Vcl.Samples.Spin;

type
  TfrmBrowse = class(TForm)
    grpSideBar: TGroupBox;
    srchSearchItems: TSearchBox;
    btnLogout: TButton;
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
    btnHelp: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
    procedure imgProfileClick(Sender: TObject);
    procedure grpCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnClickCategory(Sender: TObject);
    procedure SearchItems(Sender: TObject);
    procedure ViewItem(sellerID, itemID: string);
    procedure srchSearchItemsChange(Sender: TObject);
    procedure chbCFEnableClick(Sender: TObject);
    procedure spnCFMinChange(Sender: TObject);
    procedure spnEUMinChange(Sender: TObject);
    procedure spnWUMinChange(Sender: TObject);
    procedure chbEUEnableClick(Sender: TObject);
    procedure chbWUEnableClick(Sender: TObject);
    procedure chbRatingsEnableClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    category: string;
    items: TObjectList<BrowseItem>;

    { Public declarations }

  end;

var
  frmBrowse: TfrmBrowse;
  categories: TObjectList<TCheckBox>;

implementation

uses
  Loginu, CheckOut_u, profile_u, ViewItem_u, Additem_u, HelpScreen_u;

{$R *.dfm}

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

procedure TfrmBrowse.btnLogoutClick(Sender: TObject);
begin
  try
    DataModule1.CancelCart(DataModule1.CartID);
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
  dsResult: TADODataSet;
  currentCheckbox: TCheckBox;
begin

  dsResult := DataModule1.getCategories;

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
  end
  else
  begin
    dsResult.First;

    if categories <> nil then
      categories.Free;

    categories := TObjectList<TCheckBox>.Create();

    while not dsResult.Eof do
    begin
      currentCheckbox := TCheckBox.Create(self);
      currentCheckbox.Parent := flpnlCategories;
      currentCheckbox.onClick := self.OnClickCategory;
      currentCheckbox.Caption := dsResult['Category'];
      categories.Add(currentCheckbox);

      dsResult.Next;
    end;

    dsResult.Free;

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

procedure TfrmBrowse.OnClickCategory(Sender: TObject);
var
  button: TButton;
begin
  if Sender is TButton then
  begin
    button := TButton(Sender);
    if category = button.Caption then
    begin
      category := '';
      Exit;
    end;
    category := button.Caption;

  end;
end;

procedure TfrmBrowse.SearchItems(Sender: TObject);
var
  dsResult: TADODataSet;
  searchQuery: string;
  arrCategories: TList<string>;
  I, iMinRating: Integer;
  cfRange, euRange, wuRange: array of Integer;

begin

  searchQuery := srchSearchItems.Text;

  if searchQuery = '' then
  begin
    showMessage('Please enter a search query');
    Exit;
  end;

  arrCategories := TList<String>.Create();

  for I := 0 to categories.Count - 1 do
  begin
    if categories.items[I].Checked then
    begin
      arrCategories.Add(categories.items[I].Caption);
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

  if chbRatingsEnable.Checked then
  begin
    iMinRating := spnMinRating.Value;

  end
  else
  begin
    iMinRating := -1;
  end;

  dsResult := DataModule1.getSearchResults(searchQuery, arrCategories, cfRange,
    euRange, wuRange);

  if items <> nil then
  begin
    items.Free;
  end;

  items := TObjectList<BrowseItem>.Create();

  if dsResult.Fields.FindField('Status') <> nil then
  begin
    showMessage(dsResult['Status']);
    Exit;
  end;

  if dsResult.IsEmpty then
  begin
    showMessage('There are no items matching your search query.');
    Exit;
  end;

  dsResult.First;

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

  dsResult.Free;

end;

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
    // bit broken, at 1000 it breaks
    spnWUMax.Value := spnWUMin.Value;
  end;

  spnWUMax.Enabled := spnWUMax.MinValue <> spnWUMax.MaxValue
end;

procedure TfrmBrowse.srchSearchItemsChange(Sender: TObject);
begin

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
