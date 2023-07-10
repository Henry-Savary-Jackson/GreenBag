object frmBrowse: TfrmBrowse
  Left = 137
  Top = 100
  Caption = 'Browse items'
  ClientHeight = 587
  ClientWidth = 992
  Color = 11074992
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 16384
  Font.Height = -16
  Font.Name = 'Arial Rounded MT Bold'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 18
  object grpMain: TGroupBox
    Left = 139
    Top = 0
    Width = 853
    Height = 587
    Align = alClient
    TabOrder = 0
    object grpHeader: TGroupBox
      Left = 2
      Top = 20
      Width = 849
      Height = 129
      Margins.Top = 0
      Align = alTop
      TabOrder = 0
      ExplicitLeft = 6
      ExplicitTop = 16
      DesignSize = (
        849
        129)
      object lblCFRange: TLabel
        Left = 438
        Top = 39
        Width = 171
        Height = 18
        Caption = 'Carbon footprint from'
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lbWURange: TLabel
        Left = 464
        Top = 107
        Width = 145
        Height = 18
        Caption = 'Water usage from '
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblEURange: TLabel
        Left = 459
        Top = 66
        Width = 150
        Height = 18
        Caption = 'Energy usage from'
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblAndCF: TLabel
        Left = 670
        Top = 42
        Width = 16
        Height = 18
        Caption = 'to'
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblToEU: TLabel
        Left = 670
        Top = 66
        Width = 16
        Height = 18
        Caption = 'to'
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblToWU: TLabel
        Left = 670
        Top = 102
        Width = 16
        Height = 18
        Caption = 'to'
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object lblMinRating: TLabel
        Left = 501
        Top = 15
        Width = 129
        Height = 18
        Caption = 'Minimum rating: '
        Color = 16384
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentColor = False
        ParentFont = False
      end
      object scrbxCategories: TScrollBox
        Left = 29
        Top = 64
        Width = 368
        Height = 49
        HorzScrollBar.Tracking = True
        Color = 7987076
        ParentColor = False
        TabOrder = 0
        object flpnlCategories: TFlowPanel
          Left = 0
          Top = 0
          Width = 187
          Height = 45
          Align = alLeft
          AutoSize = True
          Color = 7987076
          Ctl3D = False
          FlowStyle = fsTopBottomLeftRight
          FullRepaint = False
          ParentBackground = False
          ParentCtl3D = False
          TabOrder = 0
        end
      end
      object srchSearchItems: TSearchBox
        Left = 29
        Top = 32
        Width = 368
        Height = 26
        Anchors = []
        Color = 7987076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnChange = srchSearchItemsChange
        OnInvokeSearch = SearchItems
      end
      object spnCFMin: TSpinEdit
        Left = 615
        Top = 34
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 2
        Value = 0
        OnChange = spnCFMinChange
      end
      object spnEUMin: TSpinEdit
        Left = 615
        Top = 56
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 3
        Value = 0
        OnChange = spnEUMinChange
      end
      object spnWUMin: TSpinEdit
        Left = 615
        Top = 90
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 4
        Value = 0
        OnChange = spnWUMinChange
      end
      object spnCFMax: TSpinEdit
        Left = 705
        Top = 38
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 5
        Value = 0
      end
      object spnEUMax: TSpinEdit
        Left = 705
        Top = 63
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 6
        Value = 0
      end
      object spnWUMax: TSpinEdit
        Left = 705
        Top = 97
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 1000
        MinValue = 0
        ParentFont = False
        TabOrder = 7
        Value = 0
      end
      object chbCFEnable: TCheckBox
        Left = 752
        Top = 38
        Width = 145
        Height = 17
        Caption = 'Enable'
        Color = 8139520
        ParentColor = False
        TabOrder = 8
        OnClick = chbCFEnableClick
      end
      object chbEUEnable: TCheckBox
        Left = 752
        Top = 69
        Width = 145
        Height = 17
        Caption = 'Enable'
        Color = 8139520
        ParentColor = False
        TabOrder = 9
        OnClick = chbEUEnableClick
      end
      object chbWUEnable: TCheckBox
        Left = 752
        Top = 108
        Width = 145
        Height = 17
        Caption = 'Enable'
        Color = 8139520
        ParentColor = False
        TabOrder = 10
        OnClick = chbWUEnableClick
      end
      object chbRatingsEnable: TCheckBox
        Left = 696
        Top = 15
        Width = 73
        Height = 17
        Caption = 'Enable'
        Color = 8139520
        ParentColor = False
        TabOrder = 11
        OnClick = chbRatingsEnableClick
      end
      object spnMinRating: TSpinEdit
        Left = 638
        Top = 5
        Width = 41
        Height = 28
        Color = 7987076
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        MaxValue = 5
        MinValue = 0
        ParentFont = False
        TabOrder = 12
        Value = 0
      end
    end
    object scrbxItems: TScrollBox
      Left = 2
      Top = 149
      Width = 849
      Height = 436
      VertScrollBar.Tracking = True
      Align = alClient
      TabOrder = 1
      object flpnlItems: TFlowPanel
        Left = 0
        Top = 0
        Width = 845
        Height = 252
        Align = alTop
        AutoSize = True
        Color = 11074992
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 0
        ExplicitLeft = 2
      end
    end
  end
  object grpSideBar: TGroupBox
    Left = 0
    Top = 0
    Width = 139
    Height = 587
    Align = alLeft
    TabOrder = 1
    object imgProfile: TImage
      Left = 30
      Top = 27
      Width = 73
      Height = 70
      Center = True
      Stretch = True
      OnClick = imgProfileClick
    end
    object grpCheckout: TGroupBox
      Left = 11
      Top = 122
      Width = 110
      Height = 144
      Color = 7987076
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      OnClick = grpCheckoutClick
      object lblCheckout: TLabel
        Left = 19
        Top = 16
        Width = 77
        Height = 18
        Caption = 'Checkout'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 16384
        Font.Height = -16
        Font.Name = 'Arial Rounded MT Bold'
        Font.Style = []
        ParentFont = False
        OnClick = grpCheckoutClick
      end
      object Image3: TImage
        Left = 27
        Top = 61
        Width = 60
        Height = 60
        Center = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000E50000
          00DD080600000044E0B5D6000000017352474200AECE1CE90000111849444154
          78DAED9D0BD4666315C7F7B834EEF76BC220258464442E8D8442189756C83597
          A1A8D545D69A62C414D26AA1A242C8A525772A259A1286C1920A4353E3965C16
          956BA5B4FFEB79BFD5E7F37DCE3EEFB9ECFD9CF7FF5B6BAFF9D69AFD7EEF3EE7
          79FFE77BCF739E67FFC709212414E3BC0B2084BC168A9290605094840483A224
          2418142521C1A02809090645494830284A4282415112120C8A92906050948404
          83A2242418142521C1A02809090645494830284A4282415112120C8A92906050
          94840483A2242418142521C1A02809090645494830284A4282415112120C8A92
          90605094840483A2242418142521C1A02809090645494830284A428241511212
          0C8A9290605094840483A2242418142521C1A02809090645494830284A428241
          5112120C8A92906050946450984FE315EF222C5094641078D5BB801E26BD5194
          6410A02809090645494830284A42824151121288F535EEF62EA2074549883245
          E30CEF227A50948428E76AECE75D440F8A921065B6C6DBBC8BE8415192816745
          8DBF7817310C8A920C3CBB6A5C66C87B466369EF6287A853948B6B1CAAF184C6
          79DE074688F2358DCF19F27EACB1A377B143D421CA752489F1108DF11A7FD638
          45D2B3A1FFF6FEB5FE1CED35DEF5906AFC46633343DE1735A67B173B4415516E
          2B498CBB7A1F4487E9C285C5EB35F86C1F2CB6CFF8D61A377A0FF610FD88F200
          49627C8F77F184D4C4421A2F791731445951DEA2B1A977D184D4C82C8D8DBD8B
          184E5951E221ECB9DE45135223A7697CCABB88E1F4F3F5F5618D95BD0B27A426
          F6D4F8A17711C3E9479453354EF02E9C909A98A0F1907711C3E9479478C8FAA4
          C63CDEC5135291B91AAB791731927E1F897C5BE330EFE209A9C8C51A7B791731
          927E4519698F1A21FD72A4C6E9DE458CA4CAE281AB353E6CCCBD46D257DE71BD
          98678C9FDFE8FF9A7A0D9607BED5781CB8F7F84F03B58DF57FA459266ADCE15D
          C448AA0CFCF692D60C5AB850E363DE073B06E807FAA2C6FC86DC0335BEDF626D
          112E60B868DD6CACF7B31AB7375C4F51DE7A1A9F34D4FA82C6222D8EA599AA57
          E33B353634E6AEA1F127EF031E839F687CC8907791C6DEDEC5B6CC648DCB8DB9
          0B6ABCEC5C2F9E0C4C35E4DDA0F101E75A47A5AA28B108FD3BC6DC93348EF63E
          E031F88CC6D70D79F80ABEBC77B12D73AAA47BAF2266686CE55DACF20B496B59
          8B8078BFE45DEC68D471DF82AD5ACB19F2FE26E903FD2FEF831E057CE5F9AD31
          77138DDBBC0B6E114CE8AD6FC89BA6719C77B192BE962E64C8DB41D237A470D4
          214A0CC431C6DC90B35D3DE66AAC6AC80BB5CDA761CAECDC9FA4F12BE77AB186
          D57AC15C4AE359E77A47A50E51BE59E33163EE1F34D6F53EE831385BD2444E11
          BFD478BF77B12D8125681719F2B0C3C2F2D7A96970D13FD590778FD8FEFABB50
          D7B4BBF5030D7613FBC4419B583F8060318DE7BC0B6E01CC171C62C8BB4E6C13
          654D83C5001F351ED714EF62C7A22E5196F9DAF0338D0F7A1FF8282C2B6922C7
          026624AFF42EB805AC9DE03081779277B162BF05D95F02B7ACA9F30135AE96DB
          1973B141FA76EF831F855B254DE414F12DB13D0BCB99D535E61873234C7E4D90
          D48AC6C2DB351E70AE774CEA146599E759E7687CDCFBE047E17849133945E02F
          C85ADEC5360C6E47CE36E461B26429EF62C57EFBF1B8A47990B0D4BD94EBF792
          1A6959788BD82788DAE27D929EB759087DB5AD81F335F631E45D2131FA3461B3
          F21119D53B26758B1227E53463EE97358EF53E01A3F077491339457C42D26E99
          AE8275BEAB18F2B06BDF3AE64D82B61E1B19F28E92D47A322C758BF24D921613
          2C61C845DE0ADE276014F0157CB2316F37EF621B626D498FAF2C6C20F685174D
          B1B0C6F3C6DC2D24B59E0C4B133B114ED4F88231175DF1BEEB7D124670B8A489
          9C22FE2169B17617B19E032C2C58C9BB58496B58AF37E46187CFF8DEBF616942
          94D8C96D5D787E97C6BBBD4FC208F00860B6317792F8AF6269824B34F630E445
          D9248CC9B9E30D79F80BB98577B14534B567EF02B1EFA640BB78EB16B0B6B85F
          D2444E116117355704CF6B9735E445F9A683CFCFF6863CDC4B1EE55D6C114D89
          1257A35F1B73B1597A67EF1331826F4A9AC82962A674AF0F2EBEB95837FE4699
          818641CF92863CCCBA5EE15D6C114DEE6EC71AD149C6DC089305C3D945EC8387
          1D324F79175C23D8A87C8A210FB7286B78172BE576F86081FD5FBD0B2EA24951
          620DE2C5C65CD85F1FEE7D3286B1A8A4891C0B7B9538CE1CB0B67989B200045F
          A1CF34E465B3E0A3E93E300F8AADFF0D8C59B0D7F269EF13320C18BE5836ED62
          D5CB41DEC5D6082E468B1AF2F6D5F88177B162B74F47DE01DEC55A685A94F006
          0CFDA096640D3EBFD645F3D81562ED92E17E504D822B2E16092CE87DA0A49360
          0DAB751336F64FDEE35DB08536DA187E43E3D3DE074A3A09565459ECD3A32C9A
          37D1862871737D9FF781924E8259628B7D3A7AF1ECE05DAC95B61AFEFE486377
          EF83259D032B743637E461814736A6546D89D2BA36919032600DEBBC863C7CFE
          6EF02ED64A9BADF1E9024DBCC02E9217BD8BB0D2A628E9024D3C08679F5E44DB
          26327481266D13CE3EBD88B645491768D236E1ECD38B685B94CB485A4C607181
          FEA3C69AAD9F91D1E9BA0110768558F6B5A233BCA5B158D36077CAFDC6DC0912
          CC3EBD080F0FC4322ED051AE725D36002AD3EF761B49063ADEEC2F364BC2B912
          D03EBD080F519671819E21319C9CBA6C00840E039718F25E91B45CF215EF82C5
          DEB91D17F43DBD8B2D8B975BF0551A3B1973B7D4B8C9A9CEE1CC956E1A00A117
          8F65DB1CFE426EE35D6C0F5C20D733E445E9B4570A2F5162C9D3B5C6DC282ED0
          67896DFF606E0640D65EBD512E36E830F08C31178F426679175C162F5182322E
          D068A16F6D49DF145D3400425F57EB240896B3596DD69B04BD782C3D9DB05860
          61EF62FBC15394B9B94077D100081DD0CF37E4E102636950DD06566B89B0F6E9
          45788A12A05F8A65B6328A0B74D70C80AC1686D7887D0EA069B2B74F2FC25B94
          B9B94077CD0008AE5AAB1BF2B03DCAF248A80DB2B74F2FC25B94E8AEFDA83137
          820B74970C80CA349D8647C79DDE052B13C56EA118D63EBD086F5182322ED011
          FA7676C500C87A4F8FF699CB7917DBA313F6E9454410656E2ED0683F61B1528B
          6EB9869964CB83756C50FF8877B13DACF6E9E8DA7EA877B1FD124194202717E8
          AE1800C11BD4629E1AE92F3E1E8B4D30E4A195E4B9DEC5F64B1451E22F8AA501
          12F06E02DC0503A0324B1DB1B0E05EEF8225ADA69A6BCCC5249B758CC2114594
          A08C0B342688ACAD059B20770320EBBD19F6BF5A9616B681B5E33E1EB3ADE85D
          6C152289322717E8DC0D80ACC6B8E880BEAF77B13D701139D29017FD5EBE9048
          A22CE302EDBD452A770320AB4B156E13CEF12EB607E611261AF2C2DBA7171149
          94201717E89C0D80305136D3980B572DAB01709360B1C00BC6DCF0F6E9454413
          255697CC31E67ABB405B0D80BC27A646828BDE89863C2C7CB0DC37B70196D559
          365767619F5E44345182322ED09E4BA9ACFD86B00B6382538DA3F153B13DEB8D
          F4ACAF53F6E945441465191768CF85D265BE06463297C196268BE152A4AFDD56
          FB74D8187CDEBBD8AA44142528E3028DDDE5B8EF795592CFE5ABA3FCFC46FF57
          E5356830BDB4A1C669928C71EB78CF2A9459BB8B85058F577CBFBAB04E4CC1F0
          E772EF62AB125594655CA0078D2AA2C65F48CBC65F6C917B44EABB7855793D26
          D5AC9D1C225D48FA26AA2881D5059A10106962AA1291454917685286F324B59E
          CC9EC8A2A40B34294336F6E945441625A00B34B1126986BB12D1454917686221
          2BFBF422A28B125C2A69AA9B90B1C8CA3EBD881C4489CDCFD77917414293957D
          7A113988727EF16F2D496213C578A816721025B67461D91D6661D10E020633F3
          F46A1F67FCD99A57E7EB9B7A4FF27A1611FB2E92F07090F323C70B493FAFC13C
          C2FE86F3016F4DCB3ECB6CA0284954ACDD11D0A0DBD291201B284A1215F460B2
          F4DA89B49BA516284A1291321D03E1D43CD7BBE03AA1284944F6135BDFD6681B
          C86B81A2241139536C5D0FB2B44F2F82A22411E9B47D7A111425894619FB746F
          0B8B46A02849343A6F9F5E044549A2D179FBF422284A120DAB7DFA74B189373B
          284A128DE7C5F6B57447B17DCDCD0E8A92440236EEB38CB968ED699D10CA0A8A
          9244C2EABCF63BB13D32C9128A9244C26AF91EC952A176284A128981B04F2F82
          A2245128639FFE0E496EDA9D84A224511818FBF422284A128581B14F2F82A224
          51B0DAA7C3F4F664EF629B84A224114053B4178DB95B6ADCE45D709350942402
          B0BABBC19007DBF405247534EC2C14258980D5AAFE668DCDBD8B6D9A2E8A725D
          8DCD7AF14E8D157A8186CE2F693C25C9F9798EA4417E4CFC8D51BD1D9EDB1E0B
          8C03D6B83E2A6943F3C61A6B1B7E5F27ECD38BE89228F140791F8DADBC0B71A2
          C98B42D9DFB5642F16A9F9183B619F5E441744B9BBA4AF3F1B7817421AA713F6
          E945E42CCAF92499841EE85D0869850725B59EEC3CB98A12F71F58FDD1D99D02
          E4759C2FA9F564E7C9519470ECBD5A6315EF4248AB9CA471B477116D909B2857
          D69829E9DE820C168F68BC57D28C6DA7C94D94D74B479B25111358C9B3A57711
          4D9393284F94B4EE910C36E876778C77114D928B28DFA571977711240C588C70
          8B77114D918B28AFD5D8A1E46B70EF7981A4C1FBAA24335274495B4AD23DE962
          257FDFB39276C67B98B1D2E1F9B55CAAB18777114D91C3606EA8716789FC7F6B
          4CD138A720EF10494D9AC697F8DD9B68DCE67D42C6A08D0B0496CD5D5DA2262C
          1CFF8AA48BEA1BBDFF4E92F652CE5FE277471E8B4AE4204A34493AD8988B75AD
          18E099C6FC4D35AED258D6987F86C6E1DE27C4118E450BE420CAA725F5F8B4B0
          8DA40EDB65D8BAC46BF0415BCEFB8438C2B16881E8A2B4EEB30355DAD81F27F6
          19BD6D253D9A193438162D115D94D3348E35E4BDA0B17CEFDF7EC06E063C945E
          DC908B0FDB74EF13E3C034E158B442745162966D37431E9C7F0FABF85E56F760
          4C74ECEC7C5E3CE058B4447451DEA7B196210F130AD7547C2F7448BBCC90778F
          A4F5B78306C7A225A28B1237F3CB18F25697F40CB10AF81D730C79F86AB5B2F3
          79F18063D112D14589B6110B18F2701FD2EF3DCC104B485A2060A96921E7F3E2
          01C7A225A28B120F9FE735E461A58EB545E15860702D1F26D454E6217757E058
          B44474513E21B6675113341EAAF85E562F8B2725CD2E0E1A1C8B96882E4AEBE4
          C2648D2B2BBED72E925AE21731DB5853D7E058B4447451A273D964431E7AF54C
          A9F85ED66978D4647934D03538162D115D9478387CBC21EF39494E4CFD4E30E0
          3E085DD21635E41E63ACA96B702C5A22BA28B7D3B8CE985B656917BA734F2D51
          D3CF9DCF8B071C8B96882E4A809B79EBCE817E1641A3BD8875FD646717411BE1
          58B4400EA22CB35D0886A2580D72AB311FDB85705FB28231FFAC12B574118E45
          0BE420CA8D346695C8FFA7C6111ADF2BC8C3809E2EE53639A396321BAEBB06C7
          A205721025B0CEFC0D079B6B2FD29821FF5FF6B59AC6248DBD24ED5C2F43E71D
          848D702C1A261751C2E1F7F60035DCE17D2202C0B168985C440930F5DDEF8C5E
          55AACC2676118E4583E4244A70A3B46F7587F7DCDAFBC003C2B16888DC44B992
          24A3D7555B7A3FACE1448FD1C7BC0F3C201C8B86C84D9400B36ED800DBB4C1CF
          C39226133A39C357131C8B06C85194003E8598055CA7A1DF7FAFA40FC16CEF03
          CD008E45CDE42A4A800DB778B67550CDBF170FA5F16CED65EF03CC088E458DE4
          2CCA21F09CEB28A9DEABE56E8D932599D192FEE058D44017443904AED27B4B7A
          205D86191A174ABA2A937AE05854A04BA21C624D498BA127F6021DBD97EC1DEB
          33BDC0C36F2C17C382E907BC0BEE301C8B3EE8A22809C91A8A92906050948404
          83A2242418142521C1A02809090645494830284A4282415112120C8A92906050
          94840483A2242418142521C1A02809090645494830284A4282415112120C8A92
          90605094840483A2242418142521C1A02809090645494830284A428241511212
          0C8A9290605094840483A2242418142521C1F81F6A56421A7621677E00000000
          49454E44AE426082}
        Stretch = True
        OnClick = grpCheckoutClick
      end
    end
    object pnlLogout: TPanel
      Left = 11
      Top = 321
      Width = 97
      Height = 41
      Color = 8380296
      ParentBackground = False
      TabOrder = 1
      object sbtnLogout: TSpeedButton
        Left = 1
        Top = 1
        Width = 95
        Height = 39
        Align = alClient
        Caption = 'Logout'
        Flat = True
        OnClick = btnLogoutClick
        ExplicitLeft = 0
      end
    end
  end
  object pnlHelp: TPanel
    Left = 916
    Top = 0
    Width = 60
    Height = 33
    BorderWidth = 1
    Color = 8118149
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
      ExplicitLeft = 26
      ExplicitTop = 0
    end
  end
end
