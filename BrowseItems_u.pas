unit BrowseItems_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, DMUnit_u, Data.win.ADODB, Vcl.Imaging.pngimage,
  BrowseItemContainer_u, System.Generics.Collections, Data.DB;

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
  private
    { Private declarations }
  public
    category: string;
    items: TObjectList<BrowseItem>;
    // id of current shopping cart of user , create for every sessio

    { Public declarations }

  end;

var
  frmBrowse: TfrmBrowse;
  categories: TObjectList<TButton>;

implementation

uses
  Loginu, CheckOut_u, profile_u, ViewItem_u, Additem_u;

{$R *.dfm}

procedure TfrmBrowse.btnCheckoutClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmCheckout.Show;
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
  currentButton: TButton;
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

    categories := TObjectList<TButton>.Create();

    while not dsResult.Eof do
    begin
      currentButton := TButton.Create(self);
      currentButton.Parent := flpnlCategories;
      currentButton.onClick := self.OnClickCategory;
      currentButton.Caption := dsResult['Category'];
      categories.Add(currentButton);

      dsResult.Next;
    end;

    dsResult.Free;
  end;

  if DataModule1.CartID = '' then
  begin
    DataModule1.CartID := DataModule1.CreateUserCart(DataModule1.userID);
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
  frmProfile.Show;
end;

procedure TfrmBrowse.OnClickCategory(Sender: TObject);
var
  button: TButton;
begin
  //
  if Sender is TButton then
  begin
    button := TButton(Sender);
    category := button.Caption;
    // use the button's caption as category name

  end;
end;

procedure TfrmBrowse.SearchItems(Sender: TObject);
var
  dsResult: TADODataSet;
  searchQuery: string;

begin

  //
  flpnlItems.Caption := '';

  searchQuery := srchSearchItems.Text;

  dsResult := DataModule1.getSearchResults(searchQuery, category);

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
    flpnlItems.Caption := 'There are no items matching your search query.';
    Exit;
  end;

  dsResult.First;

  while not dsResult.Eof do
  begin
    items.Add(BrowseItem.Create(self, flpnlItems, dsResult['ItemID'],
      self.ViewItem));
    dsResult.Next;
  end;

  dsResult.Free;

end;

//procedure given to all browse item containers
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

  frmBrowse.Hide;

end;

end.
