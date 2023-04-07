unit AddItem_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TfrmAddItem = class(TForm)
    imgProduct: TImage;
    lblDesc: TLabel;
    lblCategory: TLabel;
    lblCF: TLabel;
    lblEU: TLabel;
    lblWaterUsage: TLabel;
    lblPrice: TLabel;
    lblName: TLabel;
    lblSeller: TLabel;
    btnBack: TButton;
    redDesc: TRichEdit;
    edtName: TEdit;
    edtPrice: TEdit;
    edtCF: TEdit;
    edtEU: TEdit;
    edtWU: TEdit;
    btnSaveChanges: TButton;
    cmbCategory: TComboBox;
    lblRating: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure imgProductClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveChangesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddItem: TfrmAddItem;

implementation
uses
Yourproducts_u;

{$R *.dfm}

procedure TfrmAddItem.btnBackClick(Sender: TObject);
begin
frmAddItem.Hide;
frmYourProducts.Show;
end;

procedure TfrmAddItem.btnSaveChangesClick(Sender: TObject);
begin
//
showMessage('Successfully saved changes');
frmAddItem.Hide;
frmYourProducts.Show;
end;

procedure TfrmAddItem.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TfrmAddItem.imgProductClick(Sender: TObject);
begin
//open filchooser
showMessage('Works')
end;

end.
