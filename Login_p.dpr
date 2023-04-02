program Login_p;

uses
  Vcl.Forms,
  Loginu in 'Loginu.pas' {frmLogin},
  DMUNIT_u in 'DMUNIT_u.pas' {DataModule1: TDataModule},
  Signupu in 'Signupu.pas' {frmSignUp},
  BrowseItems_u in 'BrowseItems_u.pas' {frmBrowse},
  AddItem_u in 'AddItem_u.pas' {frmAddItem},
  ViewItem_u in 'ViewItem_u.pas' {frmViewItem},
  CheckOut_u in 'CheckOut_u.pas' {frmCheckout},
  Profile_u in 'Profile_u.pas' {frmProfile},
  YourProducts_u in 'YourProducts_u.pas' {frmYourProducts};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmBrowse, frmBrowse);
  Application.CreateForm(TfrmAddItem, frmAddItem);
  Application.CreateForm(TfrmViewItem, frmViewItem);
  Application.CreateForm(TfrmCheckout, frmCheckout);
  Application.CreateForm(TfrmProfile, frmProfile);
  Application.CreateForm(TfrmYourProducts, frmYourProducts);
  Application.Run;
end.
