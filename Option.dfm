object SettingDlg: TSettingDlg
  Left = 423
  Top = 229
  BorderStyle = bsDialog
  Caption = 'Setting'
  ClientHeight = 362
  ClientWidth = 313
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poDesktopCenter
  DesignSize = (
    313
    362)
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 8
    Top = 16
    Width = 297
    Height = 305
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 113
    Height = 12
    Caption = 'Reactive volume level'
  end
  object Label2: TLabel
    Left = 24
    Top = 72
    Width = 99
    Height = 12
    Caption = 'Double-click speed'
  end
  object Label3: TLabel
    Left = 24
    Top = 120
    Width = 221
    Height = 12
    Caption = 'Time to keep emitting sound for right-click'
  end
  object Label4: TLabel
    Left = 72
    Top = 48
    Width = 40
    Height = 12
    Caption = '(1 - 20)'
  end
  object Label5: TLabel
    Left = 88
    Top = 96
    Width = 83
    Height = 12
    Caption = '(500 - 1000 ms)'
  end
  object Label6: TLabel
    Left = 88
    Top = 144
    Width = 89
    Height = 12
    Caption = '(500 - 10000 ms)'
  end
  object OKBtn: TButton
    Left = 79
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 159
    Top = 328
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object SensitivitySpinEdit: TSpinEdit
    Left = 24
    Top = 40
    Width = 41
    Height = 21
    MaxValue = 20
    MinValue = 1
    TabOrder = 2
    Value = 2
  end
  object DblClkSpeedSpinEdit: TSpinEdit
    Left = 24
    Top = 88
    Width = 57
    Height = 21
    Increment = 10
    MaxValue = 1000
    MinValue = 500
    TabOrder = 3
    Value = 500
  end
  object RightClkTimeSpinEdit: TSpinEdit
    Left = 24
    Top = 136
    Width = 57
    Height = 21
    Increment = 10
    MaxValue = 10000
    MinValue = 500
    TabOrder = 4
    Value = 500
  end
  object IsSoundCheckBox: TCheckBox
    Left = 24
    Top = 176
    Width = 153
    Height = 17
    Caption = 'sound effect on'
    TabOrder = 5
  end
  object RecognitionGroupBox: TGroupBox
    Left = 16
    Top = 208
    Width = 281
    Height = 105
    Caption = 'Speech recognition'
    TabOrder = 6
    object Label7: TLabel
      Left = 8
      Top = 72
      Width = 177
      Height = 25
      AutoSize = False
      Caption = '*It may be necessary to adjust the volume of your speaker.'
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object Label8: TLabel
      Left = 192
      Top = 80
      Width = 85
      Height = 12
      Caption = '*It needs reboot.'
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
    end
    object IsRecognitionCheckBox: TCheckBox
      Left = 16
      Top = 24
      Width = 185
      Height = 17
      Caption = 'Speech recognition'
      TabOrder = 0
    end
    object IsRecognitionButton: TButton
      Left = 192
      Top = 16
      Width = 81
      Height = 25
      Caption = 'Settings'
      TabOrder = 1
      OnClick = IsRecognitionButtonClick
    end
    object IsVoiceInfoCheckBox: TCheckBox
      Left = 16
      Top = 56
      Width = 129
      Height = 17
      Caption = 'Voice info'
      TabOrder = 2
    end
    object EditCmdButton: TButton
      Left = 192
      Top = 52
      Width = 83
      Height = 25
      Caption = 'Edit command'
      TabOrder = 3
      OnClick = EditCmdButtonClick
    end
  end
end
