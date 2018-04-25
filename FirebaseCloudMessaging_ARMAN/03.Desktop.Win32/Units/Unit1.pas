unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label1: TLabel;
    Memo3: TMemo;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses GoogleCloudMessaging_Helper;

procedure TForm1.BitBtn1Click(Sender: TObject);
Var
  strResult : String;
begin
  xGCMHelper.API_Key             := 'AAAA-VoJp6E:APA91bG13PvsYyxRA3Xl2IP2Yocc4T1r_TxUKItLy4YWzoU5ZPdEfbFMsuVyFnmZildFBoeUzGX2FL4di5aD2KoEByVTT77nmXKnpyA21GT6Rb7kqy8us2gpdzIhxrNURpzcVocv6Ebc';
  xGCMHelper.NotifyTitle         := 'ARMAN Bilgi Merkezi';
  xGCMHelper.PHPRegisterHost     := 'http://www.armanlab.com/GoogleCloudMes/';

  xGCMHelper.LogMemo                    := Memo3;

  strResult := xGCMHelper.PushMessage( Memo1.Lines.Text, Edit1.Text, False );
  Memo2.Lines.Add('Send result: ' + strResult );
end;

end.

