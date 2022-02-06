object fCadastraPremio: TfCadastraPremio
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Cadastra Premio  SweepStakes  :: by ecosta -- V2.0'
  ClientHeight = 137
  ClientWidth = 613
  Color = 16744448
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 29
    Width = 100
    Height = 13
    Caption = 'Descri'#231#227'o do Premio:'
  end
  object Label2: TLabel
    Left = 223
    Top = 29
    Width = 125
    Height = 13
    Caption = 'Responsavel pelo Sorteio:'
  end
  object Label3: TLabel
    Left = 447
    Top = 29
    Width = 79
    Height = 13
    Caption = 'Data do Sorteio:'
  end
  object SpeedButton1: TSpeedButton
    Left = 24
    Top = 88
    Width = 145
    Height = 33
    Caption = '+ Cadastrar'
    OnClick = SpeedButton1Click
  end
  object txtDescricao: TEdit
    Left = 24
    Top = 48
    Width = 193
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object txtResponsavel: TEdit
    Left = 223
    Top = 48
    Width = 218
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object txtDataSorteio: TMaskEdit
    Left = 447
    Top = 48
    Width = 150
    Height = 27
    EditMask = '!99/99/0000;1;_'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    MaxLength = 10
    ParentFont = False
    TabOrder = 2
    Text = '  /  /    '
  end
end
