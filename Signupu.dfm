object frmSignUp: TfrmSignUp
  Left = 0
  Top = 0
  Caption = 'Sign Up'
  ClientHeight = 561
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object lblUsername: TLabel
    Left = 103
    Top = 59
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object lblPassword: TLabel
    Left = 103
    Top = 107
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object lblLogin: TLabel
    Left = 97
    Top = 496
    Width = 125
    Height = 13
    Caption = 'Already have an account?'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblCertificationCode: TLabel
    Left = 72
    Top = 272
    Width = 119
    Height = 13
    Caption = 'Seller Certification Code:'
  end
  object lblHomeAddress: TLabel
    Left = 88
    Top = 336
    Width = 73
    Height = 13
    Caption = 'Home Address:'
  end
  object rgpUser: TRadioGroup
    Left = 127
    Top = 176
    Width = 185
    Height = 59
    ItemIndex = 1
    Items.Strings = (
      'Seller'
      'Buyer')
    TabOrder = 0
    OnClick = rgpUserClick
  end
  object edtPassword: TEdit
    Left = 191
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'password'
  end
  object edtUsername: TEdit
    Left = 191
    Top = 56
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'User'
  end
  object edtCertification: TEdit
    Left = 226
    Top = 269
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  object btnLoginScreen: TButton
    Left = 226
    Top = 491
    Width = 75
    Height = 25
    Caption = 'Log In'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = btnLoginScreenClick
  end
  object btnSignUp: TButton
    Left = 160
    Top = 440
    Width = 75
    Height = 25
    Caption = 'Sign Up'
    TabOrder = 5
    OnClick = btnSignUpClick
  end
  object redHomeAddress: TRichEdit
    Left = 177
    Top = 333
    Width = 185
    Height = 89
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'somehwere')
    ParentFont = False
    TabOrder = 6
    Zoom = 100
  end
end
