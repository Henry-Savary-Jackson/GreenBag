object frmAddItem: TfrmAddItem
  Left = 0
  Top = 0
  Caption = 'Add Item'
  ClientHeight = 712
  ClientWidth = 433
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
    Left = 161
    Top = 24
    Width = 105
    Height = 105
    Center = True
    Stretch = True
    OnClick = imgItemClick
  end
  object lblDesc: TLabel
    Left = 93
    Top = 598
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object lblCategory: TLabel
    Left = 108
    Top = 540
    Width = 49
    Height = 13
    Caption = 'Category:'
  end
  object lblCF: TLabel
    Left = 26
    Top = 330
    Width = 133
    Height = 13
    Caption = 'Carbon FootPrint of its use:'
  end
  object lblEU: TLabel
    Left = 41
    Top = 357
    Width = 118
    Height = 13
    Caption = 'Energy Usage of its use:'
  end
  object lblWaterUsage: TLabel
    Left = 53
    Top = 391
    Width = 114
    Height = 13
    Caption = 'Water Usage of its use:'
  end
  object lblPrice: TLabel
    Left = 123
    Top = 223
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblName: TLabel
    Left = 126
    Top = 174
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object lblSeller: TLabel
    Left = 145
    Top = 201
    Width = 30
    Height = 13
    Caption = 'Seller:'
  end
  object lblRating: TLabel
    Left = 130
    Top = 143
    Width = 38
    Height = 13
    Caption = 'Rating: '
  end
  object lblCFProduce: TLabel
    Left = 8
    Top = 432
    Width = 167
    Height = 13
    Caption = 'Carbon FootPrint of its production:'
  end
  object lblEUProduce: TLabel
    Left = 27
    Top = 474
    Width = 148
    Height = 13
    Caption = 'Energy Usage of its production'
  end
  object lblWUProduce: TLabel
    Left = 27
    Top = 510
    Width = 148
    Height = 13
    Caption = 'Water Usage of its production:'
  end
  object lblStock: TLabel
    Left = 118
    Top = 255
    Width = 30
    Height = 13
    Caption = 'Stock:'
  end
  object lblMaxWithdrawStock: TLabel
    Left = 26
    Top = 290
    Width = 142
    Height = 26
    Caption = 'Maximum withdrawable stock per customer'
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
  object redDesc: TRichEdit
    Left = 176
    Top = 574
    Width = 185
    Height = 67
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    Zoom = 100
  end
  object edtName: TEdit
    Left = 181
    Top = 171
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtPrice: TEdit
    Left = 181
    Top = 220
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtCF: TEdit
    Left = 181
    Top = 322
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtEU: TEdit
    Left = 181
    Top = 349
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtWU: TEdit
    Left = 181
    Top = 388
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object btnSaveChanges: TButton
    Left = 181
    Top = 661
    Width = 94
    Height = 25
    Caption = 'Save Changes'
    TabOrder = 7
    OnClick = btnSaveChangesClick
  end
  object cmbCategory: TComboBox
    Left = 181
    Top = 537
    Width = 121
    Height = 21
    TabOrder = 8
  end
  object edtCFProduce: TEdit
    Left = 181
    Top = 429
    Width = 121
    Height = 21
    TabOrder = 9
  end
  object edtEUProduce: TEdit
    Left = 181
    Top = 466
    Width = 121
    Height = 21
    TabOrder = 10
  end
  object edtWUProduce: TEdit
    Left = 181
    Top = 502
    Width = 121
    Height = 21
    TabOrder = 11
  end
  object edtStock: TEdit
    Left = 181
    Top = 252
    Width = 121
    Height = 21
    TabOrder = 12
  end
  object edtMaxWithdrawStock: TEdit
    Left = 181
    Top = 287
    Width = 121
    Height = 21
    TabOrder = 13
  end
end
