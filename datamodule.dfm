object dmConexao: TdmConexao
  OldCreateOrder = False
  Height = 700
  Width = 921
  object conn: TFDConnection
    Params.Strings = (
      'Database=ercsystem'
      'User_Name=root'
      'DriverID=MySQL')
    Connected = True
    Left = 40
    Top = 32
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\Users\edson\Desktop\sweepstakes\Win32\Debug\libmySQL.dll'
    Left = 128
    Top = 32
  end
  object fdtLogin: TFDTransaction
    Connection = conn
    Left = 96
    Top = 96
  end
  object fdQrLogin: TFDQuery
    Connection = conn
    Transaction = fdtLogin
    SQL.Strings = (
      'SELECT * FROM login WHERE usuario = :u AND  senha = :s')
    Left = 40
    Top = 96
    ParamData = <
      item
        Name = 'U'
        ParamType = ptInput
      end
      item
        Name = 'S'
        ParamType = ptInput
      end>
  end
  object query: TFDQuery
    Connection = conn
    Left = 40
    Top = 168
  end
  object logs: TFDQuery
    Connection = conn
    SQL.Strings = (
      
        'INSERT INTO logs (usuario_id, descricao, origem)VALUES(:uid, :de' +
        'scc, :orig)')
    Left = 160
    Top = 96
    ParamData = <
      item
        Name = 'UID'
        ParamType = ptInput
      end
      item
        Name = 'DESCC'
        ParamType = ptInput
      end
      item
        Name = 'ORIG'
        ParamType = ptInput
      end>
  end
  object carrega_premios_cb: TFDQuery
    Connection = conn
    SQL.Strings = (
      'SELECT * FROM premio ORDER BY id DESC LIMIT 8')
    Left = 40
    Top = 232
  end
  object query1: TFDQuery
    Connection = conn
    Left = 88
    Top = 168
  end
end
