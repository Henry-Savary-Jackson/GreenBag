object frmProfile: TfrmProfile
  Left = 320
  Top = 0
  AutoSize = True
  Caption = 'Your Profile'
  ClientHeight = 765
  ClientWidth = 713
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
  object lblUsername: TLabel
    Left = 302
    Top = 119
    Width = 107
    Height = 22
    Alignment = taCenter
    Caption = '(Username)'
    Font.Charset = ANSI_CHARSET
    Font.Color = 16384
    Font.Height = -19
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object pnlBack: TPanel
    Left = 8
    Top = 8
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 0
    OnClick = btnBackClick
    object SpeedButton1: TSpeedButton
      Left = 2
      Top = 2
      Width = 71
      Height = 29
      Align = alClient
      Caption = 'Back'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 16384
      Font.Height = -16
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentFont = False
      OnClick = btnBackClick
      ExplicitLeft = 4
      ExplicitTop = 4
    end
  end
  object pnlHelp: TPanel
    Left = 618
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 1
    OnClick = btnHelpClick
    object spnHelp: TSpeedButton
      Left = 2
      Top = 2
      Width = 56
      Height = 29
      Align = alClient
      Caption = '?'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 16384
      Font.Height = -16
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentFont = False
      OnClick = btnHelpClick
      ExplicitLeft = -6
      ExplicitTop = 4
    end
  end
  object pnlImage: TPanel
    Left = 280
    Top = 0
    Width = 129
    Height = 121
    TabOrder = 2
    object imgProfilePic: TImage
      Left = 6
      Top = 0
      Width = 129
      Height = 121
      Hint = 'Change your profile picture here'
      ParentShowHint = False
      ShowHint = True
      Stretch = True
      OnClick = imgProfilePicClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 147
    Width = 713
    Height = 618
    AutoSize = True
    TabOrder = 3
    object pnlInfo: TPanel
      AlignWithMargins = True
      Left = 161
      Top = 4
      Width = 391
      Height = 263
      Margins.Left = 160
      Margins.Right = 160
      Align = alTop
      AutoSize = True
      Padding.Left = 5
      Padding.Top = 5
      Padding.Right = 5
      Padding.Bottom = 5
      TabOrder = 0
      VerticalAlignment = taAlignTop
      object lblBalance: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 9
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Balance:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 115
      end
      object lblRevenueTotal: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 153
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Revenue:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 120
      end
      object lblSales: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 129
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Sales:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 93
      end
      object lblSpendingTotal: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 33
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Spending:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 124
      end
      object lblTotalCF: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 57
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Carbon Footprint:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 185
      end
      object lblTotalEU: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 81
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Energy Usage:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 161
      end
      object lblTotalWU: TLabel
        AlignWithMargins = True
        Left = 9
        Top = 105
        Width = 373
        Height = 18
        Align = alTop
        Alignment = taCenter
        Caption = 'Total Water Usage:'
        Font.Charset = ANSI_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 152
      end
      object pnlAddFunds: TPanel
        Left = 6
        Top = 174
        Width = 379
        Height = 41
        Margins.Top = 10
        Margins.Bottom = 10
        Align = alTop
        AutoSize = True
        Color = 8118149
        ParentBackground = False
        TabOrder = 0
        object btnAddFunds: TSpeedButton
          Left = 1
          Top = 1
          Width = 377
          Height = 39
          Align = alClient
          Caption = 'Add Funds'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnAddFundsClick
          ExplicitTop = -3
          ExplicitWidth = 346
        end
      end
      object pnlViewYourProducts: TPanel
        Left = 6
        Top = 215
        Width = 379
        Height = 42
        Align = alTop
        Color = 7987076
        ParentBackground = False
        TabOrder = 1
        object btnViewProducts: TSpeedButton
          Left = 1
          Top = 1
          Width = 377
          Height = 40
          Align = alClient
          Caption = 'View your products'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnViewProductsClick
          ExplicitLeft = 0
          ExplicitTop = 2
          ExplicitWidth = 346
        end
      end
    end
    object flpnlCategories: TFlowPanel
      Left = 1
      Top = 270
      Width = 711
      Height = 34
      Align = alTop
      AutoSize = True
      AutoWrap = False
      TabOrder = 1
      VerticalAlignment = taAlignTop
      object pnlCF: TPanel
        Left = 1
        Top = 1
        Width = 145
        Height = 32
        Align = alClient
        Color = 8118149
        ParentBackground = False
        TabOrder = 0
        VerticalAlignment = taAlignBottom
        object btnCF: TSpeedButton
          Left = 1
          Top = 1
          Width = 143
          Height = 30
          Align = alClient
          Caption = 'Carbon Footprint'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnCFClick
          ExplicitLeft = -3
          ExplicitTop = 3
        end
      end
      object pnlEu: TPanel
        Left = 146
        Top = 1
        Width = 144
        Height = 32
        Align = alClient
        Color = 8249222
        ParentBackground = False
        TabOrder = 1
        VerticalAlignment = taAlignBottom
        object btnEU: TSpeedButton
          Left = 1
          Top = 1
          Width = 142
          Height = 30
          Align = alClient
          Caption = 'Energy Usage'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnEUClick
          ExplicitLeft = 0
          ExplicitWidth = 122
          ExplicitHeight = 16
        end
      end
      object pnlRevenue: TPanel
        Left = 290
        Top = 1
        Width = 92
        Height = 32
        Align = alClient
        Color = 8380296
        ParentBackground = False
        TabOrder = 2
        VerticalAlignment = taAlignBottom
        object btnRevenue: TSpeedButton
          Left = 1
          Top = 1
          Width = 90
          Height = 30
          Align = alClient
          Caption = 'Revenue'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnRevenueClick
          ExplicitLeft = -3
          ExplicitTop = 3
        end
      end
      object pnlSales: TPanel
        Left = 382
        Top = 1
        Width = 74
        Height = 32
        Align = alClient
        Color = 8249222
        ParentBackground = False
        TabOrder = 3
        VerticalAlignment = taAlignBottom
        object btnSales: TSpeedButton
          Left = 1
          Top = 1
          Width = 72
          Height = 30
          Align = alClient
          Caption = 'Sales'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnSalesClick
          ExplicitLeft = 5
          ExplicitTop = 3
        end
      end
      object pnlSpending: TPanel
        Left = 456
        Top = 1
        Width = 106
        Height = 32
        Align = alClient
        Color = 8446091
        ParentBackground = False
        TabOrder = 4
        VerticalAlignment = taAlignBottom
        object btnSpending: TSpeedButton
          Left = 1
          Top = 1
          Width = 104
          Height = 30
          Align = alClient
          Caption = 'Spending'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnSpendingClick
          ExplicitLeft = 2
          ExplicitTop = 0
          ExplicitWidth = 162
          ExplicitHeight = 40
        end
      end
      object pnlWU: TPanel
        Left = 562
        Top = 1
        Width = 115
        Height = 32
        Align = alClient
        Color = 8446091
        ParentBackground = False
        TabOrder = 5
        VerticalAlignment = taAlignBottom
        object btnWU: TSpeedButton
          Left = 1
          Top = 1
          Width = 113
          Height = 30
          Align = alClient
          Caption = 'Water Usage'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = 16384
          Font.Height = -16
          Font.Name = 'Arial Rounded MT Bold'
          Font.Style = []
          ParentFont = False
          OnClick = btnWUClick
          ExplicitLeft = 121
          ExplicitTop = -46
          ExplicitWidth = 162
          ExplicitHeight = 40
        end
      end
    end
    object pnlChart: TPanel
      Left = 1
      Top = 304
      Width = 711
      Height = 313
      Align = alTop
      TabOrder = 2
      object chrtStats: TChart
        Left = -6
        Top = 13
        Width = 717
        Height = 260
        Cursor = crArrow
        AllowPanning = pmHorizontal
        BackWall.Brush.Gradient.Direction = gdBottomTop
        BackWall.Brush.Gradient.EndColor = clWhite
        BackWall.Brush.Gradient.StartColor = 15395562
        BackWall.Brush.Gradient.Visible = True
        BackWall.Transparent = False
        Foot.Font.Color = clBlue
        Foot.Font.Name = 'Verdana'
        Foot.Visible = False
        Gradient.Direction = gdBottomTop
        Gradient.EndColor = clWhite
        Gradient.MidColor = 15395562
        Gradient.StartColor = 15395562
        Gradient.Visible = True
        LeftWall.Color = 14745599
        Legend.Font.Name = 'Verdana'
        Legend.ResizeChart = False
        Legend.Shadow.Transparency = 0
        Legend.Symbol.Visible = False
        Legend.Title.Font.Height = -1
        Legend.Title.Font.Shadow.Visible = False
        Legend.Title.Visible = False
        Legend.Visible = False
        MarginTop = 3
        RightWall.Color = 14745599
        SubFoot.Visible = False
        SubTitle.Visible = False
        Title.Font.Name = 'Verdana'
        Title.Text.Strings = (
          'Your Revenue')
        BottomAxis.Axis.Color = 4210752
        BottomAxis.Axis.Style = psDash
        BottomAxis.Grid.Color = 11119017
        BottomAxis.LabelsFormat.Font.Name = 'Verdana'
        BottomAxis.MinimumOffset = -22
        BottomAxis.TicksInner.Color = 11119017
        BottomAxis.Title.Font.Name = 'Verdana'
        DepthAxis.Axis.Color = 4210752
        DepthAxis.Grid.Color = 11119017
        DepthAxis.LabelsFormat.Font.Name = 'Verdana'
        DepthAxis.TicksInner.Color = 11119017
        DepthAxis.Title.Font.Name = 'Verdana'
        DepthTopAxis.Axis.Color = 4210752
        DepthTopAxis.Grid.Color = 11119017
        DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
        DepthTopAxis.TicksInner.Color = 11119017
        DepthTopAxis.Title.Font.Name = 'Verdana'
        CustomAxes = <
          item
            Horizontal = False
            OtherSide = False
          end>
        LeftAxis.Axis.Color = 4210752
        LeftAxis.Grid.Color = 11119017
        LeftAxis.LabelsFormat.Font.Name = 'Verdana'
        LeftAxis.LogarithmicBase = 2.718281828459050000
        LeftAxis.TickLength = 3
        LeftAxis.TicksInner.Color = 11119017
        LeftAxis.TickOnLabelsOnly = False
        LeftAxis.Title.Font.Name = 'Verdana'
        Panning.MouseWheel = pmwNone
        RightAxis.Axis.Color = 4210752
        RightAxis.Grid.Color = 11119017
        RightAxis.LabelsFormat.Font.Name = 'Verdana'
        RightAxis.TicksInner.Color = 11119017
        RightAxis.Title.Font.Name = 'Verdana'
        Shadow.Visible = False
        TopAxis.Axis.Color = 4210752
        TopAxis.Grid.Color = 11119017
        TopAxis.LabelsFormat.Font.Name = 'Verdana'
        TopAxis.TicksInner.Color = 11119017
        TopAxis.Title.Font.Name = 'Verdana'
        View3D = False
        View3DOptions.HorizOffset = -6
        View3DOptions.Zoom = 80
        Zoom.MouseButton = mbMiddle
        BevelOuter = bvNone
        ParentColor = True
        TabOrder = 0
        DefaultCanvas = 'TGDIPlusCanvas'
        PrintMargins = (
          15
          20
          15
          20)
        ColorPaletteIndex = -2
        ColorPalette = (
          7368816
          10708548
          3513587
          1330417
          11048782
          7028779
          6519581
          919731
          6144242
          10401629
          9300723
          11842740
          11009707)
        object chrtLayoutStats: TChartLayout
          Left = 664
          Top = -34
          Width = 164
          Height = 356
          HorzScrollBar.Smooth = True
          HorzScrollBar.Tracking = True
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          TabOrder = 0
          Visible = False
          Charts = <>
        end
        object srsStats: TBarSeries
          Marks.Font.OutLine.Visible = True
          Marks.Font.Shadow.Visible = False
          Marks.Visible = False
          Marks.DrawEvery = 5
          Marks.OnTop = True
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
          Data = {0000000000}
        end
      end
      object pnlRight: TPanel
        Left = 383
        Top = 263
        Width = 75
        Height = 33
        Hint = 'go forward in time'
        BorderWidth = 1
        Color = 8380296
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnHelpClick
        object btnRight: TSpeedButton
          Left = 2
          Top = 2
          Width = 71
          Height = 29
          Align = alClient
          Caption = '>'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = btnRightClick
          ExplicitLeft = -6
          ExplicitTop = 10
        end
      end
      object pnlLeft: TPanel
        Left = 238
        Top = 262
        Width = 75
        Height = 33
        Hint = 'Go back in time'
        BorderWidth = 1
        Color = 8249222
        ParentBackground = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnHelpClick
        object btnLeft: TSpeedButton
          Left = 2
          Top = 2
          Width = 71
          Height = 29
          Align = alClient
          Caption = '<'
          Flat = True
          ParentShowHint = False
          ShowHint = True
          OnClick = btnLeftClick
          ExplicitLeft = 10
          ExplicitTop = 10
        end
      end
    end
  end
  object pnlChangeUsername: TPanel
    Left = 421
    Top = 47
    Width = 196
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 4
    OnClick = btnBackClick
    object btnChangePassword: TSpeedButton
      Left = 2
      Top = 2
      Width = 192
      Height = 29
      Align = alClient
      Caption = 'Change Password'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 16384
      Font.Height = -16
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentFont = False
      OnClick = btnChangePasswordClick
      ExplicitLeft = 0
      ExplicitTop = 4
    end
  end
  object Panel1: TPanel
    Left = 423
    Top = 86
    Width = 196
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 5
    OnClick = btnBackClick
    object btnChangeUsername: TSpeedButton
      Left = 2
      Top = 2
      Width = 192
      Height = 29
      Align = alClient
      Caption = 'Change Username'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 16384
      Font.Height = -16
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentFont = False
      OnClick = btnChangeUsernameClick
      ExplicitTop = 0
    end
  end
  object Panel2: TPanel
    Left = 72
    Top = 72
    Width = 184
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 6
    OnClick = btnBackClick
    object btnApplications: TSpeedButton
      Left = 2
      Top = 2
      Width = 180
      Height = 29
      Align = alClient
      Caption = 'Review Applications'
      Flat = True
      Font.Charset = ANSI_CHARSET
      Font.Color = 16384
      Font.Height = -16
      Font.Name = 'Arial Rounded MT Bold'
      Font.Style = []
      ParentFont = False
      OnClick = btnApplicationsClick
      ExplicitLeft = 0
    end
  end
end
