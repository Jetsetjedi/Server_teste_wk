object SM: TSM
  OldCreateOrder = False
  Height = 283
  Width = 515
  object FDConnPG: TFDConnection
    ConnectionName = 'ConnPG'
    Params.Strings = (
      'Database=jf-teste-tecnico-wk'
      'User_Name=postgres'
      'Password=1401'
      'Server=127.0.0.1'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction1
    Left = 272
    Top = 16
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\projetos\Teste_Wk\Win64\Debug\bin\libpq.dll'
    Left = 264
    Top = 136
  end
  object FDTransaction1: TFDTransaction
    Connection = FDConnPG
    Left = 272
    Top = 72
  end
  object FDTPessoa: TFDTable
    Active = True
    CachedUpdates = True
    IndexFieldNames = 'idpessoa'
    DetailFields = 'idpessoa'
    Connection = FDConnPG
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction1
    UpdateOptions.UpdateTableName = 'pessoa'
    UpdateObject = FDUpdateSQL1
    TableName = 'pessoa'
    Left = 192
    Top = 16
    object FDTPessoaidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
    end
    object FDTPessoadsdocumento: TWideStringField
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
      FixedChar = True
    end
    object FDTPessoanmprimeiro: TWideStringField
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      FixedChar = True
      Size = 100
    end
    object FDTPessoanmsegundo: TWideStringField
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      FixedChar = True
      Size = 100
    end
    object FDTPessoadtregistro: TDateField
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
    object FDTPessoapflnatureza: TLargeintField
      FieldName = 'pflnatureza'
      Origin = 'pflnatureza'
    end
  end
  object FDTEndereco: TFDTable
    CachedUpdates = True
    IndexFieldNames = 'idendereco'
    Connection = FDConnPG
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction1
    UpdateOptions.UpdateTableName = 'endereco'
    TableName = 'endereco'
    Left = 176
    Top = 96
    object FDTEnderecoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
    end
    object FDTEnderecoidpessoa: TLargeintField
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
    end
    object FDTEnderecodscep: TWideStringField
      FieldName = 'dscep'
      Origin = 'dscep'
      FixedChar = True
      Size = 15
    end
  end
  object FDTEndereco_integracao: TFDTable
    CachedUpdates = True
    IndexFieldNames = 'idendereco'
    Connection = FDConnPG
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction1
    UpdateOptions.UpdateTableName = 'endereco_integracao'
    TableName = 'endereco_integracao'
    Left = 152
    Top = 160
    object FDTEndereco_integracaoidendereco: TLargeintField
      FieldName = 'idendereco'
      Origin = 'idendereco'
    end
    object FDTEndereco_integracaodsuf: TWideStringField
      FieldName = 'dsuf'
      Origin = 'dsuf'
      FixedChar = True
      Size = 50
    end
    object FDTEndereco_integracaonmcidade: TWideStringField
      FieldName = 'nmcidade'
      Origin = 'nmcidade'
      FixedChar = True
      Size = 100
    end
    object FDTEndereco_integracaonmbairro: TWideStringField
      FieldName = 'nmbairro'
      Origin = 'nmbairro'
      FixedChar = True
      Size = 50
    end
    object FDTEndereco_integracaonmlougradouro: TWideStringField
      FieldName = 'nmlougradouro'
      Origin = 'nmlougradouro'
      FixedChar = True
      Size = 100
    end
    object FDTEndereco_integracaodscomplemento: TWideStringField
      FieldName = 'dscomplemento'
      Origin = 'dscomplemento'
      FixedChar = True
      Size = 100
    end
    object FDTEndereco_integracaornumero: TLargeintField
      FieldName = 'rnumero'
      Origin = 'rnumero'
    end
  end
  object DataSetProvider1: TDataSetProvider
    DataSet = FDTPessoa
    Options = [poFetchDetailsOnDemand, poCascadeDeletes, poCascadeUpdates, poAllowMultiRecordUpdates, poAutoRefresh, poAllowCommandText, poUseQuoteChar]
    Left = 88
    Top = 8
  end
  object FDMemTable1: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    Left = 368
    Top = 24
  end
  object FDQaux: TFDQuery
    CachedUpdates = True
    Connection = FDConnPG
    UpdateTransaction = FDTransaction1
    SQL.Strings = (
      
        'SELECT  pessoa.idpessoa as id, dscep, dsdocumento,nmcidade,dsuf,' +
        ' nmcidade, nmbairro, '
      #9'   nmlougradouro, dscomplemento, rnumero , nmprimeiro, '
      #9'   nmsegundo, dtregistro, pflnatureza'
      #9'FROM public.pessoa, public.endereco,public.endereco_integracao'
      #9'where dsdocumento = :DOC;')
    Left = 368
    Top = 80
    ParamData = <
      item
        Name = 'DOC'
        DataType = ftString
        FDDataType = dtByteString
        ParamType = ptInput
        Value = '252544'
      end>
  end
  object FDPhysODBCDriverLink1: TFDPhysODBCDriverLink
    Left = 400
    Top = 160
  end
  object FDUpdateSQL1: TFDUpdateSQL
    Connection = FDConnPG
    ConnectionName = 'ConnPG'
    Left = 256
    Top = 216
  end
  object IdThreadComponent1: TIdThreadComponent
    Active = False
    Loop = False
    Priority = tpNormal
    StopMode = smTerminate
    Left = 360
    Top = 216
  end
end
