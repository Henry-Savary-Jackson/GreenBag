unit BrowseItems_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Imaging.pngimage, BrowseItemContainer_u;

type
  TfrmBrowse = class(TForm)
    grpSideBar: TGroupBox;
    srchSearchItems: TSearchBox;
    btnLogout: TButton;
    grpHeader: TGroupBox;
    scrbxCategories: TScrollBox;
    flpnlItems: TFlowPanel;
    scrbxItems: TScrollBox;
    buttonn: TButton;
    imgProfile: TImage;
    grpMain: TGroupBox;
    grpCheckout: TGroupBox;
    lblCheckout: TLabel;
    Image3: TImage;
    flpnlCategories: TFlowPanel;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnLogoutClick(Sender: TObject);
    procedure btnProfileClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
    procedure btnViewItemClick(Sender: TObject);
    procedure imgProfileClick(Sender: TObject);
    procedure grpCheckoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrowse: TfrmBrowse;

implementation
uses
Loginu,CheckOut_u, profile_u, ViewItem_u;

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
Application.Terminate;
end;



procedure TfrmBrowse.FormShow(Sender: TObject);
var
items :array [1..5] of BrowseItem;
  I: Integer;
begin
//

for I := 1 to 5 do
begin
  items[I] := BrowseItem.Create(self,flpnlItems, 'Null');
end;

items[4].Free;
end;

procedure TfrmBrowse.grpCheckoutClick(Sender: TObject);
begin
frmBrowse.Hide;
frmCheckout.Show;
end;

procedure TfrmBrowse.imgProfileClick(Sender: TObject);
begin
//
frmBrowse.Hide;
frmProfile.Show;
end;

end.
