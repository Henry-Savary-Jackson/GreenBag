object frmCheckout: TfrmCheckout
  Left = 0
  Top = 0
  Caption = 'Checkout'
  ClientHeight = 406
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblTotalCost: TLabel
    Left = 30
    Top = 342
    Width = 53
    Height = 13
    Caption = 'Total Cost:'
  end
  object lblTotalCF: TLabel
    Left = 136
    Top = 353
    Width = 113
    Height = 13
    Caption = 'Total Carbon Footprint:'
  end
  object lblTotalEU: TLabel
    Left = 300
    Top = 337
    Width = 98
    Height = 13
    Caption = 'Total Energy Usage:'
  end
  object lblTotalWU: TLabel
    Left = 441
    Top = 342
    Width = 94
    Height = 13
    Caption = 'Total Water Usage:'
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
  object btnCheckout: TButton
    Left = 283
    Top = 373
    Width = 75
    Height = 25
    Caption = 'Check Out'
    TabOrder = 1
    OnClick = btnCheckoutClick
  end
  object scrbxItems: TScrollBox
    Left = 8
    Top = 56
    Width = 609
    Height = 258
    TabOrder = 2
    object flpnlItems: TFlowPanel
      Left = 3
      Top = 0
      Width = 583
      Height = 139
      AutoSize = True
      TabOrder = 0
      object grpItem: TGroupBox
        AlignWithMargins = True
        Left = 6
        Top = 4
        Width = 571
        Height = 129
        Margins.Left = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alTop
        TabOrder = 0
        object lblQuantity: TLabel
          Left = 290
          Top = 56
          Width = 46
          Height = 13
          Caption = 'Quantity:'
        end
        object redItemInfo: TRichEdit
          Left = 19
          Top = 19
          Width = 201
          Height = 89
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Zoom = 100
        end
        object spnQuantity: TSpinEdit
          Left = 355
          Top = 56
          Width = 38
          Height = 22
          MaxValue = 1000
          MinValue = -1
          TabOrder = 1
          Value = 0
        end
        object grpRemoveItem: TGroupBox
          AlignWithMargins = True
          Left = 480
          Top = 25
          Width = 69
          Height = 82
          Margins.Left = 20
          Margins.Top = 10
          Margins.Right = 20
          Margins.Bottom = 20
          Align = alRight
          Color = clScrollBar
          ParentBackground = False
          ParentColor = False
          TabOrder = 2
          OnClick = imgRemoveItemClick
          object imgRemoveItem: TImage
            AlignWithMargins = True
            Left = 7
            Top = 15
            Width = 55
            Height = 60
            Margins.Left = 5
            Margins.Top = 0
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alClient
            Center = True
            Picture.Data = {
              0954506E67496D61676589504E470D0A1A0A0000000D49484452000000E50000
              00DD080600000044E0B5D6000000017352474200AECE1CE90000118449444154
              78DAED9D0DB0245575C7CF9D7DDDFD76B734A5D1C2C28408824B5C01A352316A
              B44205E2F6EE3C8944224602422081801051884422060242C488124820224412
              8828BAFBD85D03292CBF4D115454128906159592D2848AD6EEBE9979CCCD39D3
              6797E961DFBE8FF938B76FFF7F5553FD1ADECE9EBEF7FEFEE7F66EEF3C470080
              A070D6050000CA404A00020352021018901280C08094000406A4042030202500
              81012901080C48094060404A00020352021018901280C08094000406A4042030
              20250081012901080C48094060404A00020352021018901280C08094000406A4
              04203020250081012901080C48094060404A00020352021018901280C0809400
              0406A404203020250081012901080C48094060404A00020352021018901280C0
              8094000406A404203020250081012901080C48094060404A0002035202101890
              1280C08094A0F2F8247931351A3FEF5AADBBAC6B1905D148E9B36C034FCA76EB
              3AC06461218F20E7B6F197FBF1B119C31A88424A16F218F25E26E64ED76E1F6B
              5D0F980C3E4D5FC00799F75FE4D7E658E63E0E2965FBE2DC16FE727F2AC46C5A
              D704C60B0BF9CB5408F91C8A6CCEA39052D06DCC2C15A9B99DDAED19BEB879EB
              BAC0E8E19DD1F37467F45C7E6D672173EB9A464934520ABA9D11319FC3AFBB54
              CC96755D6074F8E9E983A8DB1521D75131C71B630BDFA8A414745B23623E97D3
              F41EEA749A7C913BADEB02C3C342FE920AF97C9DDB3CC6D08D4E4A41B737728F
              B98EB7B49FA6564BC4FC99755D60E5F8D5AB7F811E7F5C843C4CE7348F356CA3
              9452D06D8E74CCE7F3247E8E2751B6B28F59D705968F5FBBF659DC15E5AF3A5E
              A87399C71CB2D14A29E87647C43C8C5F5FD47BCC9F58D705968E277A26A5A974
              C8975031871B630FD7A8A51474DB2362BE905FF7529234DD8E1D8F5AD7051687
              857CBA0AF9AB2473D76EE77508D5E8A51474FB23624ADA7E99A6A69A6EE7CE47
              ACEB020BC342FE9C0AF93292394B92BC2E615A0B2905DD06899892BAF753A331
              E3E6E61EB6AE0B3C199EABB59465DBC9FB5F2799ABA9A9BC4E215A1B2905DD0E
              899892BE0FB0984D16F33BD6758127E0399AE6AEB88D9CFB0D2AE628AF5B78D6
              4A4AA1B72DCAB2594DE16FEA43CCDFB6AE0BF4E62651217F93646E0A216B179A
              B59352E86D8F926456D3F85B2AE683D675D5199E9386DE43FE16157392D7352C
              6B29A5A0DBA4594DE587F835E3DAED07ACEBAA2B3E4DEFE4C34692B92884AC6D
              48D6564AA1B75D2AEE31259DE5BEA5C9627ECDBAAEBAC1426EE6C30C157390D7
              3D1C6B2DA5A0DB2679244F52FA877CAFD9749DCE57ACEBAA0B2CE41D7CF86D92
              B12F84AC7D28D65ECADDF4A5F58F58CC1916F35EEB9A6287C7FC763EFC0E1563
              9E230C0B20651F7B52DBB91F53B72B627EC9BAA658E1B1BE950FAFD7B1DE8810
              7C024839405F7A3FC68BA5E9E6E73F6F5D536CF018DFC287DF2319E3A24322FC
              FA80947B614F8A13FD54C5FC8C754DB1C0637B331F7E9F8AB1CD117A4F06522E
              405F9AEFD047F2EEB1AEA9EAF098DEC88737918C692124C26E2F40CA7DD097EA
              737CEF33E35AADBBAD6BAA2A3ECBAEE7ADEA692463D9686C44C82D0CA45C84BE
              749FD7277F3E695D53D56021AF6321FF888A31CC116EFB06522E81BE94F72AE6
              56EB9AAA824F926B78CCFE988AB1CB116A8B032997485FDA0BC7BA767BB3754D
              A1C3425ECD22BEB977E2DC2684D9D28094CBA02FF585E358CC3BAC6B0A151EAB
              AB78ACDEA2A708B1650029974929FD898EE7C576BB754DA1C1F7E157F2E16D7A
              8AF05A269072050C74811378D1DD665D5328B09097F3E14FF514A1B50220E50A
              19E80627F2E2BBC5BA266B784C2EE1C33BF41461B54220E51094BA82F727BB4E
              E766EB9A0CC7E2623EBC534F115243002987A4D41DBC3F95C5BCD1BA268331B8
              880F7FA16350EB701A0590720494BA84F7A7F3A2BCC1BAA6095EFB857CF84BBD
              F65A86D2A881942362A05B9CC98BF33AEB9A2670CDE7F3E10ABDE65A85D13881
              9423A4D4359C3BDBB55AD758D734B66BCDB2F358C4F71427F508A1490129474C
              A97B38772E8B79B5754D23BFC62C3B9745FC6BBDC6A8C3C7024839064A5DC4B9
              F378D1BED7BAA6115EDBD97C6DEFD76B8B3274AC819463A2D44D882E70EDF695
              D6350D7D4D4972068B786DEF24B2B009094839464A5D85E84216F372EB9A567C
              2D49723A8BF8777A1A45C8840AA41C33A5EE4274112FE64BAD6B5AC1359CCAD7
              F0F77A5AE970A9029072020C74998B7951BFCBBAA665D47E32D7FE213DAD64A8
              540D48392106BACDA5BCB82FB2AE69D19AD3F48D7CF8B09E562A4CAA0CA49C20
              035DE7725EE4175AD7B460AD697A021FFE494F2B1122B1002927CC40F7B99217
              FB05D635EDA5C6E3F9F0CF7A1A7478C408A434A0D485BCBFCA753A6FB5AEA9AF
              B6D7F2E1637A1A6468C40EA434A2D48DBCBF9AC53C37809A5EC3874F684D4185
              459D80948694BA92F7D7B004679BD592659BB88659AD258890A82B90D2985277
              72EE3AD76A9D39F11AB26C038BB8AD38B10D07002983A0D4A59CBB81C53C7D82
              BFF7D12AE49455288032903210B45BC90FAF9DE2D78DAEDD3E75ECBFE7F4F451
              D4ED8A90D9A4C3002C0CA40C08ED5AD231337EDDCC629E3CB6DF6B6AEA55D468
              88906B684221009606A40C0CED5E22A6C8720BCB72E2C87F8FA9A957A8904FA1
              31CB0F960FA40C10ED6222A648731B4B73C2C8DE3B495ECA5B5511F2693426E9
              C17040CA40D16E26F79822CFED2CCFF143BF67921CD9EB90DE3F83462C3B181D
              9032607A5D4D3A6621D11D2CD17143BCD78BF8B08DBBE47E3422C9C178809481
              D3EB6E44B32AD36696E9D815BCC711BA65DD9F86941B8C1F4859017A5DCE39B9
              C714A9B652BBDD74F2F31E97F26BD3743D4987243A80562835982C90B22268B7
              937B4C91EB932AE6FC3E7F4D9A1E4A859007F26B2B0BB9C9FA3AC0E240CA0AA1
              5D4F3AE6817C9F7937753A333C81737BFDDE2C3B449FD439980A89F3A5765760
              0BA4AC18DAFD44CC8359BA7B54CC1DA5EF999E3E489FD459A7F2E68B7555100E
              90B28268171431D7F196F633D46AC956F6A7BDFF373D7D800AB95EA5DDB85037
              056102292B8A7643B9C75CCF627E5EC4A4D5ABD7D0E38F8B9087ABACF9601705
              E103292B8C7645E9988753A3711F7F9DF2D787A9A4F9EEEE09AA05A4AC387EF5
              EA677377DC4E2263C17DD46E1FCD13FB98756D606540CA8AE3E531BC34BD9BBF
              7CB1FEA7AFD3AA551BDCAE5D3FB4AE0DAC0C48596158C8A75296C9B3AC2F2791
              B1D168F31656E4FC1A7FDD7473730F5BD708960FA4AC282CE45A15F2952412AE
              5A95D3AE5D3BF9BFCDAAA40FB098332CE643D6B582E501292B080B394D49B295
              9C3B8A0AF9F2DD5D51BBE7ACCAFA207F4FD3B55ADFB2AE192C1D485931BC7C5C
              4892C8BFF6389A44BA42C88706BE672D7FCF1695F6DBFC6ABA76FB9BD6B583A5
              01292B8497F94A53F97BC85793C8E65CBE5017D46EBA45E5FD0E15623E607D0D
              6071206585F0697A271F36522159BE58F7EB75D53495BFC714891FE62DED8CEB
              74EEB7BE0EB06F2065456021E5B361E53362E5DE315F6AD7D3EE2A628ACC8FB0
              984D16F3CBD6D703160652560016523E455D3E4D5DA4CA57D2EDF648EDFDA324
              5BD94EE75EEBEB027B0752060ECBF4113EBC4E65CA87E9727BE476EE27D4ED8A
              985FB2BE3EF0642065C0B044B7F2E1F52A513E8AEEB64772790CAFDB9D71F3F3
              9FB3BE4E500652060ACB233FC3527E96E563BA651D5957DB233BD1CF7A1D737E
              FED3D6D70B9E005206084B73131F4EA2429A7C1CDDAC4FFA9DFA48DE3DD6D70D
              0A206560B02C1FE4C32924B214428EAD8BF5C9DFD2277FEEB6BE7E002983C267
              D9F5BC553D8D4492E2499DB177AFBE109867316758CCEDD6E35077206520B090
              D7B290675021473EC9AED51706A41DF34EEBF1A8339032007C927C806538AB77
              520839F16ED5170AC2B1AEDDDE6C3D2E7505521AC342BE8F453CA77762DCA54A
              E140741C8B7987F5F8D4114869084BF01E96E03C3D0DA23B954282E877B9A68F
              58D7543720A5113E4DAFE0C3F97A1A54571A088B37706DB75AD7542720A5012C
              E4657C78BB9E06D98D0642E344AEF116EB9AEA02A49C30BCD82FE1C33BF434E8
              2E540A0FEFDFE43A9D9BAC6BAA03907282F0227F271F2ED6D34A749F528878FF
              072CE607AD6B8A1D4839217871CBC2BEA438A956D7298589F77FC8B55F6F5D53
              CC40CA09C08B5AB680971527D5EC3603A172265FC375D635C50AA41C33BC98E5
              0F4BAE284EAADD654AE1E2DC9B5DABF501EB9A6204528E119F656F6111AF2A4E
              E2E82EA59071EE4F58CCF759D7141B90724CB090E7B088C5828DACAB94C2C6B9
              B7F2B55D655D534C40CA31C08BF62C5EB4858491769352E8105DE0DAED2BAD6B
              8A054839627C929CC1225EDB3B89BC8B94C287E8CF58CCCBAC6B8A0148394258
              C8D358C4DD7F90538BEE510A21A23FE76BBEC4BAA6AA032947042FCE537871EE
              FEAB8E5A758D81307A175FFBC5D635551948390278519EC48BF2263DAD65B718
              08A54B790C2EB2AEA9AA40CA21F1692A1F3EF5613DAD75971808A777F358BC7D
              98F7AB2B9072085848F998C6DD0F94A33BD09342EAAF784CCE1FE6FDEA08A45C
              21BCF8E4038D77FF932B74853E4A61E5FD7B5DA773DE70EF582F20E50AE04527
              3FD7E3637A8A6EB0174AA1E5FDFB59CC73867BC7FA002997092F36F9C9579F28
              4ED005F64529BCBCFF1B1EABB3867BC77A00299781CFB28DBCB88A0FB642FA2F
              89528839F7B7AED53A63B8778C1F48B94458C857B388F253941D527F796898C9
              CFC8742CE60D2CE6E9D635850CA45C02BCA88E5621A790F62B43434DC49CE2D7
              87F83EFC14EB9A4205522E829F9E3E8ABADDADFCE534527E3834DCB6908C25D1
              3FB0982759D7142290721FF8A9A95752A3211D722D21DD4782869C882963FA8F
              3CA66FB4AE293420E502B0902F57219F4A48F591A261275B5919DBDB786C4FB0
              AE292420E55EF049F252DEAA8A904F23A4F958D0D01331658C3FCA63FC3AEB9A
              4201520EC0421EC98B652BDFFB3C9390E263A5177E8DC6161DEB8FF358BFD6BA
              A61080947DF022F915ED90CF22A4F744E885A073728F2963BE85C7FC35D63559
              0329159FA687F341847C3621B5278A86A16C6565ECB752BB3DC30BB36B5D9715
              90927A42AEA742C80308696D8286A2882973F02F2C66931767C7BA2E0B6A2FA5
              CFB275FA60C041FCDACA426EB2AEA9AE6838CA56F6209E937FA54E47C49CB3AE
              6BD2D45A4A16F26015F2102AD239AFF3B629043424A5631EC2C74FA9983BACEB
              9A24B595D24F4F1F48DDAE0879A8A6725ED7ED526868588A9887F2BDE667A9D5
              1231FFCFBAAE49514B2959C80354C8F59AC6791DB74921A3A12962CA96F60B7A
              8FF9BFD6754D82DA49E9D7ACD99FE6E745C823348537D46D7B5415343CE51EF3
              087EFD9B8AF963EBBAC64DADA4F46BD7EEC75D51847C1115E99BD7695B544534
              44A563CA9CFD3B2549D3EDD8F123EBBAC6496DA4F444CFA03415218FA42275F3
              BA6C87AA8E86A9882973F7555AB5AAE976EDFA81755DE3A216527A79BE324DE5
              9F5FFD1A49DA164246BF0D8A090D55D9CACA1C7E9D1A8DA69B9BFB9E755DE320
              7A2979329F4259B68DBC7F0549CA26C986D8B73FB1D20BD72CDBA273F91F2AE6
              43D6758D9AA8A5E4495CA342BE8A245D57ADCA63DEF6D4010DD9599DD307C9B9
              19D76AFD97755DA3245A2979F232EE8ADB78D28EA22255F358B73B75A317B649
              32AB73FBDFFC6ABA76FB3FADEB1A15514AE9E573608A7BC86348D2B41032BA6D
              4E9DE9856E718F2973FC5D2AC4FC86755DA3204E298B3F65DD4092A2CEE5B16D
              6F408186AF882973FD7DDED2365DA773BF755DC3129D942CA4FCD1B93C54FE5D
              7EE5316D6BC0DEE99BF34758CC1916F33EEB9A86212A297972E4437FE59F5D7D
              9F0A21A3D8CE80C5D1B9DFA43BA3BBACEB198668A4F459B6411F627E948F790C
              DB18B03C640DB090DBADEB189668A41478528EA16EF77FAABE7D01F5262A2901
              880148094060404A00020352021018901280C08094000406A404203020250081
              012901080C48094060404A00020352021018901280C08094000406A404203020
              250081012901080C48094060404A00020352021018901280C08094000406A404
              203020250081012901080C48094060404A00020352021018901280C080940004
              06A404203020250081012901080C48094060404A00020352021018901280C080
              94000406A404203020250081012901080C48094060404A00020352021018FF0F
              B0D6A53846F497540000000049454E44AE426082}
            OnClick = imgRemoveItemClick
            ExplicitLeft = 9
            ExplicitTop = 17
            ExplicitWidth = 43
            ExplicitHeight = 35
          end
        end
      end
    end
  end
end
