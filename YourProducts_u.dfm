object frmYourProducts: TfrmYourProducts
  Left = 274
  Top = 50
  Caption = 'Your Products'
  ClientHeight = 475
  ClientWidth = 490
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object lblNumberProducts: TLabel
    Left = 165
    Top = 25
    Width = 163
    Height = 18
    Caption = 'Number of products:'
    Color = 11074994
    ParentColor = False
  end
  object scrbxProducts: TScrollBox
    Left = 39
    Top = 72
    Width = 425
    Height = 281
    VertScrollBar.Tracking = True
    TabOrder = 0
    object flpnlProducts: TFlowPanel
      Left = 0
      Top = 0
      Width = 421
      Height = 126
      Align = alTop
      AutoSize = True
      TabOrder = 0
    end
  end
  object pnlBack: TPanel
    Left = 13
    Top = 8
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 1
    OnClick = btnBackClick
    object btnBack: TSpeedButton
      Left = 2
      Top = 2
      Width = 71
      Height = 29
      Align = alClient
      Caption = 'Back'
      Flat = True
      OnClick = btnBackClick
      ExplicitLeft = 4
      ExplicitTop = 4
    end
  end
  object pnlAddItem: TPanel
    Left = 173
    Top = 394
    Width = 113
    Height = 51
    BorderWidth = 1
    Color = 8446091
    ParentBackground = False
    TabOrder = 2
    OnClick = btnAddItemClick
    object btnAddItem: TSpeedButton
      Left = 2
      Top = 2
      Width = 109
      Height = 47
      Align = alClient
      Caption = 'Add Item'
      Flat = True
      OnClick = btnAddItemClick
      ExplicitLeft = 4
      ExplicitTop = 4
    end
  end
  object pnlHelp: TPanel
    Left = 414
    Top = 10
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 3
    OnClick = btnHelpClick
    object spnHelp: TSpeedButton
      Left = 2
      Top = 2
      Width = 56
      Height = 29
      Align = alClient
      Caption = '?'
      Flat = True
      OnClick = btnHelpClick
      ExplicitLeft = -14
      ExplicitTop = 4
    end
  end
end
