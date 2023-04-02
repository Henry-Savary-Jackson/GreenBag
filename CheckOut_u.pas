unit CheckOut_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin;

type
  TfrmCheckout = class(TForm)
    btnBack: TButton;
    flpnlItems: TFlowPanel;
    grpItem: TGroupBox;
    btnCheckout: TButton;
    scrbxItems: TScrollBox;
    redItemInfo: TRichEdit;
    btnRemove: TButton;
    spnQuantity: TSpinEdit;
    lblQuantity: TLabel;
    lblTotalCost: TLabel;
    lblTotalCF: TLabel;
    lblTotalEU: TLabel;
    lblTotalWU: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    RichEdit1: TRichEdit;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    RichEdit2: TRichEdit;
    Button2: TButton;
    SpinEdit2: TSpinEdit;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    RichEdit3: TRichEdit;
    Button3: TButton;
    SpinEdit3: TSpinEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBackClick(Sender: TObject);
    procedure btnCheckoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCheckout: TfrmCheckout;

implementation
uses
BrowseItems_u;

{$R *.dfm}

procedure TfrmCheckout.btnBackClick(Sender: TObject);
begin
frmCheckout.Hide;
frmBrowse.Show;
end;

procedure TfrmCheckout.btnCheckoutClick(Sender: TObject);
begin
frmCheckout.Hide;
frmBrowse.Show;
end;

procedure TfrmCheckout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
