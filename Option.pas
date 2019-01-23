unit Option;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Spin;

type
  TSettingDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    SensitivitySpinEdit: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    DblClkSpeedSpinEdit: TSpinEdit;
    RightClkTimeSpinEdit: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    IsSoundCheckBox: TCheckBox;
    IsRecognitionCheckBox: TCheckBox;
    IsRecognitionButton: TButton;
    RecognitionGroupBox: TGroupBox;
    IsVoiceInfoCheckBox: TCheckBox;
    EditCmdButton: TButton;
    Label7: TLabel;
    Label8: TLabel;
    IsKeepRightCheckBox: TCheckBox;
    procedure IsRecognitionButtonClick(Sender: TObject);
    procedure EditCmdButtonClick(Sender: TObject);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
  end;

var
  SettingDlg: TSettingDlg;

implementation

{$R *.dfm}

uses Main, ShellApi;

{ TSettingDlg }


procedure TSettingDlg.IsRecognitionButtonClick(Sender: TObject);
begin
  MainForm.InvokeUI('RecoProfileProperties', 'User Settings');
end;

procedure TSettingDlg.EditCmdButtonClick(Sender: TObject);
begin
  MainForm.MakeSetCmdFile;
  ShellExecute(Application.Handle,
    'open',
    PChar(SET_CMD_FILE),
    nil, nil, SW_NORMAL);
end;

end.
