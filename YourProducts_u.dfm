object frmYourProducts: TfrmYourProducts
  Left = 0
  Top = 0
  Caption = 'Your Products'
  ClientHeight = 400
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object btnAddItem: TButton
    Left = 200
    Top = 334
    Width = 75
    Height = 25
    Caption = 'Add Item'
    TabOrder = 0
    OnClick = btnAddItemClick
  end
  object ScrollBox1: TScrollBox
    Left = 40
    Top = 40
    Width = 397
    Height = 249
    TabOrder = 1
    object flpnlProducts: TFlowPanel
      Left = 0
      Top = 0
      Width = 187
      Height = 107
      AutoSize = True
      TabOrder = 0
      object GroupBox1: TGroupBox
        Left = 1
        Top = 1
        Width = 185
        Height = 105
        Caption = 'GroupBox1'
        TabOrder = 0
      end
    end
  end
end
