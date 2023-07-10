object frmCheckout: TfrmCheckout
  Left = 0
  Top = 0
  Caption = 'Checkout'
  ClientHeight = 415
  ClientWidth = 632
  Color = 11074992
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object lblTotalCost: TLabel
    Left = 182
    Top = 318
    Width = 86
    Height = 18
    Caption = 'Total Cost:'
  end
  object lblTotalCF: TLabel
    Left = 104
    Top = 342
    Width = 185
    Height = 18
    Caption = 'Total Carbon Footprint:'
  end
  object lblTotalWU: TLabel
    Left = 354
    Top = 318
    Width = 152
    Height = 18
    Caption = 'Total Water Usage:'
  end
  object lblTotalEU: TLabel
    Left = 354
    Top = 342
    Width = 161
    Height = 18
    Caption = 'Total Energy Usage:'
  end
  object scrbxItems: TScrollBox
    Left = 8
    Top = 45
    Width = 616
    Height = 258
    HorzScrollBar.Tracking = True
    VertScrollBar.Tracking = True
    TabOrder = 0
    object flpnlItems: TFlowPanel
      Left = 3
      Top = 3
      Width = 598
      Height = 107
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
    Color = 8118149
    ParentBackground = False
    TabOrder = 1
    OnClick = btnBackClick
    object SpeedButton1: TSpeedButton
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
  object pnlHelp: TPanel
    Left = 551
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 2
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
      ExplicitTop = 0
    end
  end
  object pnlCheckout: TPanel
    Left = 263
    Top = 366
    Width = 106
    Height = 41
    Color = 8118149
    ParentBackground = False
    TabOrder = 3
    object btnCheckout: TSpeedButton
      Left = 1
      Top = 1
      Width = 104
      Height = 39
      Align = alClient
      Caption = 'Check Out'
      Flat = True
      OnClick = btnCheckoutClick
      ExplicitLeft = -23
      ExplicitTop = 0
      ExplicitWidth = 183
    end
  end
end
