unit Unit1;

interface

uses
  MMSYSTEM, Windows, Classes, Forms, SysUtils, Controls, Dialogs, ExtCtrls;

type
  TForm1 = class(TForm)
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  bys: byte;

implementation

procedure switchtothiswindow(wnd : hwnd; brestore: bool); stdcall;
external 'user32.dll' name 'SwitchToThisWindow';

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
    application.showmainform:= false;
    with ttimer.create(self) do
    begin
    parent:= form1;
    name:= 'timer1';
    enabled:= true;
    interval:= 5000;
    OnTimer:= Timer1Timer;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
label  lab,lab2;
var
 resp: word; int: string; str: array[0..255] of char; h: hwnd; //q:  thandle;
  begin
       if findwindow('TAppBuilder', nil) <> 0
       then
       if findwindow('TEditWindow', nil) = GetForegroundWindow
       then
       begin

       h:= GetForegroundWindow;
       (Sender as ttimer).enabled:= false;

       bys:= 0;
       timer.enabled:= true;
       PlaySound(pansichar(extractfilepath(paramstr(0))+'\Beep.wav'), 0, SND_ASYNC);

       resp:= messagedlg(
       ' ����������� ��� ���..?'+#13
       +'( OK - ��� �������� [������� ������] !)'+#13
       +'( CANCEL - � ��� �� �����...)'#13
       +'( ABORT - ����������� ���� ����������� ���� ..!)'#13
       +'( RETRY - ������ ������� ���������� �������.)'#13
       +'( YESTOALL - ��������� �� !)',
        mtConfirmation,
       [mbOk,mbYesToAll,mbCancel,mbRetry,mbAbort],0);
       timer.enabled:= false;

       if (resp = mrOk)then begin
       switchtothiswindow(h,true);
       keybd_event(vk_control, 0, 0, 0);
       keybd_event(83, 0, 0, 0);

       keybd_event(vk_control, 0, KEYEVENTF_KEYUP, 0);
       keybd_event(83, 0, KEYEVENTF_KEYUP, 0);
       end;

       if (resp = mrYesToAll)then begin
       switchtothiswindow(h,true);
       keybd_event(vk_control, 0, 0, 0);
       keybd_event(vk_shift, 0, 0, 0);
       keybd_event(83, 0, 0, 0);

       keybd_event(vk_control, 0, KEYEVENTF_KEYUP, 0);
       keybd_event(vk_shift, 0, KEYEVENTF_KEYUP, 0);
       keybd_event(83, 0, KEYEVENTF_KEYUP, 0);
       end;

       if (resp = mrRetry)then
       begin
       lab:
       int:= InputBox('������� � �������� �������� ��������� ����� ����', '������� ������: ', inttostr(trunc((Sender as ttimer).interval/1000)));
       if (strtointdef(int, -1) = -1)or(trunc(strtoint(int)*1000) = 0) then begin
       messagedlg('  ! �����, ��� � �����, ����� ������ ����� '#13'   (��� �� ����� ����� �� ��������� ���������� ��������.) ',mtError,[mbOk],0);
       goto lab; end;

       (Sender as ttimer).interval:= trunc(strtointdef(int,5)*1000);
       end;

       if (resp = mrAbort)then begin
       resp:= messagedlg('   ����� ����, ����� ����... '#13'   ����� ����������, ������ ����� ������������ !? ',mtConfirmation,[mbYes, mbNo],0);
       if resp <> mrNo then goto lab2;
       application.terminate; end;

       lab2:
       if resp = mrYes then ShowMessage(' !� ������ �������.., ��� �� ��� ����� �����.');
       (Sender as ttimer).enabled:= true;
       end;
end;

procedure TForm1.TimerTimer(Sender: TObject);
var
 h,o: hwnd;
 ch: string;
begin
     h:= 0;
     h:= findwindow(nil, 'Confirm');
     if h <> 0 then
     begin
     inc(bys);
     if bys < 3 then
     PlaySound(pansichar(extractfilepath(paramstr(0))+'\Beep.wav'), 0, SND_ASYNC);
     switchtothiswindow(h,true);
     flashwindow(h, true);

     ch:= inttostr(5 - bys);
     if bys = 1 then
     o:= findwindow(nil,pansichar(' !��������, �� ��������� ��������� ������'))
     else
     o:= findwindow(nil,pansichar(inttostr(5 - pred(bys))+' !��������, �� ��������� ��������� ������'));
     SetWindowText(o,pansichar( ch+' !��������, �� ��������� ��������� ������' ));
     if (bys = 5) then begin
     timer.enabled:= false;
     SetWindowText(o,pansichar(' !��������, �� ��������� ��������� ������' ));
     switchtothiswindow(h,true);
     //sleep(500);

     keybd_event(vk_escape, 0, 0, 0);
     keybd_event(vk_escape, 0, KEYEVENTF_KEYUP, 0);

     end;
     end;
end;

end.
