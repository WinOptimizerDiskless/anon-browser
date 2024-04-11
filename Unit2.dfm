object Form2: TForm2
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Change most list'
  ClientHeight = 245
  ClientWidth = 1074
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  TextHeight = 15
  object JvGradientHeaderPanel1: TJvGradientHeaderPanel
    Left = 0
    Top = 0
    Width = 1074
    Height = 30
    GradientStyle = grHorizontal
    LabelCaption = 'Put your text here ...'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWhite
    LabelFont.Height = -12
    LabelFont.Name = 'Segoe UI'
    LabelFont.Style = []
    LabelAlignment = taLeftJustify
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 160
    ExplicitTop = 200
    ExplicitWidth = 285
  end
  object JvPanel1: TJvPanel
    Left = 0
    Top = 30
    Width = 1074
    Height = 155
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 624
    object JvMemo1: TJvMemo
      Left = 1
      Top = 1
      Width = 1072
      Height = 153
      Align = alClient
      BorderStyle = bsNone
      ScrollBars = ssHorizontal
      TabOrder = 0
    end
  end
  object JvPanel2: TJvPanel
    Left = 0
    Top = 185
    Width = 1074
    Height = 56
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 624
    object SpeedButton1: TSpeedButton
      Left = 1
      Top = 14
      Width = 305
      Height = 22
      Caption = 'https://bridges.torproject.org/ '
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 768
      Top = 14
      Width = 305
      Height = 22
      Caption = 'Cancel'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton2Click
    end
    object SpeedButton3: TSpeedButton
      Left = 521
      Top = 14
      Width = 305
      Height = 22
      Caption = 'OK'
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold, fsUnderline]
      ParentFont = False
      OnClick = SpeedButton3Click
    end
    object CheckBox1: TCheckBox
      Left = 320
      Top = 19
      Width = 97
      Height = 17
      Caption = 'Use proxy'
      TabOrder = 0
    end
  end
end
