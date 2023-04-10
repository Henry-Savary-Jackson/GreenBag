unit BrowseItems_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, DMUnit_u, Data.win.ADODB, Vcl.Imaging.pngimage,
  BrowseItemContainer_u, System.Generics.Collections;

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
    procedure OnClickCategory(Sender: tObject);
  private
    { Private declarations }
  public
    userID: string;
    Cart: TObjectList<TObject>;

    { Public declarations }

  end;

var
  frmBrowse: TfrmBrowse;
  categories : TObjectList<tButton>;

implementation

uses
  Loginu, CheckOut_u, profile_u, ViewItem_u;

{$R *.dfm}

procedure TfrmBrowse.btnCheckoutClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmCheckout.Show;
end;

procedure TfrmBrowse.btnLogoutClick(Sender: TObject);
begin
  frmBrowse.Hide;
  frmLogin.Show;
end;

procedure TfrmBrowse.btnProfileClick(Sender: TObject);
begin
  frmProfile.userID := userID;
  frmBrowse.Hide;
  frmProfile.Show;
end;

procedure TfrmBrowse.btnViewItemClick(Sender: TObject);
begin
  frmViewItem.userID := userID;
  frmBrowse.Hide;

  frmViewItem.Show;
end;

procedure TfrmBrowse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmBrowse.FormShow(Sender: TObject);
var
  dsResult: TADODataSet;
  currentButton : tButton;
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

    categories := TObjectList<Tbutton>.Create();



    while not dsResult.Eof do
    begin
      currentButton := TButton.Create(self);
      currentButton.Parent := flpnlItems;
      currentButton.onClick := self.OnClickCategory;
      categories.Add(currentButton);

      dsResult.Next;
    end;

    dsResult.Free;
  end;
  //

  // for I := 1 to 5 do
  // begin
  // items[I] := BrowseItem.Create(self,flpnlItems, 'Null', userID);
  // end;
  //
  // items[4].Free;

end;

procedure TfrmBrowse.grpCheckoutClick(Sender: TObject);
begin
  frmCheckout.userID := userID;
  frmCheckout.Cart := self.Cart;
  frmBrowse.Hide;
  frmCheckout.Show;
end;

procedure TfrmBrowse.imgProfileClick(Sender: TObject);
begin
  //
  frmProfile.userID := userID;
  frmBrowse.Hide;
  frmProfile.Show;
end;

procedure TfrmBrowse.OnClickCategory(Sender: tObject);
var
button : tButton;
begin
//
  if Sender is TButton then
  begin
    tButton := TButton(Sender);
    //use the button's caption as category name
  end;
end;

end.
