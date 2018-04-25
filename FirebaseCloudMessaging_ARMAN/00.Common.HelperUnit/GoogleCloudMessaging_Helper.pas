{***************************************************************************}
{                                                                           }
{                   Google Cloud Messaging (GCM)  Class                     }
{                                                                           }
{                    Copyright (C) 2016 Muharrem ARMAN                      }
{                         muharrem.arman@trt.net.tr                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Google Cloud Messaging (GCM) Servisinden Yardım alarak                   }
{  Mobil cihazlara PUSH mesaj yollamak amacıyla tasarlanmıştır.             }
{                                                                           }
{  php ile veritabanı modülü de mevcuttur. Bu veritabanından mobil cihaz    }
{  listesi alınarak TokenID'lerine mesaj yollamak için kullanılmaktadır.    }
{                                                                           }
{  USES listesine bu UNIT'in eklenmesi yeterlidir.                          }
{  Ekstra bir tanımlamaya gerek yoktur.                                     }
{  Sistem kendiliğinden NOTIFICATION takibine girecektir                    }
{                                                                           }
{  Kullanımı :                                                              }
{ (1) Formunuzun Private kısmına aşağıdaki tanımı ekleyiniz...              }
{                                                                           }
{   procedure OnNewNotification(Sender: TObject; const                      }
{     strSent_time,                                                         }
{     strId,                                                                }
{     strFrom,                                                              }
{     strMessage_id,                                                        }
{     strMessage,                                                           }
{     strCollapse_key : String );                                           }
{                                                                           }
{ (2) Formun OnCreate olayına da aşağıdaki size özel tanımları yapınız.     }
{  // ANDROID CLIENT //                                                     }
{  xGCMHelper.GCM_ID          := '1070957438881';                           }
{  xGCMHelper.API_Key         := 'AAAA-VoJp6E:APA91bG13P.....RpzcVocv6Ebc'; }
{  xGCMHelper.NotifyTitle     := 'ARMAN Bilgi Merkezi';                     }
{  xGCMHelper.PHPRegisterHost := 'http://www.armanlab.com/GoogleCloudMes/'; }
{                                                                           }
{  xGCMHelper.OnServiceConnectionChange := OnServiceConnectionChange;       }
{  xGCMHelper.OnReceiveNotification     := OnReceiveNotification;           }
{  xGCMHelper.LogMemo                   := Memo1;                           }
{  xGCMHelper.Active                    := True;                            }
{                                                                           }
{  // MSWINDOWS SENDER //                                                   }
{  xGCMHelper.API_Key         := 'AAAAX8..................bFN77bz';         }
{  xGCMHelper.NotifyTitle     := 'ARMAN Bilgi Merkezi';                     }
{  xGCMHelper.PHPRegisterHost := 'http://www.armanlab.com/GoogleCloudMes/'; }
{  xGCMHelper.ProjectName     := 'arman-firebase';                          }
{  xGCMHelper.LogMemo         :=  Memo3;                                    }
{                                                                           }
{ (3) DeviceToken alındı ve/veya Notification geldi eventleri aşağıdadır.   }
{ procedure TForm1.OnServiceConnectionChange ( Sender: TObject;             }
{                                              strDeviceId,                 }
{                                              strDeviceToken  : String );  }
{ begin                                                                     }
{   Memo1.Lines.Add( 'Ana Form OnServiceConnectionChange event fired:' );   }
{     Memo1.Lines.Add( '  DeviceId   : ' + strDeviceId       );             }
{     Memo1.Lines.Add( '  DeviceToken: ' + strDeviceToken    );             }
{ end;                                                                      }
{                                                                           }
{ procedure TForm1.OnReceiveNotification     ( Sender: TObject; const       }
{                                              strSent_time,                }
{                                              strId,                       }
{                                              strFrom,                     }
{                                              strMessage_id,               }
{                                              strMessage,                  }
{                                              strCollapse_key : String );  }
{ begin                                                                     }
{   Memo1.Lines.Add( 'Ana Form OnReceiveNotification event fired:'   );     }
{     Memo1.Lines.Add( '  SentTime: '     + strSent_time    );              }
{     Memo1.Lines.Add( '  Id: '           + strId           );              }
{     Memo1.Lines.Add( '  From: '         + strFrom         );              }
{     Memo1.Lines.Add( '  MessageId: '    + strMessage_id   );              }
{     Memo1.Lines.Add( '  Message: '      + strMessage      );              }
{     Memo1.Lines.Add( '  Collapse_key: ' + strCollapse_key );              }
{ end;                                                                      }
{                                                                           }
{ (4) Mesaj Sender                                                          }
{ strResult := xGCMHelper.PushMessage( 'Mesajımız', 'MesajID', False );     }
{                                                                           }
{***************************************************************************}
{  Üzerinde değişiklik yapmak serbesttir ancak lütfen bu etiket bloğu       }
{  içine yaptığınız değişikliği ve künyenizi yazmayı ihmal etmeyiniz.       }
{***************************************************************************}
{  Değişikliği Yapan,  Yapılan Ekleme/Değişiklik bilgisi :                  }
{                                                                           }
{                                                                           }
{                                                                           }
{***************************************************************************}

// Başlangıçta Dikkat Edilecek Hususlar :
// --------------------------------------
// (1)   Manifest Dosyasındaki  <%receivers%> başlığının hemen altına
//       Aşağıdaki TAG bloğunu ekleyiniz.
//       (Bu sayede programımız çalışmıyor olsa dahi Push uyarı alınır.)
// <service android:name="com.embarcadero.gcm.notifications.GCMIntentService" />
//
// (2) "Project" / "Options" / "Entitlement List" kısmına gelerek
//     "Receive push notifications" başlığını TRUE yapınız.
//
// (3) "Project" / "Options" / "Uses Permissions" kısmına gelerek
//     "Internet" başlığını TRUE yapınız.

//{$DEFINE SSL_DLLs_inResourceMode}
unit GoogleCloudMessaging_Helper;

interface

Uses
  {$IF defined(MSWINDOWS)}
    Windows, Forms, Graphics, Controls, GifImg, Dialogs, IdAntiFreeze,
    ShellApi, StdCtrls,
    IdUri, IdSSLOpenSSL, IdSSLOpenSSLHeaders,
  {$ELSEIF defined(ANDROID)}
    System.Notification,
    System.PushNotification,
    FMX.PushNotification.Android,
    System.Threading, FMX.Memo,
    Androidapi.JNI.JavaTypes,
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.Helpers,
    Androidapi.JNI.Embarcadero,
  {$ENDIF}
    IdHttp, Classes, SysUtils, DateUtils;

{$REGION 'Type Tanımlar Bölümü'}

  Type
    pCihaz = ^tCihaz;
    tCihaz = Record
      CihazId,
      CihazToken,
      CihazPlatform,
      CihazTarih : String;
    End;
    pCihazBilgileri_Genel = Array of pCihaz;

    pIcerik = ^tIcerik;
    tIcerik = Record
      strSent_time,
      strId,
      strFrom,
      strMessage_id,
      strMessage,
      strCollapse_key : String;
    End;
    pMesajGrubu = Array of pIcerik;

{$ENDREGION 'Type Tanımlar Bölümü'}

{$REGION 'EVENT Tanımlar Bölümü'}
Type
  TOnEvent01 = procedure( Sender: TObject; const
                          strSent_time,
                          strId,
                          strFrom,
                          strMessage_id,
                          strMessage,
                          strCollapse_key : String ) of object;

  TOnEvent02 = procedure( Sender: TObject;
                          strDeviceId,
                          strDeviceToken  : String ) of object;

  TOnEvent03 = procedure( Sender: TObject;
                          AError: String ) of object;
{$ENDREGION 'EVENT Tanımlar Bölümü'}

Type
  TGCM_Helper = Class(TObject)
  private
  Const
    GCM_OpenUrl   =  'http://fcm.googleapis.com/fcm/send';
    GCM_SecureUrl = 'https://fcm.googleapis.com/fcm/send';
  Var
    FNotifyTitle          : String;
    FApiKey,
    FPhpPush              : String;

{$REGION 'ANDROID Bölümü'}
  {$IF defined(ANDROID)}
  private
  Var
    FGCM_ID               : String;
    FMemo                 : FMX.Memo.TMemo;
    FOnReceiveNotification: TOnEvent01;
    FOnServConnChange     : TOnEvent02;
    FOnRegisError         : TOnEvent03;

    FPushServ             : TPushService;
    FPushServConn         : TPushServiceConnection;
    FDeviceID,
    FDeviceToken          : String;
    FMesaj                : pIcerik;
    procedure  FOnReceiveNotificationEvent( Sender: TObject;
                                      const ANotification: TPushServiceNotification );
    procedure  FOnPushServConnChangeEvent ( Sender: TObject;
                                            PushChanges: TPushService.TChanges );
    procedure  FSetGCMappId ( strGCM_ID: String );
    procedure  FMesajParse  ( ANotification: TPushServiceNotification );
    procedure  FSetActive   ( aDurum:Boolean    );
    function   FGetActive : boolean;
    procedure  FPushServActivate;
    procedure  FPushServPassive;

    procedure  FPushServiceInit;
    procedure  FPushServiceFree;
  {$ENDIF}
{$ENDREGION 'MSWINDOWS Bölümü'}

{$REGION 'MSWINDOWS Bölümü'}
  {$IF defined(MSWINDOWS)}
  Private
  Var
    FMemo                 : StdCtrls.TMemo;
  {$ENDIF}
{$ENDREGION 'MSWINDOWS Bölümü'}
  private
    function    AradanSec( var strIcerik: String; strBas, strSon: String; boolTrim:boolean=false ): string;
    procedure   LogLa( strIcerik: String );
  public
    constructor Create;
    destructor  Destroy; Override;
    property    API_Key         : string read FApiKey      write FApiKey;
    property    NotifyTitle     : string read FNotifyTitle write FNotifyTitle;
    property    PHPRegisterHost : String read FPhpPush     write FPhpPush;
    function    PushMessage( strMesaj, strMesajID: String; boolSecure:Boolean = false ): String;

{$REGION 'MSWINDOWS Bölümü'}
  {$IF defined(MSWINDOWS)}
  Public
    Property    LogMemo         : StdCtrls.TMemo  read FMemo        write FMemo;
  {$ENDIF}
{$ENDREGION 'MSWINDOWS Bölümü'}

{$REGION 'ANDROID Bölümü'}
  {$IF defined(ANDROID)}
  Private
  Public
    property    GCM_ID      : string write FSetGCMappId; //read FGCM_ID Write FGCM_ID;
    Property    LogMemo         : FMX.TMemo  read FMemo        write FMemo;
    property    OnReceiveNotification     : TOnEvent01 read FOnReceiveNotification write FOnReceiveNotification;
    property    OnServiceConnectionChange : TOnEvent02 read FOnServConnChange      write FOnServConnChange;
    property    OnRegistrationError       : TOnEvent03 read FOnRegisError          write FOnRegisError;
    function    PHPRegisterDevice( DeviceID : string; DeviceToken : string ): boolean;

    property    GelenMesaj  : pIcerik read FMesaj;
    property    Active      : boolean read FGetActive write FSetActive;
    property    DeviceID    : String  read FDeviceID;
    property    DeviceToken : String  read FDeviceToken;
    procedure   LocalAndroidNotification( aName, aMessageText: string; aNotificationNumber: integer; aSaniyeSonra:Integer = -1);
    function    StartUpNotifications: String;
  {$ENDIF}
{$ENDREGION 'ANDROID Bölümü'}

  end;

Var
  xGCMHelper : TGCM_Helper;

implementation

{$IF defined(MSWINDOWS)}
  {$R RES\RES.RES} // SSL DLL'leri Resource olarak saklanacak...
{$ENDIF}

constructor TGCM_Helper.Create;
begin
  Inherited;  // Create'de  daima başta call edeceğiz...
{$IF defined(ANDROID)}
  FPushServiceInit;
{$ENDIF}
  //...
end;

destructor  TGCM_Helper.Destroy;
begin
  //...
{$IF defined(ANDROID)}
  FPushServiceFree;
{$ENDIF}
  Inherited;  // Destroy'da daima sonda call edeceğiz...
end;

{$REGION 'ANDROID Bölümü'}

{$IF defined(ANDROID)}
function   TGCM_Helper.FGetActive : boolean;
begin
  Result := FPushServConn.Active;
end;

procedure TGCM_Helper.FPushServActivate;
begin
  System.Threading.TTask.Run(procedure
  begin
    FPushServConn.Active := True;
  end);
end;

procedure TGCM_Helper.FPushServPassive;
begin
  System.Threading.TTask.Run(procedure
  begin
    FPushServConn.Active := False;
    TThread.Synchronize( nil, procedure
    begin
      FDeviceID    := '';
      FDeviceToken := '';
    end                );
  end);
end;

procedure  TGCM_Helper.FSetActive( aDurum:Boolean );
begin
  if (FPushServConn <> nil) and (aDurum = FPushServConn.Active)
    then Exit; // Aynı State olduğundan işleme gerek yok...

  Case aDurum of
  true  : begin
          //FPushServConn.Active := True; // Firebase'de başka bir Thread'de olmalı...
            FPushServActivate;
          end;
  false : begin
            FPushServPassive;
          end;
  end;
end;

procedure TGCM_Helper.FPushServiceInit;
begin
  if FNotifyTitle = '' then FNotifyTitle := 'ARMAN Bilgi Merkezi';

  FPushServ           := TPushServiceManager.Instance.GetServiceByName( TPushService.TServiceNames.GCM );
  FPushServConn       := TPushServiceConnection.Create( FPushServ );
  FPushServConn.OnChange              := FOnPushServConnChangeEvent;
  FPushServConn.OnReceiveNotification := FOnReceiveNotificationEvent;
end;

procedure TGCM_Helper.FPushServiceFree;
begin
  FPushServConn.Free;
  FPushServ.Free;
end;

procedure TGCM_Helper.FMesajParse( ANotification: TPushServiceNotification );
begin
  if Assigned( FMesaj ) then Dispose( FMesaj );
  New( FMesaj );
  FMesaj.strSent_time    := ANotification.Json.GetValue('google.sent_time').Value;
  FMesaj.strId           := ANotification.Json.GetValue('id').Value;
  FMesaj.strFrom         := ANotification.Json.GetValue('from').Value;
  FMesaj.strMessage_id   := ANotification.Json.GetValue('google.message_id').Value;
  FMesaj.strMessage      := ANotification.Json.GetValue('message').Value;
  FMesaj.strCollapse_key := ANotification.Json.GetValue('collapse_key').Value;
end;

procedure TGCM_Helper.FOnPushServConnChangeEvent (Sender: TObject; PushChanges: TPushService.TChanges);
begin
  if TPushService.TChange.DeviceToken in PushChanges
    then FDeviceToken := FPushServ.DeviceTokenValue[TPushService.TDeviceTokenNames.DeviceToken];

  if FPushServConn.Active then
  begin
    FDeviceID    := FPushServ.DeviceIDValue[ TPushService.TDeviceIDNames.DeviceID ];
LogLa( 'DeviceID    : ' + FDeviceID );
LogLa( 'DeviceToken : ' + FDeviceTOKEN );
  end;

  if    (FDeviceID    <> '')
    AND (FDeviceToken <> '')
    AND (FPhpPush     <> '')
  then begin
    if PHPRegisterDevice( FDeviceID, FDeviceToken )
      then LogLa( 'PHP Registered :) with DeviceToken : ' + FDeviceToken )
      else LogLa( 'PHP Register kısmında bir sorun oldu...' );
  end else begin
LogLa( 'DeviceID, DeviceToken veya PHPPush URL boş geldi... Device kaydedilemedi... :(' );
  end;

  if Assigned(OnServiceConnectionChange) then // tests if the event is assigned
  begin
    TThread.Synchronize( nil, procedure
    begin
      FOnServConnChange( Self, FDeviceID, FDeviceToken );
    end                );
  end;
end;

procedure TGCM_Helper.FSetGCMappId(strGCM_ID: string);
begin
  FGCM_ID := strGCM_ID;
  FPushServ.AppProps[ TPushService.TAppPropNames.GCMAppID ] := FGCM_ID;  // GCM App ID
end;

procedure TGCM_Helper.FOnReceiveNotificationEvent(Sender: TObject;
  const ANotification: TPushServiceNotification);
begin
  if Assigned( OnReceiveNotification ) then // tests if the event is assigned
  begin
    FMesajParse( ANotification );

 // Pencere açıkken Push bildirim alınıyor ancak System Tray'e gelmiyor...
 //   Biz kendimiz manuel eklesek mi ? .. dedim :)

 // Aşağıdaki (//) Remark kaldırırsanız gelen notification'u Local'den
 // kendimiz yayınlayarak sanki Push mesaj gelmiş gibi bir illüzyon yaratır.

 // LocalAndroidNotification( FMesaj.strMessage, 0 );

    TThread.Synchronize( nil, procedure
    begin
      FOnReceiveNotification( Sender, FMesaj.strSent_time, FMesaj.strId, FMesaj.strFrom, FMesaj.strMessage_id, FMesaj.strMessage, FMesaj.strCollapse_key ); // calls the event.
    end                );
  end;
end;

procedure TGCM_Helper.LocalAndroidNotification( aName, aMessageText: string; aNotificationNumber: integer; aSaniyeSonra:Integer = -1);
var
  NotificationCenter  : TNotificationCenter;
  Notification        : TNotification;
begin
  // USES'da FMX.PushNotification.Android olmazsa çakılıyor...
  NotificationCenter  := TNotificationCenter.Create(nil);
  try
    Notification      := NotificationCenter.CreateNotification;
    try
      Notification.Name         := aName;
      Notification.AlertBody    := aMessageText;
      Notification.Title        := aMessageText;
      Notification.EnableSound  := True;
      Notification.Number       := aNotificationNumber;
      NotificationCenter.ApplicationIconBadgeNumber := aNotificationNumber;

      if aSaniyeSonra < 0 then begin
        // Hemen Yayınlansın
        NotificationCenter.PresentNotification( Notification );
      end else
      begin
        // (n) SaniyeSonra kadar saniye bekledikten sonra yayına çıksın
        Notification.FireDate   := Now + EncodeTime(0, 0, aSaniyeSonra, 0);
        NotificationCenter.ScheduleNotification( Notification );
      end;
    finally
      Notification.DisposeOf;
    end;
  finally
    NotificationCenter.Free;
    NotificationCenter.DisposeOf;
  end;
end;

function TGCM_Helper.StartUpNotifications: String;
var
  LNotification : TPushServiceNotification;
  MessageText   : String;
begin
  for LNotification in FPushServConn.Service.StartupNotifications do
  begin
    if Assigned(LNotification) and (LNotification.Json.ToString <> '') then
    begin
      Result := 'Notification Tıklanınca Geldik : '
                + #13 + '  SentTime: '     + LNotification.Json.GetValue('google.sent_time').Value
                + #13 + '  Id: '           + LNotification.Json.GetValue('id').Value
                + #13 + '  From: '         + LNotification.Json.GetValue('from').Value
                + #13 + '  MessageId: '    + LNotification.Json.GetValue('google.message_id').Value
                + #13 + '  Message: '      + LNotification.Json.GetValue('message').Value
                + #13 + '  Collapse_key: ' + LNotification.Json.GetValue('collapse_key').Value;
//      Result := 'Notification Tıklanınca Geldik : '
//                + #13 + '  Message: '      + LNotification.Json.GetValue('message').Value
//                + #13 + '  Id: '           + LNotification.Json.GetValue('id').Value;
      //MessageText := LNotification.Json.ToString;
      //LogLa( DateTimeToStr(Now) + ' Message = ' + MessageText );
    end;
  end;

  // System Tray'de biriken mesajların hepsini okuyabilmeyi istedim ama olmadı...
  // Temizlik Vakti.
  With TNotificationCenter.Create(nil)
  do
    try
      CancelAll;
    finally
      Free;
      DisposeOf;
    end;
end;

function TGCM_Helper.PHPRegisterDevice(DeviceID : string; DeviceToken : string): boolean;
var
  slPostData: TStringList;
  IdHttp    : TIdHTTP;
begin
  Result := False;
  if FPhpPush <> '' then
  begin
    FPhpPush := Trim(FPhpPush);
    if FPhpPush[length(FPhpPush)-1] <> '/' // ZeroBased
         then FPhpPush := FPhpPush + '/';

    IdHttp     := TIdHTTP.Create;
    slPostData := TStringList.Create;
    try
      slPostData.Add('action=regdevice');
      slPostData.Add('did='   + DeviceID     );
      slPostData.Add('token=' + DeviceToken  );
      {$ifdef ANDROID}
        slPostData.Add('platform=android');
      {$else}
        slPostData.Add('platform=ios');
      {$endif}
      IdHttp.Post( FPHPPush + 'index.php', slPostData );
      Result := True;
    finally
      slPostData.Free;
      IdHttp.Disconnect;
      IdHttp.DisposeOf;
    end;
  end;
end;

{$ENDIF}
{$ENDREGION 'ANDROID Bölümü'}

{$REGION 'WINDOWS Bölümü'}

{$IF defined(MSWINDOWS)}
function SetDllDirectory(lpPathName:PWideChar): Bool; stdcall; external 'kernel32.dll' name 'SetDllDirectoryW';
{$ENDIF}

{$ENDREGION 'Windows Bölümü'}

{$REGION 'ORTAK Fonksiyonlar'}

function TGCM_Helper.AradanSec(var strIcerik: String; strBas, strSon: String; boolTrim:boolean=false ): string;
Var
  strOrjKaynak : String;
begin
  Result := '';
  strOrjKaynak := strIcerik;
  if Pos( strBas, strIcerik ) > 0 then
  begin
    System.Delete( strIcerik, 1, Pos( strBas, strIcerik )+ Length( strBas )-1 );
    if strSon <> ''
      then Result := Trim( Copy(strIcerik, 1, Pos( strSon, StrIcerik ) -1) )
      else Result := Trim( strIcerik );
  end;
  if NOT boolTrim then strIcerik := strOrjKaynak;
end;

procedure TGCM_Helper.LogLa( strIcerik: String );
begin
  if FMemo <> nil then
  begin
    Classes.TThread.Synchronize(nil,
      procedure
      begin
        FMemo.Lines.Add( strIcerik );
      end
    );
  end;
end;

function TGCM_Helper.PushMessage( strMesaj, strMesajID: String; boolSecure:Boolean = false ): String;
{$IF defined(MSWINDOWS)}
  function GetTempDir: string;
  var
    TempDir:     DWORD;
  begin
    SetLength(Result, MAX_PATH);
    TempDir := GetTempPath(MAX_PATH, PChar(Result));
    SetLength(Result, TempDir);
  end;

  function IsFileInUse(fName: string) : boolean;
  var
    HFileRes: HFILE;
  begin
    Result := False;
    if not FileExists(fName) then begin
      Exit;
    end;

    HFileRes := CreateFile(PChar(fName)
      ,GENERIC_READ or GENERIC_WRITE
      ,0
      ,nil
      ,OPEN_EXISTING
      ,FILE_ATTRIBUTE_NORMAL
      ,0);

    Result := (HFileRes = INVALID_HANDLE_VALUE);

    if not(Result) then begin
      CloseHandle(HFileRes);
    end;
  end;
{$ENDIF}
var
  idHTTP       : TIDHTTP;
  strJson      : String;
  JsonStream   : Classes.TStringStream;
  strGelen     : String;
  DeviceList   : TStringList;
{$IF defined(MSWINDOWS)}
  SslIOHandler : TIdSSLIOHandlerSocketOpenSSL;
{$ENDIF}
{$IFDEF SSL_DLLs_inResourceMode}
  a,b : Integer;
{$ENDIF}
begin
  if FApiKey <> '' then
  begin
    FPhpPush := Trim(FPhpPush);
    if FPhpPush[length(FPhpPush)-1] <> '/' // ZeroBased
           then FPhpPush := FPhpPush + '/';

    DeviceList := TStringList.Create;
    IdHTTP := TIdHTTP.Create(nil);
    try
      IdHTTP.Name                := 'IdHTTP';
      IdHTTP.AllowCookies        :=  True;
      IdHTTP.HandleRedirects     :=  True;
      IdHTTP.HTTPOptions         := [hoForceEncodeParams];
      IdHTTP.Request.ContentType := 'application/xml';
      IdHttp.Request.CharSet     := 'UTF-8';
      IdHTTP.Response.KeepAlive  :=  False;
      strGelen := IdHTTP.Get( FPhpPush + 'index.php?action=tokenlist' );
      while Pos('<deviceToken>', strGelen) > 0 do begin
        DeviceList.Add( AradanSec( strGelen, '<deviceToken>', '</deviceToken>', True ) );
      end;
      strJson := '{'
                +'   "priority": "normal", '
                +'   "registration_ids":'
                +'   [';
                       while DeviceList.Count > 0 do
                       begin
                         strJson := strJson + '"' + DeviceList[0] + '"';
                         DeviceList.Delete(0);
                         if DeviceList.Count > 0
                           then strJson := strJson + ',';
                       end;
      strJson := strJson
                +'   ],'
                +'   "notification": {' // notification mesaj tipi
                +'       "body": "'  + strMesaj   + '",'
                +'       "title": "' + strMesajID + '",'
                +'       "icon" : "'+FPhpPush+'mesaj.png",'
                +'       "color": "#f45342"'
                +'   },'
                +'   "data": {' // data mesaj tipi
                +'     "id": "'      + strMesajID + '",'
                +'     "message": "' + strMesaj   + '",'
                +'     "site_adi": "armanlab.com",'
                +'     "link": "http://www.armanlab.com"'
                +'   },'
                +'   "collapse_key": "Bilgi_Mesaj"'
                +'}'
                ;
      {$IF CompilerVersion >= 22.0}  // XE
        JsonStream := TStringStream.Create(strJson, TEncoding.UTF8);
      {$ELSE} //D2007 ve öncesi için
        JsonStream := TStringStream.Create( Utf8Encode(strJson) );
      {$IFEND}
      try
        if boolSecure then
        begin // HTTPS erişim yapılacak... OpenSSL kütüphaneleri Gerekli.
          {$IFDEF SSL_DLLs_inResourceMode}
          // SSL Kütüphaneleri lisans sorunu yaratmasın diye RESOURCE altından çıkardım.
          {$IF CompilerVersion >= 22.0} a := 3; b := 4;  // XE
          {$ELSE}                       a := 1; b := 2;  // D7 = 15.0
          {$IFEND}
            if NOT IsFileInUse( GetTempDir + 'ssleay32.dll' ) then
              With TResourceStream.Create(HInstance, Format('ssl_%.2d', [a]), RT_RCDATA) do
              begin
                Try
                  SaveToFile( GetTempDir + 'ssleay32.dll' );
                finally
                  free;
                end;
              end;

            if NOT IsFileInUse( GetTempDir + 'libeay32.dll' ) then
              With TResourceStream.Create(HInstance, Format('ssl_%.2d', [b]), RT_RCDATA) do
              begin
                Try
                  SaveToFile( GetTempDir + 'libeay32.dll' );
                finally
                  free;
                end;
              end;
         // Bendeki Indy sürümü ile uyumsuzdu... Alttaki şekilde değiştirdim...
         // IdSSLOpenSSLHeaders.IdOpenSSLSetLibPath( GetTempDir );
         // IdSSLOpenSSLHeaders.Load;

         // SSL DLL'lerini RES içinden TempDir'e aldık...
            SetDllDirectory( StringToOLEStr(GetTempDir) );
        {$ENDIF}
{$IF defined(MSWINDOWS)}
          SslIOHandler        := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
          IdHTTP.IOHandler    := SSLIOHandler;
{$ENDIF}
        end else begin
          IdHTTP.IOHandler    := nil;
        end;
        IdHTTP.HTTPOptions  := [];
        if boolSecure
          then IdHTTP.Request.Host := GCM_SecureUrl
          else idHTTP.Request.Host := GCM_OpenUrl;
        IdHttp.Request.CustomHeaders.AddValue('Authorization', 'key=' + FAPIKey );
        IdHTTP.Request.ContentType := 'application/json'; // Plain Text için 'application/x-www-form-urlencoded;charset=UTF-8'
        IdHTTP.Request.CharSet     := 'utf-8';
LogLa( idHTTP.Request.Host );
LogLa( JsonStream.DataString );
        Result := IdHTTP.Post(idHTTP.Request.Host, JsonStream);
      finally
        JsonStream.Free;
      end;
    finally
{$IF defined(MSWINDOWS)}
      if boolSecure then FreeAndNil(SslIOHandler);
{$ENDIF}
      FreeAndNil(IdHTTP);
      DeviceList.Free;
    end;
  end else begin
    Result := 'Google API Key girilmemiş...';
  end;
end;

{$ENDREGION 'ORTAK Fonksiyonlar'}

initialization
  xGCMHelper := TGCM_Helper.Create;

finalization
  FreeAndNil(xGCMHelper);

end.
