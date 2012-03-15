object Form1: TForm1
  Left = 441
  Top = 142
  Width = 414
  Height = 234
  Caption = 'ClickOnSound'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 406
    Height = 12
    Align = alTop
    Caption = 
      'Please emit the sound. When you emit the sound, the screen is cl' +
      'icked. '
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 163
    Width = 406
    Height = 17
    Align = alBottom
    Max = 30
    TabOrder = 0
  end
  object ListView1: TListView
    Left = 0
    Top = 12
    Width = 406
    Height = 151
    Align = alClient
    Columns = <
      item
        Caption = 'Action'
        Width = 95
      end
      item
        Caption = 'Handle'
        Width = 80
      end
      item
        Caption = 'Class'
        Width = 60
      end
      item
        Caption = 'Caption'
        Width = 70
      end
      item
        Caption = 'Point'
        Width = 80
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object SpSharedRecoContext1: TSpSharedRecoContext
    AutoConnect = True
    ConnectKind = ckRunningOrNew
    OnAudioLevel = SpSharedRecoContext1AudioLevel
    Left = 96
    Top = 80
  end
  object THTaskTrayIcon1: TTHTaskTrayIcon
    Left = 152
    Top = 144
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 64
    object File1: TMenuItem
      Caption = '&File'
      object Close1: TMenuItem
        Caption = '&Close'
        OnClick = Close1Click
      end
    end
    object Option1: TMenuItem
      Caption = '&Option'
      object Setting1: TMenuItem
        Caption = '&Setting'
      end
    end
  end
end
