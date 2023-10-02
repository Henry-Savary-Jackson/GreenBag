program GreenBag;

uses
  Vcl.Forms,
  Vcl.dialogs,
  System.SysUtils,
  System.Classes,
  System.Variants,
  Login_u in 'Login_u.pas' {frmLogin},
  DMUNIT_u in 'DMUNIT_u.pas' {DataModule1: TDataModule},
  Signup_u in 'Signup_u.pas' {frmSignUp},
  BrowseItems_u in 'BrowseItems_u.pas' {frmBrowse},
  AddItem_u in 'AddItem_u.pas' {frmAddItem},
  ViewItem_u in 'ViewItem_u.pas' {frmViewItem},
  CheckOut_u in 'CheckOut_u.pas' {frmCheckout},
  Profile_u in 'Profile_u.pas' {frmProfile},
  YourProducts_u in 'YourProducts_u.pas' {frmYourProducts},
  CartItem_u in 'CartItem_u.pas',
  ProductItem_u in 'ProductItem_u.pas',
  BrowseItemContainer_u in 'BrowseItemContainer_u.pas',
  ItemContainer_u in 'ItemContainer_u.pas',
  HelpScreen_u in 'HelpScreen_u.pas' {frmHelp},
  sendApplication_u in 'sendApplication_u.pas' {frmsendApplication},
  reviewApplications_u in 'reviewApplications_u.pas' {frmreviewApplications},
  viewApplication_u in 'viewApplication_u.pas' {frmviewApplication},
  JOSE.Encoding.Base64 in 'Common\JOSE.Encoding.Base64.pas',
  JOSE.Hashing.HMAC in 'Common\JOSE.Hashing.HMAC.pas',
  JOSE.OpenSSL.Headers in 'Common\JOSE.OpenSSL.Headers.pas',
  JOSE.Signing.Base in 'Common\JOSE.Signing.Base.pas',
  JOSE.Signing.ECDSA in 'Common\JOSE.Signing.ECDSA.pas',
  JOSE.Signing.RSA in 'Common\JOSE.Signing.RSA.pas',
  JOSE.Types.Arrays in 'Common\JOSE.Types.Arrays.pas',
  JOSE.Types.Bytes in 'Common\JOSE.Types.Bytes.pas',
  JOSE.Types.JSON in 'Common\JOSE.Types.JSON.pas',
  JOSE.Types.Utils in 'Common\JOSE.Types.Utils.pas',
  JOSE.Builder in 'JOSE\JOSE.Builder.pas',
  JOSE.Consumer in 'JOSE\JOSE.Consumer.pas',
  JOSE.Consumer.Validators in 'JOSE\JOSE.Consumer.Validators.pas',
  JOSE.Context in 'JOSE\JOSE.Context.pas',
  JOSE.Core.Base in 'JOSE\JOSE.Core.Base.pas',
  JOSE.Core.Builder in 'JOSE\JOSE.Core.Builder.pas',
  JOSE.Core.JWA.Compression in 'JOSE\JOSE.Core.JWA.Compression.pas',
  JOSE.Core.JWA.Encryption in 'JOSE\JOSE.Core.JWA.Encryption.pas',
  JOSE.Core.JWA.Factory in 'JOSE\JOSE.Core.JWA.Factory.pas',
  JOSE.Core.JWA in 'JOSE\JOSE.Core.JWA.pas',
  JOSE.Core.JWA.Signing in 'JOSE\JOSE.Core.JWA.Signing.pas',
  JOSE.Core.JWE in 'JOSE\JOSE.Core.JWE.pas',
  JOSE.Core.JWK in 'JOSE\JOSE.Core.JWK.pas',
  JOSE.Core.JWS in 'JOSE\JOSE.Core.JWS.pas',
  JOSE.Core.JWT in 'JOSE\JOSE.Core.JWT.pas',
  JOSE.Core.Parts in 'JOSE\JOSE.Core.Parts.pas',
  JOSE.Producer in 'JOSE\JOSE.Producer.pas';

{$R *.res}

begin
  Application.Initialize;
  // make it so that all other screens can be show on taskbar
  Application.MainFormOnTaskbar := False;
  // create forms
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TfrmSignUp, frmSignUp);
  Application.CreateForm(TfrmBrowse, frmBrowse);
  Application.CreateForm(TfrmAddItem, frmAddItem);
  Application.CreateForm(TfrmViewItem, frmViewItem);
  Application.CreateForm(TfrmCheckout, frmCheckout);
  Application.CreateForm(TfrmProfile, frmProfile);
  Application.CreateForm(TfrmYourProducts, frmYourProducts);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmsendApplication, frmsendApplication);
  Application.CreateForm(TfrmreviewApplications, frmreviewApplications);
  Application.CreateForm(TfrmviewApplication, frmviewApplication);
  Application.Run;
end.
