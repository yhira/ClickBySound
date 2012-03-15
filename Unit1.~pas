unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleServer, SpeechLib_TLB, ComCtrls, ExtCtrls, THTskTry
  ,Dbg, Menus;

type
  TForm1 = class(TForm)
    SpSharedRecoContext1: TSpSharedRecoContext;
    ProgressBar1: TProgressBar;
    THTaskTrayIcon1: TTHTaskTrayIcon;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Close1: TMenuItem;
    Option1: TMenuItem;
    Setting1: TMenuItem;
    Label1: TLabel;
    procedure SpSharedRecoContext1AudioLevel(ASender: TObject;
      StreamNumber: Integer; StreamPosition: OleVariant;
      AudioLevel: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Close1Click(Sender: TObject);
  private
    { Private éŒ¾ }
    SRGrammar: ISpeechRecoGrammar;
    IsMouseDown, IsDblStart, IsRightStart,
    IsPushSysBtn: Boolean;
    DblStartTime, RightStartTime: Cardinal;
    procedure AddLog(h: HWND; cap, msg: string; p: TPoint);
  public
    { Public éŒ¾ }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.AddLog(h: HWND; cap, msg: string; p: TPoint);
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
    it.SubItems.Add('0x' + IntToHex(h, 8));
    it.SubItems.Add(b);
    it.SubItems.Add(cap);
    it.SubItems.Add('X='+IntToStr(p.X)+', Y='+IntToStr(p.Y));
    while Count > 100 do begin
      Delete(Count-1);
    end;
//    it.Selected := True;
    it.MakeVisible(False);
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

procedure TForm1.SpSharedRecoContext1AudioLevel(ASender: TObject;
  StreamNumber: Integer; StreamPosition: OleVariant; AudioLevel: Integer);
var cp, gp: TPoint; h: HWND; b: array[0..100] of char;
  nht: Integer; IsSysBtn: Boolean;
begin
//  Memo1.Lines.Add(IntToStr(AudioLevel));
  ProgressBar1.Position := AudioLevel;
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
  if AudioLevel > 1 then begin
//    DOutI((GetTickCount - DblStartTime));
    if IsRightStart and ((GetTickCount - RightStartTime) > 1000) then begin
//      if IsMyForm then begin
//        PostMessage(h, WM_RBUTTONDOWN, 0, MakeLParam(cp.X, cp.Y));
//        PostMessage(h, WM_RBUTTONUP, 0, MakeLParam(cp.X, cp.Y));
//      end;

      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_RIGHTDOWN,gp.X,gp.Y,0,0);
      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_RIGHTUP,gp.X,gp.Y,0,0);
      AddLog(h, b, 'Right click', gp);
      IsRightStart := False;
      RightStartTime := GetTickCount;
      Exit;
    end;
    if IsDblStart and ((GetTickCount - DblStartTime) < 500) then begin
//      if IsMyForm then begin
//        if nht < HTCAPTION then
//          PostMessage(h, WM_LBUTTONDBLCLK, 0, MakeLParam(cp.X, cp.Y))
//        else
//          PostMessage(h, WM_NCLBUTTONDBLCLK, nht, MakeLParam(gp.X, gp.Y));
//        Exit;
//      end;

//      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN,gp.X,gp.Y,0,0);
//      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,gp.X,gp.Y,0,0);
      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN,gp.X,gp.Y,0,0);
      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,gp.X,gp.Y,0,0);

      IsMouseDown := True;
      IsDblStart := False;
      AddLog(h, b, 'Left double click', gp);
      Exit;
    end else begin
      IsDblStart := False;
    end;

    if IsMouseDown then Exit;

    Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN,gp.X,gp.Y,0,0);
    if IsSysBtn then
      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,gp.X,gp.Y,0,0);
//    if nht < HTCAPTION then
//      PostMessage(h, WM_LBUTTONDOWN, 0, MakeLParam(cp.X, cp.Y))
//    else begin
//      case nht of
//        HTMINBUTTON, HTMAXBUTTON, HTCLOSE, HTSYSMENU: IsPushSysBtn := True;
//        else begin
//          IsPushSysBtn := False;
//          PostMessage(h, WM_NCLBUTTONDOWN, nht, MakeLParam(gp.X, gp.Y));
//        end;
//      end;
//    end;


//    PostMessage(h, WM_NCLBUTTONUP, nht, MakeLParam(gp.X, gp.Y));
//    PostMessage(h, WM_LBUTTONUP, 0, MakeLParam(p.X, p.Y));
//    SetCapture(Handle);
    IsMouseDown := True;
    IsRightStart := True;
    AddLog(h, b, 'Left down', gp);
    DblStartTime := GetTickCount;
    RightStartTime := GetTickCount;
  end else if IsMouseDown then begin
//    ReleaseCapture;
    if not IsSysBtn then
      Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP,gp.X,gp.Y,0,0);
//    if nht < HTCAPTION then
//      PostMessage(h, WM_LBUTTONUP, 0, MakeLParam(cp.X, cp.Y))
//    else
//      if IsPushSysBtn then begin
//        case nht of
//          HTMINBUTTON: SendMessage(h, WM_SYSCOMMAND, SC_MINIMIZE, MakeLParam(gp.X, gp.Y));
//          HTMAXBUTTON: SendMessage(h, WM_SYSCOMMAND, SC_MAXIMIZE, MakeLParam(gp.X, gp.Y));
//          HTCLOSE:     SendMessage(h, WM_SYSCOMMAND, SC_CLOSE, MakeLParam(gp.X, gp.Y));
//          HTSYSMENU:   SendMessage(h, WM_SYSCOMMAND, SC_KEYMENU, MakeLParam(gp.X, gp.Y));
//        end;
//      end else begin
//        IsPushSysBtn := False;
//        PostMessage(h, WM_NCLBUTTONUP, nht, MakeLParam(gp.X, gp.Y));
//      end;

//    ;
    IsMouseDown := False;
    IsDblStart := True;
    AddLog(h, b, 'Left up', gp);
  end else begin
    IsMouseDown := False;
    IsRightStart := False;
//    ReleaseCapture;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s: string;
  Reco: TSpSharedRecoContext;
begin
  s := 'command.xml';
  Reco := SpSharedRecoContext1;

  Reco.EventInterests := SREAllEvents;
  SRGrammar := Reco.CreateGrammar(0);
  SRGrammar.CmdLoadFromFile(s, SLODynamic);
  SRGrammar.CmdSetRuleIdState(0, SGDSActive);


end;

procedure TForm1.Timer1Timer(Sender: TObject);
var p: TPoint;
begin

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  with Canvas do begin
    Rectangle(x,y,x+3,y+3);
  end;
end;

procedure TForm1.Close1Click(Sender: TObject);
begin
  Close;
end;

end.
