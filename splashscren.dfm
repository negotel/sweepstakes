object fSplashScreen: TfSplashScreen
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 135
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ga_progress: TGauge
    Left = 32
    Top = 48
    Width = 617
    Height = 36
    Progress = 0
  end
  object Label1: TLabel
    Left = 40
    Top = 104
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object StartupTimer: TTimer
    Left = 128
    Top = 88
  end
end
