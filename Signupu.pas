unit Signupu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, DMUnit_u, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls;

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
    lblHomeAddress: TLabel;
    redHomeAddress: TRichEdit;
    procedure btnLoginScreenClick(Sender: TObject);
    procedure btnSignUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgpUserClick(Sender: TObject);
    function securePassword(password: string): integer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSignUp: TfrmSignUp;

const
  success = 1;
  tooShort = 4;
  noSpecial = 2;
  noNums = 3;

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
var
  UserId, userName, password, homeaddress, userType,
    certificationCode: string;

begin

  userName := edtUsername.Text;
  if userName = '' then
  begin
    showMessage('Please enter a Username.');
    Exit;
  end;

  if length(userName) > 30 then
  begin
    showMessage('Username must be less than 30 characters.');
    Exit;
  end;

  password := edtPassword.Text;
  if password = '' then
  begin
    showMessage('Please enter a password.');
    Exit;
  end;

  case securePassword(password) of
    noSpecial:
      begin
        showMessage('Your password must have atleast one special character.');
        Exit;

      end;
    noNums:
      begin
        showMessage('Your password must have atleast one number.');
        Exit;

      end;
    tooShort:
      begin
        showMessage('Your password must have be atleast 8 characters long.');
        Exit;

      end;
  end;

  homeaddress := redHomeAddress.Text;

  if homeaddress = '' then
  begin
    showMessage('Please enter a Home Address.');
    Exit;
  end;

  if rgpUser.ItemIndex = -1 then
  begin
    showMessage('Please select your user type.');
    Exit;
  end;

  case rgpUser.ItemIndex of
    0:
      userType := 'SELLER';
    1:
      userType := 'BUYER';
  end;

  certificationCode := edtCertification.Text;

  if rgpUser.ItemIndex = 0 then
  begin
    if certificationCode = '' then
    begin
      showMessage('Please enter a certification code.');
      Exit;
    end;

    if length(certificationCode) > 10 then
    begin
      showMessage('Certificaiton Code must be less than 10 characters.');
      Exit;
    end;

  end;

  UserId := DataModule1.SignUp(userName, password, userType, homeaddress,
    certificationCode);

  if Copy(UserId, 1, 5) = 'Error' then
  begin
    MessageDlg('There was an error accessing the database', mtConfirmation,
      [mbOK], 0, mbOK);
  end;

  frmBrowse.UserId := UserId;
  frmSignUp.Hide;
  frmBrowse.Show;

end;

procedure TfrmSignUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmSignUp.rgpUserClick(Sender: TObject);
begin
  edtCertification.Enabled := rgpUser.ItemIndex = 0
end;

function TfrmSignUp.securePassword(password: string): integer;
var
  i: integer;
const
  nums = '0123456789';
  special = '!@#$%^&*()-+=.,<>?\/|';

begin

  if length(password) < 8 then
  begin
    Result := tooShort;
    Exit;
  end;

  Result := noNums;

  for i := 1 to length(password) do
  begin
    if not(pos(password[i], nums) = 0) then
    begin
      Result := success
    end;

  end;

  if Result = noNums then
  begin
    Exit;
  end;

  Result := noSpecial;

  for i := 1 to length(password) do
  begin
    if not(pos(password[i], special) = 0) then
    begin
      Result := success
    end;

  end;
end;

end.
