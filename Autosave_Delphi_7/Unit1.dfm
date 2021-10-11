object Form1: TForm1
  Left = 251
  Top = 130
  BorderStyle = bsNone
  ClientHeight = 36
  ClientWidth = 128
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Comic Sans MS'
  Font.Style = [fsBold]
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object Timer: TTimer
    Enabled = False
    Interval = 2500
    OnTimer = TimerTimer
  end
end
