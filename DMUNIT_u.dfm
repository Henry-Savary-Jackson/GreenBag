object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 459
  Width = 650
  object Connection: TADOConnection
    Left = 64
    Top = 48
  end
  object Query: TADOQuery
    Parameters = <>
    Left = 160
    Top = 32
  end
  object ItemTB: TADOTable
    Left = 65496
    Top = 256
  end
  object SellerTB: TADOTable
    Left = 48
    Top = 128
  end
  object dsSellerTB: TDataSource
    Left = 64
    Top = 208
  end
end
