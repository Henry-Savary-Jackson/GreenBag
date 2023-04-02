unit YourProducts_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmYourProducts = class(TForm)
    btnAddItem: TButton;
    flpnlProducts: TFlowPanel;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    procedure btnAddItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmYourProducts: TfrmYourProducts;

implementation
uses
Profile_u,
Additem_u;

{$R *.dfm}

procedure TfrmYourProducts.btnAddItemClick(Sender: TObject);
begin
frmYourProducts.Hide;
frmAddItem.Show;
end;

end.
