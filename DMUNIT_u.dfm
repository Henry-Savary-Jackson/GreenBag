object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 459
  Width = 650
  object restCLient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'https://localhost:8080/u/user/profileImage'
    Params = <>
    Left = 480
    Top = 112
  end
  object restRequest: TRESTRequest
    Client = restCLient
    Params = <>
    Response = restResponse
    SynchronizedEvents = False
    Left = 472
    Top = 192
  end
  object restResponse: TRESTResponse
    ContentType = 'image/png'
    Left = 464
    Top = 256
  end
end
