object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 459
  Width = 650
  object Connection: TADOConnection
    Left = 288
    Top = 96
  end
  object Query: TADOQuery
    Parameters = <>
    Left = 160
    Top = 32
  end
  object UserTB: TADOTable
    Left = 48
    Top = 192
  end
  object ItemTB: TADOTable
    Left = 65496
    Top = 256
  end
  object StatsTB: TADOTable
    Left = 224
    Top = 208
  end
  object TransactionItemTB: TADOTable
    Left = 232
    Top = 280
  end
  object TransactionTB: TADOTable
    Left = 120
    Top = 344
  end
  object SellerTB: TADOTable
    Left = 48
    Top = 128
  end
  object dsUserTB: TDataSource
    Left = 416
    Top = 208
  end
  object dsSellerTB: TDataSource
    Left = 416
    Top = 304
  end
  object dsItemTB: TDataSource
    Left = 472
    Top = 280
  end
  object dsTransactionTB: TDataSource
    Left = 480
    Top = 192
  end
  object dsStatsTB: TDataSource
    Left = 488
    Top = 128
  end
  object dsTransactionItemTB: TDataSource
    Left = 496
    Top = 360
  end
  object RatingsTB: TADOTable
    Left = 312
    Top = 216
  end
  object dsRatingsTB: TDataSource
    Left = 408
    Top = 48
  end
  object ShoppingCartTB: TADOTable
    Left = 312
    Top = 336
  end
  object dsShoppingCartTB: TDataSource
    Left = 392
    Top = 136
  end
  object ShoppingCartItemsTB: TADOTable
    Left = 152
    Top = 120
  end
  object dsShoppingCartItemsTB: TDataSource
    Left = 328
    Top = 40
  end
end
