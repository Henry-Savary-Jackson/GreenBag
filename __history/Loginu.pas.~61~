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
    procedure FormCreate(Sender: TObject);
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
  userName, userID, password: string;
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

  try
    userID := DataModule1.Login(userName, password);

    DataModule1.dDate := StrToDate(inputbox('', 'Date:', ''));
    frmLogin.Hide;
    DataModule1.userID := userID;
    DataModule1.CartID := DataModule1.CreateUserCart(DataModule1.userID);
    frmBrowse.Show;

  except
    on e: Exception do
    begin
      showMessage(e.Message);
    end;

  end;
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

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  Application.MainFormOnTaskbar := False;
end;

end.
