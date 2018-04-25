program Desktop_MessagePush.Win32;

uses
  Vcl.Forms,
  Unit1 in 'Units\Unit1.pas' {Form1},
  GoogleCloudMessaging_Helper in '..\00.Common.HelperUnit\GoogleCloudMessaging_Helper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
