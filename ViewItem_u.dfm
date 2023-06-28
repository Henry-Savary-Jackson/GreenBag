object frmViewItem: TfrmViewItem
  Left = 0
  Top = 0
  ActiveControl = spnQuantity
  Caption = 'View Item'
  ClientHeight = 742
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object imgItem: TImage
    Left = 152
    Top = 8
    Width = 105
    Height = 105
    Center = True
    Stretch = True
  end
  object lblDesc: TLabel
    Left = 64
    Top = 434
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object lblCategory: TLabel
    Left = 92
    Top = 400
    Width = 49
    Height = 13
    Caption = 'Category:'
  end
  object lblCFProduce: TLabel
    Left = 136
    Top = 259
    Width = 141
    Height = 13
    Caption = 'Carbon Footprint to produce:'
  end
  object lblEUProduce: TLabel
    Left = 137
    Top = 278
    Width = 125
    Height = 13
    Caption = 'Energy usage to produce:'
  end
  object lblWUProduce: TLabel
    Left = 137
    Top = 297
    Width = 121
    Height = 13
    Caption = 'Water usage to produce:'
  end
  object lblPrice: TLabel
    Left = 185
    Top = 184
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblName: TLabel
    Left = 184
    Top = 143
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object lblSeller: TLabel
    Left = 185
    Top = 162
    Width = 30
    Height = 13
    Caption = 'Seller:'
  end
  object lblQuantity: TLabel
    Left = 95
    Top = 544
    Width = 46
    Height = 13
    Caption = 'Quantity:'
  end
  object lblRating: TLabel
    Left = 105
    Top = 575
    Width = 38
    Height = 13
    Caption = 'Rating: '
  end
  object lblYourRating: TLabel
    Left = 101
    Top = 608
    Width = 60
    Height = 13
    Caption = 'Your Rating:'
  end
  object lblCF: TLabel
    Left = 117
    Top = 331
    Width = 157
    Height = 13
    Caption = 'Carbon footprint through usage:'
  end
  object lblEU: TLabel
    Left = 102
    Top = 350
    Width = 174
    Height = 13
    Caption = 'Energy consumption through usage:'
  end
  object lblWU: TLabel
    Left = 117
    Top = 369
    Width = 170
    Height = 13
    Caption = 'Water consumption through usage:'
  end
  object lblStock: TLabel
    Left = 182
    Top = 203
    Width = 30
    Height = 13
    Caption = 'Stock:'
  end
  object lblMaxWithdraw: TLabel
    Left = 8
    Top = 222
    Width = 234
    Height = 13
    Caption = 'Maximum Stock you can withdraw at once:'
    WordWrap = True
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
  object btnAddToCart: TButton
    Left = 136
    Top = 699
    Width = 105
    Height = 35
    Caption = 'Add to Cart'
    TabOrder = 1
    OnClick = btnAddToCartClick
  end
  object redDesc: TRichEdit
    Left = 150
    Top = 431
    Width = 185
    Height = 89
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    Zoom = 100
  end
  object spnQuantity: TSpinEdit
    Left = 182
    Top = 541
    Width = 49
    Height = 22
    MaxValue = 1000
    MinValue = 1
    TabOrder = 3
    Value = 1
  end
  object trcRating: TTrackBar
    Left = 184
    Top = 604
    Width = 105
    Height = 37
    Max = 5
    TabOrder = 4
  end
  object btnSendRating: TButton
    Left = 151
    Top = 647
    Width = 91
    Height = 25
    Caption = 'Send your Rating'
    TabOrder = 5
    OnClick = btnSendRatingClick
  end
end
