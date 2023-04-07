unit Loginu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  DMUNIT_u,
  Vcl.Mask, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmLogin = class(TForm)
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    btnSignIn: TButton;
    lblSignUp: TLabel;
    btnSignUpScreen: TButton;
    procedure btnSignInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSignUpScreenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  Browseitems_u,
  SignUpu;

{$R *.dfm}

procedure TfrmLogin.btnSignInClick(Sender: TObject);
var
  userName, password: string;
begin

  userName := edtUsername.Text;
  if userName = '' then
  begin
    showMessage('Please enter a Username.');
    Exit;
  end;

  password := edtPassword.Text;
  if password = '' then
  begin
    showMessage('Please enter a password.');
    Exit;
  end;

  with dataModule do
  begin
    UserTB['UserID'] := 'frick';
    UserTB.Post;
    UserTB.Refresh;
  end;
  //
  frmLogin.Hide;

  frmBrowse.Show;
end;

procedure TfrmLogin.btnSignUpScreenClick(Sender: TObject);
begin
  frmLogin.Hide;
  frmSignUp.Show;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

end.
