program GCM_Sample;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Units\Unit1.pas' {Form1},
  GoogleCloudMessaging_Helper in '..\00.Common.HelperUnit\GoogleCloudMessaging_Helper.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
