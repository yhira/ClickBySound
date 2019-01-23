unit Compact;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Main;

type
  TCompactForm = class(TForm)
    ToolBar1: TToolBar;
    ProgressBar1: TProgressBar;
    PauseToolButton: TToolButton;
    ToolButton2: TToolButton;
    RightClickToolButton: TToolButton;
    ToolButton4: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private êÈåæ }           
    DefPauseBtnWndProc: TWndMethod; 
    DefRightClickBtnWndProc: TWndMethod;
    procedure PauseProc(var Message: TMessage);
    procedure RightClickProc(var Message: TMessage);
  protected
    procedure WMExitsizemove(var Message: TMessage);
      message WM_EXITSIZEMOVE;
  public
    { Public êÈåæ }
  end;

var
  CompactForm: TCompactForm;

implementation

{$R *.dfm}

procedure TCompactForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  MainForm.FormClose(MainForm, Action);
  Application.Terminate;
//  Action := caHide;
//  Hide;
//  MainForm.Show;
//  MainForm.IsCompact := False;
end;

procedure TCompactForm.FormShow(Sender: TObject);
begin
  ClientWidth := PauseToolButton.Width * 4 + 2;
  ClientHeight := PauseToolButton.Height + ProgressBar1.Height;
end;

procedure TCompactForm.PauseProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_MOUSEENTER: MainForm.IsPauseBtnMouseEnter := True;
    CM_MOUSELEAVE: MainForm.IsPauseBtnMouseEnter := False;
    else DefPauseBtnWndProc(Message);
  end;
end;

procedure TCompactForm.FormCreate(Sender: TObject);
begin
  DefPauseBtnWndProc := PauseToolButton.WindowProc;
  PauseToolButton.WindowProc := PauseProc;

  DefRightClickBtnWndProc := RightClickToolButton.WindowProc;
  RightClickToolButton.WindowProc := RightClickProc;
end;

procedure TCompactForm.WMExitsizemove(var Message: TMessage);
begin
//  with MainForm do
//    if IsTopMost then
////      SetWindowPos(Application.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
//      IsTopMost := IsTopMost;
end;

procedure TCompactForm.RightClickProc(var Message: TMessage);
begin
  case Message.Msg of
    CM_MOUSEENTER: MainForm.IsRightClickBtnMouseEnter := True;
    CM_MOUSELEAVE: MainForm.IsRightClickBtnMouseEnter := False;
    else DefRightClickBtnWndProc(Message);
  end;
end;

end.
