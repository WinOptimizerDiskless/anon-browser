object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Form3'
  ClientHeight = 185
  ClientWidth = 651
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnCreate = FormCreate
  TextHeight = 15
  object JvNavPanelHeader1: TJvNavPanelHeader
    Left = 0
    Top = 0
    Width = 651
    Align = alTop
    Caption = 'VPN GUARD CONNECT:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Arial Black'
    Font.Style = [fsBold]
    ParentFont = False
    ColorFrom = clDarkorange
    ColorTo = clBlack
    ImageIndex = 0
    ParentStyleManager = False
  end
  object JvPanel1: TJvPanel
    Left = 0
    Top = 27
    Width = 651
    Height = 104
    Align = alClient
    TabOrder = 1
    object JvPanel3: TJvPanel
      Left = 1
      Top = 1
      Width = 649
      Height = 102
      Align = alClient
      TabOrder = 0
      object JvImage1: TJvImage
        Left = 1
        Top = 1
        Width = 647
        Height = 100
        Align = alClient
        ExplicitTop = 31
        ExplicitWidth = 64
        ExplicitHeight = 66
      end
    end
  end
  object JvPanel2: TJvPanel
    Left = 0
    Top = 131
    Width = 651
    Height = 54
    Align = alBottom
    TabOrder = 2
    object JvSpeedButton2: TJvSpeedButton
      Left = 472
      Top = 6
      Width = 136
      Height = 25
      Caption = 'Close'
      OnClick = JvSpeedButton2Click
    end
    object JvSpeedButton3: TJvSpeedButton
      Left = 320
      Top = 6
      Width = 129
      Height = 25
      Caption = 'Connect'
      OnClick = JvSpeedButton3Click
    end
  end
end
