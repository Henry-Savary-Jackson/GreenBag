object frmAddItem: TfrmAddItem
  Left = 0
  Top = 0
  Caption = 'Add Item'
  ClientHeight = 598
  ClientWidth = 433
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
  object imgProduct: TImage
    Left = 152
    Top = 24
    Width = 105
    Height = 105
    OnClick = imgProductClick
  end
  object lblDesc: TLabel
    Left = 69
    Top = 473
    Width = 57
    Height = 13
    Caption = 'Description:'
  end
  object lblCategory: TLabel
    Left = 84
    Top = 415
    Width = 49
    Height = 13
    Caption = 'Category:'
  end
  object lblCF: TLabel
    Left = 61
    Top = 287
    Width = 86
    Height = 13
    Caption = 'Carbon FootPrint:'
  end
  object lblEU: TLabel
    Left = 61
    Top = 329
    Width = 71
    Height = 13
    Caption = 'Energy Usage:'
  end
  object lblWaterUsage: TLabel
    Left = 80
    Top = 373
    Width = 67
    Height = 13
    Caption = 'Water Usage:'
  end
  object lblPrice: TLabel
    Left = 99
    Top = 244
    Width = 27
    Height = 13
    Caption = 'Price:'
  end
  object lblName: TLabel
    Left = 102
    Top = 166
    Width = 31
    Height = 13
    Caption = 'Name:'
  end
  object lblSeller: TLabel
    Left = 137
    Top = 209
    Width = 30
    Height = 13
    Caption = 'Seller:'
  end
  object lblRating: TLabel
    Left = 129
    Top = 135
    Width = 38
    Height = 13
    Caption = 'Rating: '
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
    Left = 152
    Top = 449
    Width = 185
    Height = 89
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
    Left = 157
    Top = 163
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtPrice: TEdit
    Left = 157
    Top = 241
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtCF: TEdit
    Left = 157
    Top = 284
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object edtEU: TEdit
    Left = 157
    Top = 326
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object edtWU: TEdit
    Left = 157
    Top = 370
    Width = 121
    Height = 21
    TabOrder = 6
  end
  object btnSaveChanges: TButton
    Left = 157
    Top = 552
    Width = 94
    Height = 25
    Caption = 'Save Changes'
    TabOrder = 7
    OnClick = btnSaveChangesClick
  end
  object cmbCategory: TComboBox
    Left = 157
    Top = 412
    Width = 121
    Height = 21
    TabOrder = 8
  end
end
