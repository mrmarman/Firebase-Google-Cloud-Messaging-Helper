object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 356
  ClientWidth = 593
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    593
    356)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 138
    Width = 44
    Height = 13
    Caption = 'Mes.Id :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 577
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Mesaj Test @ Muharrem ARMAN'
      '')
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Memo2: TMemo
    Left = 8
    Top = 168
    Width = 313
    Height = 180
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Push Results :')
    ScrollBars = ssBoth
    TabOrder = 1
    WordWrap = False
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 135
    Width = 129
    Height = 25
    Caption = 'Push Message'
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object Edit1: TEdit
    Left = 72
    Top = 135
    Width = 98
    Height = 21
    TabOrder = 3
    Text = '12345'
  end
  object Memo3: TMemo
    Left = 336
    Top = 168
    Width = 249
    Height = 180
    Anchors = [akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo3')
    ScrollBars = ssBoth
    TabOrder = 4
    WordWrap = False
  end
end
