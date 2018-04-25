unit Unit1;

interface

uses
  FMX.Forms, System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.StdCtrls, FMX.Edit, FMX.Controls, FMX.Controls.Presentation,
  FMX.ScrollBox, FMX.Memo;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Timer1: TTimer;
    Button3: TButton;
    Edit2: TEdit;
    Button4: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    procedure OnReceiveNotification     ( Sender: TObject; const
                                          strSent_time,
                                          strId,
                                          strFrom,
                                          strMessage_id,
                                          strMessage,
                                          strCollapse_key : String );

    procedure OnServiceConnectionChange ( Sender: TObject;
                                          strDeviceId,
                                          strDeviceToken  : String );
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses
    System.Notification,
    FMX.PushNotification.Android,

GoogleCloudMessaging_Helper;

procedure TForm1.Button3Click(Sender: TObject);
begin
  xGCMHelper.LocalAndroidNotification( Edit2.Text, 'ARMAN ' + TimeToStr(now), 0, 1 );
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  NotificationCenter  : TNotificationCenter;
begin
  NotificationCenter  := TNotificationCenter.Create(nil);
  try
    NotificationCenter.CancelNotification( Edit2.Text );
  finally
    NotificationCenter.Free;
    NotificationCenter.DisposeOf;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  // StartUp yani Notification Bar'dan Click ile direk içerik aldık...
  Memo1.Lines.Add( xGCMHelper.StartUpNotifications );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  inherited;
  //...

  // Project           : GCM-Helper-Class-by-ARMAN
  // Project ID        : gcm-helper-class-by-arman
  // Project number    : 1070957438881
  // Credental Api KEY : AAAA-VoJp6E:APA91bG13PvsYyxRA3Xl2IP2Yocc4T1r_TxUKItLy4YWzoU5ZPdEfbFMsuVyFnmZildFBoeUzGX2FL4di5aD2KoEByVTT77nmXKnpyA21GT6Rb7kqy8us2gpdzIhxrNURpzcVocv6Ebc

  xGCMHelper.GCM_ID              := '1070957438881';
  xGCMHelper.API_Key             := 'AAAA-VoJp6E:APA91bG13PvsYyxRA3Xl2IP2Yocc4T1r_TxUKItLy4YWzoU5ZPdEfbFMsuVyFnmZildFBoeUzGX2FL4di5aD2KoEByVTT77nmXKnpyA21GT6Rb7kqy8us2gpdzIhxrNURpzcVocv6Ebc';
  xGCMHelper.NotifyTitle         := 'ARMAN Bilgi Merkezi';
  xGCMHelper.PHPRegisterHost     := 'http://www.armanlab.com/GoogleCloudMes/';

  xGCMHelper.OnServiceConnectionChange  := OnServiceConnectionChange;
  xGCMHelper.OnReceiveNotification      := OnReceiveNotification;
  xGCMHelper.LogMemo                    := Memo1;
  xGCMHelper.Active                     := True;
end;

procedure TForm1.OnServiceConnectionChange ( Sender: TObject;
                                             strDeviceId,
                                             strDeviceToken  : String );
begin
  Memo1.Lines.Add( 'Ana Form OnServiceConnectionChange event fired:' );
    Memo1.Lines.Add( '  DeviceId   : ' + strDeviceId       );
    Memo1.Lines.Add( '  DeviceToken: ' + strDeviceToken    );
end;

Var
  xGeriSay : Integer = -1;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if xGeriSay > 0 then Dec(xGeriSay);
  if xGeriSay = 0 then
  begin // Gerisayım henüz bitti...
    xGeriSay := -1;
    xGCMHelper.PushMessage( Edit1.Text, 'ARMAN', False )
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if CheckBox1.IsChecked
  then xGeriSay := 3  // 3 Saniye Sonra
  else xGeriSay := 0; // >Şimdi<
end;

procedure TForm1.OnReceiveNotification     ( Sender: TObject; const
                                             strSent_time,
                                             strId,
                                             strFrom,
                                             strMessage_id,
                                             strMessage,
                                             strCollapse_key : String );
begin
  Memo1.Lines.Add( 'Ana Form OnReceiveNotification event fired:'   );
    Memo1.Lines.Add( '  SentTime: '     + strSent_time    );
    Memo1.Lines.Add( '  Id: '           + strId           );
    Memo1.Lines.Add( '  From: '         + strFrom         );
    Memo1.Lines.Add( '  MessageId: '    + strMessage_id   );
    Memo1.Lines.Add( '  Message: '      + strMessage      );
    Memo1.Lines.Add( '  Collapse_key: ' + strCollapse_key );
end;

end.
