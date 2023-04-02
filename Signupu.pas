unit Signupu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmSignUp = class(TForm)
    rgpUser: TRadioGroup;
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    edtCertification: TEdit;
    lblLogin: TLabel;
    btnLoginScreen: TButton;
    lblCertificationCode: TLabel;
    btnSignUp: TButton;
    procedure btnLoginScreenClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;


implementation
uses
  Loginu, BrowseItems_u;

{$R *.dfm}

procedure TfrmSignUp.btnLoginScreenClick(Sender: TObject);
begin
//
frmSignUp.Hide;
frmLogin.Show;
end;

procedure TfrmSignUp.btnSignUpClick(Sender: TObject);
begin
frmSignUp.Hide;
frmBrowse.Show;

end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

end.
