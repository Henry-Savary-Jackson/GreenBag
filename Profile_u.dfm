object frmProfile: TfrmProfile
  Left = 320
  Top = 0
  Caption = 'Your Profile'
  ClientHeight = 725
  ClientWidth = 700
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
  object imgProfilePic: TImage
    Left = 304
    Top = 0
    Width = 105
    Height = 105
    Stretch = True
    OnClick = imgProfilePicClick
  end
  object lblUsername: TLabel
    Left = 304
    Top = 111
    Width = 107
    Height = 22
    Caption = '(Username)'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial Rounded MT Bold'
    Font.Style = []
    ParentFont = False
  end
  object flpnlCategories: TFlowPanel
    Left = 14
    Top = 410
    Width = 678
    Height = 34
    AutoSize = True
    AutoWrap = False
    TabOrder = 0
    object pnlCF: TPanel
      Left = 1
      Top = 1
      Width = 145
      Height = 32
      Color = 8118149
      ParentBackground = False
      TabOrder = 0
      object btnCF: TSpeedButton
        Left = 1
        Top = 1
        Width = 143
        Height = 30
        Align = alClient
        Caption = 'Carbon Footprint'
        Flat = True
        OnClick = btnCFClick
        ExplicitLeft = 5
        ExplicitTop = 8
      end
    end
    object pnlEu: TPanel
      Left = 146
      Top = 1
      Width = 144
      Height = 32
      Color = 8249222
      ParentBackground = False
      TabOrder = 1
      object btnEU: TSpeedButton
        Left = 1
        Top = 1
        Width = 142
        Height = 30
        Align = alClient
        Caption = 'Energy Usage'
        Flat = True
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
      Color = 8380296
      ParentBackground = False
      TabOrder = 2
      object btnRevenue: TSpeedButton
        Left = 1
        Top = 1
        Width = 90
        Height = 30
        Align = alClient
        Caption = 'Revenue'
        Flat = True
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
      Color = 8249222
      ParentBackground = False
      TabOrder = 3
      object btnSales: TSpeedButton
        Left = 1
        Top = 1
        Width = 72
        Height = 30
        Align = alClient
        Caption = 'Sales'
        Flat = True
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
      Color = 8446091
      ParentBackground = False
      TabOrder = 4
      object btnSpending: TSpeedButton
        Left = 1
        Top = 1
        Width = 104
        Height = 30
        Align = alClient
        Caption = 'Spending'
        Flat = True
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
      Color = 8446091
      ParentBackground = False
      TabOrder = 5
      object btnWU: TSpeedButton
        Left = 1
        Top = 1
        Width = 113
        Height = 30
        Align = alClient
        Caption = 'Water Usage'
        Flat = True
        OnClick = btnWUClick
        ExplicitLeft = 121
        ExplicitTop = -46
        ExplicitWidth = 162
        ExplicitHeight = 40
      end
    end
  end
  object pnlInfo: TPanel
    AlignWithMargins = True
    Left = 169
    Top = 147
    Width = 360
    Height = 261
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 1
    VerticalAlignment = taAlignTop
    object lblBalance: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 9
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Balance:'
      ExplicitWidth = 115
    end
    object lblRevenueTotal: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 153
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Revenue:'
      ExplicitWidth = 120
    end
    object lblSales: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 129
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Sales:'
      ExplicitWidth = 93
    end
    object lblSpendingTotal: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 33
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Spending:'
      ExplicitWidth = 124
    end
    object lblTotalCF: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 57
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Carbon Footprint:'
      ExplicitWidth = 185
    end
    object lblTotalEU: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 81
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Energy Usage:'
      ExplicitWidth = 161
    end
    object lblTotalWU: TLabel
      AlignWithMargins = True
      Left = 9
      Top = 105
      Width = 342
      Height = 18
      Align = alTop
      Alignment = taCenter
      Caption = 'Total Water Usage:'
      ExplicitWidth = 152
    end
    object pnlAddFunds: TPanel
      Left = 6
      Top = 174
      Width = 348
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
        Width = 346
        Height = 39
        Align = alClient
        Caption = 'Add Funds'
        Flat = True
        OnClick = btnAddFundsClick
        ExplicitTop = -3
      end
    end
    object pnlViewYourProducts: TPanel
      Left = 6
      Top = 215
      Width = 348
      Height = 42
      Align = alTop
      Color = 7987076
      ParentBackground = False
      TabOrder = 1
      object btnViewProducts: TSpeedButton
        Left = 1
        Top = 1
        Width = 346
        Height = 40
        Align = alClient
        Caption = 'View your products'
        Flat = True
        OnClick = btnViewProductsClick
        ExplicitLeft = 3
        ExplicitTop = 2
      end
    end
  end
  object chrtStats: TChart
    Left = 0
    Top = 450
    Width = 692
    Height = 258
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
    TabOrder = 2
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
      Left = 583
      Top = -34
      Width = 245
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
      HoverElement = []
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
      Detail = {0000000000}
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
    TabOrder = 3
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
    Left = 618
    Top = 8
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
    ParentBackground = False
    TabOrder = 4
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
      ExplicitLeft = -6
      ExplicitTop = 4
    end
  end
  object pnlLeft: TPanel
    Left = 262
    Top = 694
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8249222
    ParentBackground = False
    TabOrder = 5
    OnClick = btnHelpClick
    object btnLeft: TSpeedButton
      Left = 2
      Top = 2
      Width = 71
      Height = 29
      Align = alClient
      Caption = '<'
      Flat = True
      OnClick = btnLeftClick
      ExplicitLeft = 10
      ExplicitTop = 10
    end
  end
  object pnlRight: TPanel
    Left = 378
    Top = 696
    Width = 75
    Height = 33
    BorderWidth = 1
    Color = 8380296
    ParentBackground = False
    TabOrder = 6
    OnClick = btnHelpClick
    object btnRight: TSpeedButton
      Left = 2
      Top = 2
      Width = 71
      Height = 29
      Align = alClient
      Caption = '>'
      Flat = True
      OnClick = btnRightClick
      ExplicitLeft = -6
    end
  end
end
