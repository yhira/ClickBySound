program ClickBySound;



uses
  Forms,
  Windows,
  Dialogs,
  Main in 'Main.pas' {MainForm},
  Option in 'Option.pas' {SettingDlg},
  Compact in 'Compact.pas' {CompactForm},
  Owner in 'Owner.pas' {OwnerForm};

{$R *.res}

const
 MutexName = 'EX_Mutex_cbs';
var
 hMutex: THANDLE;

begin
  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MutexName);
  if hMutex <> 0 then begin
    CloseHandle(hMutex);
    MessageDlg('二重起動できません。', mtInformation, [mbOK], 0);
    Exit;
  end;
  CreateMutex(nil, False, MutexName);
  
  Application.Initialize;
  Application.Title := 'ClickBySound';
  Application.CreateForm(TOwnerForm, OwnerForm);
  Application.CreateForm(TCompactForm, CompactForm);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
