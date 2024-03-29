unit Login_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  DMUNIT_u,
  Vcl.Mask, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfrmLogin = class(TForm)
    edtPassword: TEdit;
    edtUsername: TEdit;
    lblUsername: TLabel;
    lblPassword: TLabel;
    lblSignUp: TLabel;
    pnlHelp: TPanel;
    pnlLogin: TPanel;
    sbtnSignIn: TSpeedButton;
    pnlSignup: TPanel;
    sbtnSignUp: TSpeedButton;
    spnHelp: TSpeedButton;
    procedure btnSignInClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSignUpScreenClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

uses
  Browseitems_u, HelpScreen_u,
  SignUp_u;

{$R *.dfm}

procedure TfrmLogin.btnHelpClick(Sender: TObject);
begin
  frmHelp.frmPrevious := self;
  self.Hide;
  frmHelp.Show;
end;

procedure TfrmLogin.btnSignInClick(Sender: TObject);
var
  userName, userID, password: string;
begin

  // input validation
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
    // set global app variables
    frmLogin.Hide;
    DataModule1.userID := userID;
    DataModule1.CartID := DataModule1.CreateUserCart(DataModule1.userID);
    DataModule1.timeCheckTimer.Enabled := true;
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


// allow pressing enter when typing username or password to make you login
procedure TfrmLogin.edtPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    sbtnSignIn.Click;
  end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;

end;


end.
