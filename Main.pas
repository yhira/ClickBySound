unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleServer, SpeechLib_TLB, ComCtrls, ExtCtrls
  ,Dbg, Menus, ExtIniFile, ActnList, Option, ShellApi, ToolWin, ImgList,
  XPMan, MMSystem, AppEvnts, ActiveX;

const VERSION = '0.01.09';

type
  TOption = class
  private
    FRightClkTime: Cardinal;
    FSensitivity: Integer;
    FDblClkSpeed: Cardinal;
    FIsSound: Boolean;
    FIsRecognition: Boolean;
    FIsVoiceInfo: Boolean;
    FIsKeepRight: Boolean;
    procedure SetIsKeepRight(const Value: Boolean);
  public
    constructor Create;
    procedure Read;   
    procedure Write;
    property Sensitivity: Integer read FSensitivity write FSensitivity;
    property DblClkSpeed: Cardinal read FDblClkSpeed write FDblClkSpeed;
    property RightClkTime: Cardinal read FRightClkTime write FRightClkTime;
    property IsSound: Boolean read FIsSound write FIsSound;
    property IsRecognition: Boolean read FIsRecognition write FIsRecognition;
    property IsVoiceInfo: Boolean read FIsVoiceInfo write FIsVoiceInfo;
    property IsKeepRight: Boolean read FIsKeepRight write SetIsKeepRight;
  end;


  TMainForm = class(TForm)
    SpSharedRecoContext1: TSpSharedRecoContext;
    ProgressBar1: TProgressBar;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Option1: TMenuItem;
    Setting1: TMenuItem;
    ExtIniFile1: TExtIniFile;
    ActionList1: TActionList;
    SettingAction: TAction;
    Help1: TMenuItem;
    AboutAction: TAction;
    AboutAction1: TMenuItem;
    HelpAction: TAction;
    HelpAction1: TMenuItem;
    Display1: TMenuItem;
    TopMostAction: TAction;
    Stayontop1: TMenuItem;
    PauseAction: TAction;
    ImageList1: TImageList;
    ImageList2: TImageList;
    LargeToolBar: TToolBar;
    PauseToolButton: TToolButton;
    Pause1: TMenuItem;
    N1: TMenuItem;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    XPManifest1: TXPManifest;
    StatusBar1: TStatusBar;
    ClearListAction: TAction;
    PopupMenu1: TPopupMenu;
    Clearlist1: TMenuItem;
    WebsiteAction: TAction;
    Website1: TMenuItem;
    N2: TMenuItem;
    RightClickAction: TAction;
    RightClickToolButton: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    CompactAction: TAction;
    CompactMode1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    RcgLogMemo: TMemo;
    SpVoice1: TSpVoice;
    Timer1: TTimer;
    Splitter1: TSplitter;
    procedure SpSharedRecoContext1AudioLevel(ASender: TObject;
      StreamNumber: Integer; StreamPosition: OleVariant;
      AudioLevel: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Close1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure SettingActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure HelpActionExecute(Sender: TObject);
    procedure TopMostActionExecute(Sender: TObject);
    procedure PauseActionExecute(Sender: TObject);
    procedure ClearListActionExecute(Sender: TObject);
    procedure WebsiteActionExecute(Sender: TObject);
    procedure RightClickActionExecute(Sender: TObject);
    procedure CompactActionExecute(Sender: TObject);
    procedure ApplicationEvents1Deactivate(Sender: TObject);
    procedure SpSharedRecoContext1Recognition(ASender: TObject;
      StreamNumber: Integer; StreamPosition: OleVariant;
      RecognitionType: TOleEnum; const Result: ISpeechRecoResult);
    procedure SpSharedRecoContext1Hypothesis(ASender: TObject;
      StreamNumber: Integer; StreamPosition: OleVariant;
      const Result: ISpeechRecoResult);
  private
    { Private 宣言 }
    cp, gp: TPoint;
    SRGrammar: ISpeechRecoGrammar;
    IsMouseDown, IsDblStart, IsRightStart,
    IsPushSysBtn, IsPopupModal: Boolean; //IsDragStart,
    DblStartTime, RightStartTime, DragStartTime: Cardinal;
    FIsTopMost: Boolean;
    DefPauseBtnWndProc: TWndMethod;
    DefRightClickBtnWndProc: TWndMethod;
    FIsRightClick: Boolean;
    FIsCompact: Boolean;
    FIsRecognition: Boolean;
    procedure AddLog(h: HWND; cap, msg: string; p: TPoint; vol: Integer);
    procedure SetIsTopMost(const Value: Boolean);
    procedure SetIsPause(const Value: Boolean);
    procedure OpenWeb(Url: string);
    procedure PauseProc(var Message: TMessage);  
    procedure RightClickProc(var Message: TMessage);
    procedure SetIsRightClick(const Value: Boolean);
    procedure MouseLeftDown;
    procedure MouseLeftUp;    
    procedure MouseRightDown;
    procedure MouseRighUp;
    function GetWavPath: string;
    procedure PlaySound(fn: string);
    procedure PlayPauseSound;    
    procedure PlayResumeSound;
    procedure PlayRClkModeSound;
    procedure SetIsCompact(const Value: Boolean);
    procedure SetIsRecognition(const Value: Boolean);
  protected
    procedure WMExitsizemove(var Message: TMessage);
      message WM_EXITSIZEMOVE;
  public
    { Public 宣言 }
    FIsPause: Boolean;
    Option: TOption;
    IsPauseBtnMouseEnter: Boolean;   
    IsRightClickBtnMouseEnter: Boolean;
    procedure InvokeUI(const TypeOfUI, Caption: WideString);
    procedure Speak(s: string);
    procedure MakeSetCmdFile;
    property IsTopMost: Boolean read FIsTopMost write SetIsTopMost;
    property IsPause: Boolean read FIsPause write SetIsPause;
    property IsRightClick: Boolean read FIsRightClick write SetIsRightClick;
    property IsCompact: Boolean read FIsCompact write SetIsCompact;
    property IsRecognition: Boolean read FIsRecognition write SetIsRecognition;
  end;

var
  MainForm: TMainForm;
const                
  CMD_FILE = 'command.xml';
  SET_CMD_FILE = 'set_command.txt';

implementation

{$R *.dfm}

uses Compact;


procedure TMainForm.AddLog(h: HWND; cap, msg: string; p: TPoint; vol: Integer);
var b: array[0..100] of char; it: TListItem;
begin
  with ListView1.Items do begin
    BeginUpdate;
    GetClassName(h, b, 101);
//    if cap = '' then cap := '---';
    if Count = 0 then
      it := Add
    else
      it := Insert(0);
    it.Caption := msg;         
    it.SubItems.Add(IntToStr(vol));
    it.SubItems.Add('$' + IntToHex(h, 8));
    it.SubItems.Add(b);
    it.SubItems.Add(cap);
    it.SubItems.Add('X='+IntToStr(p.X)+', Y='+IntToStr(p.Y));
    while Count > 100 do begin
      Delete(Count-1);
    end;
//    it.Selected := True;
//    it.MakeVisible(False);
    EndUpdate;
  end;

//  if Memo1.Lines.Count > 500 then begin
//    Memo1.Clear;
////    while Memo1.Lines.Count > 200 do
////      Memo1.Lines.Delete(0);
//  end;
//  GetClassName(h, b, 101);
//  Memo1.Lines.Add(msg);
//  Memo1.Lines.Add('HWND:'#9 + IntToHex(h, 8));
//  if cap = '' then cap := '---';
//  Memo1.Lines.Add('Class:'#9 + b);
//  Memo1.Lines.Add('Caption:'#9 + cap);
//  Memo1.Lines.Add('Pos:'#9'X='+IntToStr(p.X)+', Y='+IntToStr(p.Y));
//  Memo1.Lines.Add('-----------------------');
end;

procedure TMainForm.SpSharedRecoContext1AudioLevel(ASender: TObject;
  StreamNumber: Integer; StreamPosition: OleVariant; AudioLevel: Integer);
var  h: HWND; b: array[0..100] of char;
  nht: Integer; IsSysBtn: Boolean;
begin
  if IsPause and (not IsPauseBtnMouseEnter) then Exit;
//  Memo1.Lines.Add(IntToStr(AudioLevel));
  ProgressBar1.Position := AudioLevel;
  CompactForm.ProgressBar1.Position := AudioLevel;
  GetCursorPos(gp);
  h := WindowFromPoint(gp);
//  IsMyForm := GetAncestor(h, GA_ROOT) = Handle;
//  if h = Memo1.Handle then Exit;
  GetWindowText(h, b, 101);
  cp := gp;
  Windows.ScreenToClient(h, cp);
  nht := SendMessage(h, WM_NCHITTEST, 0, MakeLParam(gp.X, gp.Y));
  IsSysBtn := (nht = HTMINBUTTON) or (nht =  HTMAXBUTTON) or (nht = HTCLOSE);
//  DOutI(nht);
  if AudioLevel >= Option.Sensitivity then begin

    if IsRightStart and ((GetTickCount - RightStartTime) > Option.RightClkTime) then begin

      MouseLeftUp;
      MouseRightDown;
      MouseRighUp;
      
      AddLog(h, b, 'Right click', gp, AudioLevel);
      IsRightStart := False;
      IsPopupModal := True;
      RightStartTime := GetTickCount;

      Exit;
    end;
    if IsDblStart and ((GetTickCount - DblStartTime) < Option.DblClkSpeed) then begin
      MouseLeftDown;
      MouseLeftUp;

      IsMouseDown := True;
      IsDblStart := False;
      AddLog(h, b, 'Left double click', gp, AudioLevel);
      Exit;
    end else begin
      IsDblStart := False;
    end;

    if IsMouseDown {or IsDragStart} then Exit;
    if IsRightClick then begin
      if nht = HTCAPTION then Exit;
      MouseRightDown;
      AddLog(h, b, 'Right down', gp, AudioLevel);
    end else begin
      MouseLeftDown;
      AddLog(h, b, 'Left down', gp, AudioLevel);
    end;


    if IsSysBtn then
      if IsRightClick then begin
        MouseRighUp;
        if Option.IsKeepRight and IsRightClickBtnMouseEnter then
          IsRightClick := False;
        if (not Option.IsKeepRight) then
          IsRightClick := False;
        AddLog(h, b, 'Right up', gp, AudioLevel);
      end else begin
        MouseLeftUp;
        AddLog(h, b, 'Left down', gp, AudioLevel);
      end;

    IsMouseDown := True;
    IsRightStart := True; 
//      IsDragStart := True;
    DblStartTime := GetTickCount;
    RightStartTime := GetTickCount;
    DragStartTime := GetTickCount;
  end else if IsMouseDown then begin
//    ReleaseCapture;
    if (not IsSysBtn) and (not IsPopupModal) {and (not IsDragStart)} then begin
      if IsRightClick then begin
        if nht = HTCAPTION then Exit;
        MouseRighUp;
        AddLog(h, b, 'Right up', gp, AudioLevel);   
        if Option.IsKeepRight and IsRightClickBtnMouseEnter then
          IsRightClick := False;
        if (not Option.IsKeepRight) then
          IsRightClick := False;
      end else begin
        MouseLeftUp; 
        AddLog(h, b, 'Left up', gp, AudioLevel);
      end;
      

//      IsDragStart := False;

    end;

    IsMouseDown := False;
//    IsRightStart := False;
    IsDblStart := True;
    IsPopupModal := False;
//    IsDragStart := False;
    
  end else begin
    IsMouseDown := False;
    IsRightStart := False;
    IsPopupModal := False;
//    IsDragStart := False;
    DragStartTime := GetTickCount;
//    ReleaseCapture;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  s: string;
  Reco: TSpSharedRecoContext;  
  SOToken: ISpeechObjectToken;
  SOTokens: ISpeechObjectTokens;
  i: Integer;
begin
  if FileExists(SET_CMD_FILE) then begin
    CopyFile(PChar(SET_CMD_FILE), PChar(CMD_FILE), False);
  end;
  if (DebugHook <> 0) and (Win32MajorVersion >= 6) then Exit;
  if (Win32MajorVersion >= 6) then begin
    RcgLogMemo.Visible := False;
    Splitter1.Visible := False;
  end;

  s := CMD_FILE;
  Reco := SpSharedRecoContext1;
  try
    Reco.EventInterests := SREAllEvents;
    SRGrammar := Reco.CreateGrammar(0);
    SRGrammar.CmdLoadFromFile(s, SLODynamic);
    SRGrammar.CmdSetRuleIdState(0, SGDSActive);
  except
    on E:Exception do
     if (Pos('80045052', E.Message) > 0) and (Win32MajorVersion < 6) then begin
        Beep;
        if (MessageDlg('SAPI 5.1が適切にセットアップされていません。'#13#10 +
          'マイクロソフトから「SpeechSDK51.exe」をダウンロード・インストールし、'#13#10 +
          '「コントロールパネル／音声認識」の「音声認識」タブの「言語」を'#13#10 +
          '「Microsoft English Recoginizer v5.1」に設定してください。'#13#10#13#10 +
          '解説ページを開きますか？'
          , mtWarning, [mbYes, mbNo], 0) = mrYes) then begin
          OpenWeb('http://netakiri.net/labo/rcg_setup.shtml');
        end;
        Application.Terminate;
        Exit;
     end;
  end;
  SOTokens := SpVoice1.GetVoices('', '');  
  for i := 0 to SOTokens.Count - 1 do begin
    SOToken := SOTokens.Item(i);
    if (SOToken.GetDescription(0) = 'Microsoft Mary') then begin
      SpVoice1.Voice := SOToken;
      Break;
    end;;
    //Increment the descriptor reference count to ensure it doesn't get destroyed
    SOToken._AddRef;
  end;
//  GetVoices

//  IsDragStart := False;
  FIsRecognition := False;
  IsPauseBtnMouseEnter := False;

  DefPauseBtnWndProc := PauseToolButton.WindowProc;
  PauseToolButton.WindowProc := PauseProc;

  DefRightClickBtnWndProc := RightClickToolButton.WindowProc;
  RightClickToolButton.WindowProc := RightClickProc;

  Option := TOption.Create;
        
  with ExtIniFile1 do begin
    ReadForm('config', 'form', Self);
    ReadForm('config', 'CompactForm', CompactForm);
    RcgLogMemo.Width := ReadInt('config', 'RcgLogMemo.Width', RcgLogMemo.Width);
    IsTopMost := ReadBool('config', 'IsTopMost', IsTopMost);
    FIsPause := ReadBool('config', 'IsPause', IsPause);
    IsCompact := ReadBool('config', 'IsCompact', IsCompact); 
    PauseAction.Checked := FIsPause;
  end;
  
  Option.Read;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if IsMouseDown then
    MouseLeftUp;
  if IsRightStart then
    MouseRighUp;
  with ExtIniFile1 do begin
    WriteForm('config', 'form', Self);
    WriteForm('config', 'CompactForm', CompactForm);
    WriteInt('config', 'RcgLogMemo.Width', RcgLogMemo.Width);
    WriteBool('config', 'IsCompact', IsCompact);
    WriteBool('config', 'IsTopMost', IsTopMost);
    WriteBool('config', 'IsPause', IsPause);   
  end;
  try
    Option.Write;
  except

  end;
  Application.Terminate;
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Canvas do begin
    Rectangle(x,y,x+3,y+3);
  end;
end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  Close;
end;

{ TOption }

constructor TOption.Create;
begin
  FSensitivity := 1;
  FDblClkSpeed := 500;
  FRightClkTime := 2000;
  IsSound := True;
  IsKeepRight := False;
end;

procedure TOption.Read;
begin
  with MainForm.ExtIniFile1 do begin
    Sensitivity := ReadInt('option', 'Sensitivity', Sensitivity);
    DblClkSpeed := ReadInt('option', 'DblClkSpeed', DblClkSpeed);
    RightClkTime := ReadInt('option', 'RightClkTime', RightClkTime);
    IsSound := ReadBool('option', 'IsSound', IsSound);
    IsRecognition := ReadBool('option', 'IsRecognition', IsRecognition);
    MainForm.IsRecognition := IsRecognition;
    IsVoiceInfo := ReadBool('option', 'IsVoiceInfo', IsVoiceInfo);  
    IsKeepRight := ReadBool('option', 'IsKeepRight', IsKeepRight);
  end;
end;

procedure TOption.SetIsKeepRight(const Value: Boolean);
begin
  FIsKeepRight := Value;
end;

procedure TOption.Write;
begin
  with MainForm.ExtIniFile1 do begin
    WriteInt('option', 'Sensitivity', Sensitivity);
    WriteInt('option', 'DblClkSpeed', DblClkSpeed);
    WriteInt('option', 'RightClkTime', RightClkTime);
    WriteBool('option', 'IsSound', IsSound);
    IsRecognition := MainForm.IsRecognition;
    WriteBool('option', 'IsRecognition', IsRecognition);     
    WriteBool('option', 'IsVoiceInfo', IsVoiceInfo);
    WriteBool('option', 'IsKeepRight', IsKeepRight);
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  PauseToolButton.WindowProc := DefPauseBtnWndProc;
  Option.Free;
end;

procedure TMainForm.SettingActionExecute(Sender: TObject);
begin
  SettingDlg := TSettingDlg.Create(Self);
  try
    with SettingDlg do begin
      SensitivitySpinEdit.Value := Option.Sensitivity;
      DblClkSpeedSpinEdit.Value := Option.DblClkSpeed;
      RightClkTimeSpinEdit.Value := Option.RightClkTime;
      IsSoundCheckBox.Checked := Option.IsSound;
      IsKeepRightCheckBox.Checked := Option.IsKeepRight;
      IsRecognitionCheckBox.Checked := IsRecognition;   
      IsVoiceInfoCheckBox.Checked := Option.IsVoiceInfo;

      if ShowModal = mrOk then begin
        Option.Sensitivity := SensitivitySpinEdit.Value;
        Option.DblClkSpeed := DblClkSpeedSpinEdit.Value;
        Option.RightClkTime := RightClkTimeSpinEdit.Value;
        Option.IsSound := IsSoundCheckBox.Checked;  
        Option.IsKeepRight := IsKeepRightCheckBox.Checked;
        IsRecognition := IsRecognitionCheckBox.Checked;
        Option.IsVoiceInfo := IsVoiceInfoCheckBox.Checked;
      end;
    end;
  finally
    SettingDlg.Release;
  end;
end;

procedure TMainForm.AboutActionExecute(Sender: TObject);
begin
  MessageDlg(
    Application.Title + ' Ver.' + VERSION + ''#13#10#13#10 + 
    'Created by yhira.'
    , mtInformation, [mbOK], 0);
end;

procedure TMainForm.HelpActionExecute(Sender: TObject);
begin
  ShowMessage(
    'Example'#13#10#13#10 +
    '! = Sound'#13#10#13#10 +
    'Click'#13#10 +
    '!'#13#10#13#10 +
    'Double click'#13#10 +
    '!_!'#13#10#13#10 +
    'Right click'#13#10 +
    '!!!!!!!!!!!!  (After right-click time)'#13#10#13#10 +
    'Drag'#13#10 +
    '!!!!!!!!!!!!  (Until right-click time)');
end;

procedure TMainForm.SetIsTopMost(const Value: Boolean);
begin
  FIsTopMost := Value;
//    SetWindowPos(Application.Handle, HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    if IsCompact then begin
//      SetWindowPos(CompactForm.Handle, HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    end else begin
//      SetWindowPos(Handle, HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE or
  TopMostAction.Checked := Value;
//  if IsIconic(Application.Handle) then Exit;
  if Value then begin
    if IsIconic(Application.Handle) then
      Application.Restore;
    SetWindowPos(Application.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    if IsCompact then begin
//      SetWindowPos(CompactForm.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    end else begin
//      SetWindowPos(Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    end;
//    SetWindowPos(Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
  end else begin
    SetWindowPos(Application.Handle, HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//    end;
//    SetWindowPos(Handle, HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
  end;
end;

procedure TMainForm.TopMostActionExecute(Sender: TObject);
begin
  IsTopMost := not IsTopMost;
end;

procedure TMainForm.SetIsPause(const Value: Boolean);
begin
  FIsPause := Value;
  PauseAction.Checked := Value;
  if Value then
    PlayPauseSound
  else
    PlayResumeSound;
end;

procedure TMainForm.PauseActionExecute(Sender: TObject);
begin
  IsPause := not IsPause;
end;

procedure TMainForm.ClearListActionExecute(Sender: TObject);
begin
  ListView1.Clear;
end;

procedure TMainForm.OpenWeb(Url: string);
begin
  ShellExecute(Handle, 'open', PChar(Url),
            nil, nil, SW_NORMAL);
end;

procedure TMainForm.WebsiteActionExecute(Sender: TObject);
begin
  OpenWeb('http://netakiri.net/soft/click_by_sound.shtml');
end;

procedure TMainForm.PauseProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_MOUSEENTER: IsPauseBtnMouseEnter := True;
    CM_MOUSELEAVE: IsPauseBtnMouseEnter := False;
    else DefPauseBtnWndProc(Message);
  end;
end;

procedure TMainForm.SetIsRightClick(const Value: Boolean);
begin
  FIsRightClick := Value;
  RightClickAction.Checked := Value;
  if Value then PlayRClkModeSound;
end;

procedure TMainForm.RightClickActionExecute(Sender: TObject);
begin
  IsRightClick := not IsRightClick;
end;

procedure TMainForm.MouseLeftDown;
begin
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN,gp.X,gp.Y,0,0);
end;

procedure TMainForm.MouseLeftUp;
begin
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,gp.X,gp.Y,0,0);
end;

procedure TMainForm.MouseRightDown;
begin
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_RIGHTDOWN,gp.X,gp.Y,0,0);
end;

procedure TMainForm.MouseRighUp;
begin
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_RIGHTUP,gp.X,gp.Y,0,0);
end;

function TMainForm.GetWavPath: string;
begin
  Result := ExtractFilePath(ParamStr(0)) + 'wav\';
end;

procedure TMainForm.PlaySound(fn: string);

var s: string;
begin
  //サウンド再生
  s := GetWavPath + fn;
  if Option.IsSound and (FileExists(s)) then begin
    sndPlaySound(nil, SND_ASYNC);
    sndPlaySound(PChar(s), SND_ASYNC);
  end;
end;

procedure TMainForm.PlayPauseSound;
begin
  PlaySound('bachi.wav');
end;

procedure TMainForm.PlayRClkModeSound;
begin
  PlaySound('swich.wav');
end;

procedure TMainForm.PlayResumeSound;
begin
  PlaySound('cho.wav');
end;

procedure TMainForm.SetIsCompact(const Value: Boolean);
begin
  FIsCompact := Value;
  CompactAction.Checked := Value;
  if IsCompact then begin
    CompactForm.Show;
    MainForm.Hide;                                            
  end else begin      
    MainForm.Show;
    CompactForm.Hide;
  end;
//  if IsTopMost then
//    SetWindowPos(Application.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
end;

procedure TMainForm.CompactActionExecute(Sender: TObject);
begin
  IsCompact := not IsCompact;
//  if IsCompact then begin
//    BorderStyle := bsToolWindow;
//  end else begin
//    BorderStyle := bsSizeable;
//  end;
//  SmallToolBar.Visible := IsCompact;
//  LargeToolBar.Visible := not IsCompact;
//  CompactForm.Visible := not IsCompact;
end;

procedure TMainForm.WMExitsizemove(var Message: TMessage);
begin
//  IsTopMost := IsTopMost;
end;

procedure TMainForm.ApplicationEvents1Deactivate(Sender: TObject);
begin
//  Application.Restore;
//  if IsIconic(Application.Handle) then Exit;
  if IsTopMost then
    IsTopMost := IsTopMost;
end;

procedure TMainForm.SpSharedRecoContext1Recognition(ASender: TObject;
  StreamNumber: Integer; StreamPosition: OleVariant;
  RecognitionType: TOleEnum; const Result: ISpeechRecoResult);


  function GetProp(Props: ISpeechPhraseProperties;
    const Name: String): ISpeechPhraseProperty; overload;
  var
    I: Integer;
    Prop: ISpeechPhraseProperty;
  begin
    Result := nil;
    for I := 0 to Props.Count - 1 do
    begin
      Prop := Props.Item(I);
      if CompareText(Prop.Name, Name) = 0 then
      begin  
        Result := Prop;
        Break
      end
    end
  end;

  function GetPropValue(SRResult: ISpeechRecoResult;
    const Path: array of String): OleVariant;
  var
    Prop: ISpeechPhraseProperty;
    PathLoop: Integer;
  begin
    for PathLoop := Low(Path) to High(Path) do
    begin
      if PathLoop = Low(Path) then //top level property
        Prop := GetProp(SRResult.PhraseInfo.Properties, Path[PathLoop])
      else //nested property
        Prop := GetProp(Prop.Children, Path[PathLoop]);
      if not Assigned(Prop) then
      begin
        Result := Unassigned;
        Exit;
      end
    end;
    Result := Prop.Value
  end;

var Value: OleVariant;
const
  CMD_OPERATE  = 0;
  CMD_TOPMOST  = 1;
  CMD_RIGHTCLK = 2;
  CMD_COMPACT  = 3;
begin
  if not IsRecognition then Exit;
  with Result.PhraseInfo do begin
  
    Value := GetPropValue(Result, ['chosencommand', 'commandvalue']);
//    DOut(Value);
    if IsPause and (Value > 0) then 
      Exit;
    case Value of
      CMD_OPERATE: begin
        if IsPause then
          Speak('Opration start.')
        else
          Speak('Opration pause');
        IsPause := not IsPause;
      end;
//      0: if IsPause then IsPause := False;
//      1: if not IsPause then IsPause := True;
      CMD_TOPMOST: begin
        if IsTopMost then
          Speak('Top mode off.')
        else
          Speak('Top mode on');
        IsTopMost := not IsTopMost;
      end;
      CMD_RIGHTCLK: begin
        Speak('Right-click mode.');
        IsRightClick := True;
      end;
      CMD_COMPACT: begin  
        if IsCompact then
          Speak('Compact mode off.')
        else
          Speak('Compact mode on');
        IsCompact := not IsCompact;
      end;
    end;
    RcgLogMemo.Lines.Insert(0,
      'Rcg: ' + GetText(0, -1, True));
    IsMouseDown := False;
  end;
end;

procedure TMainForm.SpSharedRecoContext1Hypothesis(ASender: TObject;
  StreamNumber: Integer; StreamPosition: OleVariant;
  const Result: ISpeechRecoResult);
begin
  RcgLogMemo.Lines.Insert(0,
    'Hyp: ' + Result.PhraseInfo.GetText(0, -1, True));
end;

procedure TMainForm.MakeSetCmdFile;
begin
  if not FileExists(SET_CMD_FILE) then begin
    if FileExists(CMD_FILE) then
      CopyFile(PChar(CMD_FILE), PChar(SET_CMD_FILE), False);
  end;
end;

procedure TMainForm.SetIsRecognition(const Value: Boolean);
begin
  FIsRecognition := Value;
//  RcgLogMemo.Visible := Value and (Win32MajorVersion >= 6);
  MakeSetCmdFile;
end;

procedure TMainForm.InvokeUI(const TypeOfUI, Caption: WideString);
var
  U: OleVariant;
begin
  U := Unassigned;
  if SpSharedRecoContext1.Recognizer.IsUISupported(TypeOfUI, U) then
    SpSharedRecoContext1.Recognizer.DisplayUI(Handle, Caption, TypeOfUI, U);
end;

procedure TMainForm.Speak(s: string);
//var tmp: Boolean;
begin
  if not Option.IsVoiceInfo then Exit;//
//  tmp := FIsPause;
//  SpSharedRecoContext1.Pause;
//  SpSharedRecoContext1.Disconnect;
//  SpSharedRecoContext1.AutoConnect := false;
//  SpSharedRecoContext1.Disconnect;
  SpVoice1.Speak(s, SVSFDefault);
//  SpSharedRecoContext1.Resume;

end;

procedure TMainForm.RightClickProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_MOUSEENTER: IsRightClickBtnMouseEnter := True;
    CM_MOUSELEAVE: IsRightClickBtnMouseEnter := False;
    else DefRightClickBtnWndProc(Message);
  end;
end;

end.
