object Form4: TForm4
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'RAM DISK CACHE AND TMP BROWSER'
  ClientHeight = 282
  ClientWidth = 592
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
  object JvPanel1: TJvPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 282
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 360
      Top = 59
      Width = 3
      Height = 15
    end
    object Label2: TLabel
      Left = 360
      Top = 99
      Width = 34
      Height = 15
      Caption = 'Label1'
    end
    object Label3: TLabel
      Left = 488
      Top = 59
      Width = 40
      Height = 15
      Caption = 'FOUND'
    end
    object JvPanel2: TJvPanel
      Left = 1
      Top = 1
      Width = 590
      Height = 41
      Align = alTop
      TabOrder = 0
      object JvNavPanelHeader1: TJvNavPanelHeader
        Left = 1
        Top = 1
        Width = 588
        Align = alTop
        Caption = 'CREATE OPTIONS RAM DISK:'
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
    end
    object JvPanel3: TJvPanel
      Left = 1
      Top = 240
      Width = 590
      Height = 41
      Align = alBottom
      TabOrder = 1
      object Button1: TButton
        Left = 428
        Top = 8
        Width = 153
        Height = 25
        Caption = 'Close'
        TabOrder = 0
        OnClick = Button2Click
      end
      object Button2: TButton
        Left = 269
        Top = 8
        Width = 153
        Height = 25
        TabOrder = 1
        OnClick = Button1Click
      end
    end
    object JvComboBox1: TJvComboBox
      Left = 16
      Top = 56
      Width = 193
      Height = 23
      Style = csDropDownList
      TabOrder = 2
      Text = ''
      Items.Strings = (
        '32 MB'
        '64 MB'
        '128 MB'
        '256 MB'
        '512 MB'
        '1024 MB ( 1 GB )'
        '2048 MB ( 2 GB )'
        '4096 MB ( 3 GB )')
    end
    object JvComboBox2: TJvComboBox
      Left = 16
      Top = 99
      Width = 193
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      Text = ''
      OnDropDown = JvComboBox2DropDown
      OnSelect = JvComboBox2Select
    end
  end
end
