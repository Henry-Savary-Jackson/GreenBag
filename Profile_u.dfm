object frmProfile: TfrmProfile
  Left = 0
  Top = 0
  Caption = 'Your Profile'
  ClientHeight = 585
  ClientWidth = 592
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
  object Image1: TImage
    Left = 224
    Top = 8
    Width = 105
    Height = 105
  end
  object lblUsername: TLabel
    Left = 232
    Top = 136
    Width = 83
    Height = 20
    Caption = '(Username)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnBack: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'back'
    TabOrder = 0
    OnClick = btnBackClick
  end
  object flpnlCategories: TFlowPanel
    Left = 24
    Top = 366
    Width = 528
    Height = 43
    AutoSize = True
    AutoWrap = False
    TabOrder = 1
    object btnBalanceCategory: TButton
      AlignWithMargins = True
      Left = 6
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Balance'
      TabOrder = 0
    end
    object btnCFCategory: TButton
      AlignWithMargins = True
      Left = 91
      Top = 9
      Width = 91
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Carbon Footprint'
      TabOrder = 1
    end
    object btnEUcategory: TButton
      AlignWithMargins = True
      Left = 192
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Energy Usage'
      TabOrder = 2
    end
    object btnSalesCategory: TButton
      AlignWithMargins = True
      Left = 277
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Sales'
      TabOrder = 3
    end
    object btnSpendCategory: TButton
      AlignWithMargins = True
      Left = 362
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Spending'
      TabOrder = 4
    end
    object btnWUCategory: TButton
      AlignWithMargins = True
      Left = 447
      Top = 9
      Width = 75
      Height = 25
      Margins.Left = 5
      Margins.Top = 8
      Margins.Right = 5
      Margins.Bottom = 8
      Caption = 'Water Usage'
      TabOrder = 5
    end
  end
  object flpnlInfo: TFlowPanel
    Left = 173
    Top = 201
    Width = 219
    Height = 151
    TabOrder = 2
    object btnViewProducts: TButton
      Left = 1
      Top = 1
      Width = 168
      Height = 25
      Caption = 'View your products'
      TabOrder = 0
      OnClick = btnViewProductsClick
    end
  end
end
