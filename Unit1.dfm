object Form1: TForm1
  Left = 0
  Top = 0
  Anchors = []
  BorderStyle = bsDialog
  Caption = 'Connect to anonymouse network'
  ClientHeight = 302
  ClientWidth = 624
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object JvNavPanelHeader1: TJvNavPanelHeader
    Left = 0
    Top = 0
    Width = 624
    Align = alTop
    Caption = 'Anonymouse settings:'
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
    Width = 624
    Height = 221
    Align = alClient
    TabOrder = 1
    object JvMemo1: TJvMemo
      Left = 96
      Top = 31
      Width = 527
      Height = 189
      Align = alRight
      Color = clNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -12
      Font.Name = '@Malgun Gothic'
      Font.Style = []
      Lines.Strings = (
        
          'obfs4 64.4.175.62:8000 8B72740D150795ACB5101AA5F95D1ACDA4FE6B3E ' +
          'cert=vduuNhJ5U/8hjZmllP6AFfXSlSZsnrimdR8Tm8DY9dxWS4n2j92fNc0qHih' +
          'UwRqwcOfIcg iat-mode=0'
        
          'obfs4 179.43.155.94:82 1062AAF68D0E645EBAF969287A63003D541D0C27 ' +
          'cert=2PS5xqoTv7JIC+XhWtXFP3B+9BJ3YaIMyjsJHW5z9AmN4R4sjkQUiYijFdm' +
          'wS4QC1Pf0HQ iat-mode=0')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      WordWrap = False
    end
    object JvGradientHeaderPanel1: TJvGradientHeaderPanel
      Left = 1
      Top = 1
      Width = 622
      Height = 30
      GradientEndColor = clDarkorange
      GradientStyle = grHorizontal
      LabelCaption = 'Enabled Most proxy?'
      LabelFont.Charset = RUSSIAN_CHARSET
      LabelFont.Color = clWhite
      LabelFont.Height = -15
      LabelFont.Name = 'System'
      LabelFont.Style = [fsBold]
      LabelAlignment = taLeftJustify
      Align = alTop
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      TabOrder = 1
      DesignSize = (
        622
        30)
      object ToggleSwitch1: TToggleSwitch
        Left = 520
        Top = 3
        Width = 84
        Height = 27
        Anchors = [akTop, akRight, akBottom]
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        FrameColor = clDarkred
        ParentColor = True
        ParentFont = False
        StyleName = 'Windows11 Polar Dark'
        TabOrder = 0
        OnClick = ToggleSwitch1Click
      end
    end
    object JvPanel3: TJvPanel
      Left = 1
      Top = 31
      Width = 95
      Height = 189
      Align = alClient
      TabOrder = 2
      object JvImage1: TJvImage
        Left = 1
        Top = 26
        Width = 93
        Height = 162
        Align = alClient
        ExplicitTop = 31
        ExplicitWidth = 64
        ExplicitHeight = 66
      end
      object JvSpeedButton1: TJvSpeedButton
        Left = 1
        Top = 1
        Width = 93
        Height = 25
        Align = alTop
        Caption = 'Change'
        OnClick = JvSpeedButton1Click
        ExplicitLeft = 8
        ExplicitTop = 24
        ExplicitWidth = 25
      end
    end
  end
  object JvPanel2: TJvPanel
    Left = 0
    Top = 248
    Width = 624
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
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 3128
    Left = 72
    Top = 256
  end
end
