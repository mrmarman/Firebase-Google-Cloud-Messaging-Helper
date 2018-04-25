<?php
  // Veritabaný Baðlantý Bilgileri ve Global Deðiþkenler
    include("ctrl.include.php");

  // Lazým olabilecek bilgi...
    $domain = getenv('REMOTE_ADDR');

  // "action" parametresine göre hangi fonksiyonun çalýþacaðýna karar verilecek.
	if (isset($_REQUEST['action'])) {
    switch ($_REQUEST['action']) {
      case 'regdevice':
        RegisterDevice($_REQUEST['did'], $_REQUEST['token'], $_REQUEST['platform'] );
        break;
      case 'sendmsg':
        SendPush($_REQUEST['msgText'], $_REQUEST['msgId'], $serverAPIKey, $sendUrl);
        break;
      case 'tokenlist':
        DeviceList();
        break;
      case 'arman':
        SendPushARMAN( $serverAPIKey, $sendUrl );
        break;
      default:
        DeviceList();
        break;
    }
  }
  else
	{
	  DeviceList(); //echo '"action" parametreniz uygun deðil.<br>Herhangi bir iþlem yapýlmadý !';
	}

//  Mob.Cihaz TokenID'yi db'ye yaz, varsa tarih güncelle
// -----------------------------------------------------
    function RegisterDevice($deviceId, $deviceToken, $platform)
    {
      $sorgu  = ""
                ."INSERT INTO devices"
                ." (deviceID, deviceToken, devicePlatform)"
                ." VALUES"
                ." ( '$deviceId', '$deviceToken', '$platform' )"
                ." ON DUPLICATE KEY UPDATE deviceLastDate=now()"
                .";";
       echo $sorgu."<br>";
      if ( @mysql_query( $sorgu ) )
        { echo "ok"; }
        else
        { echo "error_RegDevice"; }
    }

//  Notification Gönderim Operasyonu
// -----------------------------------------------------
    function SendPush($msgText, $msgId, $APIKey, $Url)
    {
      $headers      = array ( 'Authorization: key='.$APIKey,
                              'Content-Type : application/json'
                            );

      $notification = array (
      'body'      => $msgText,
      'title'     => $msgId,
      'icon'      => 'http://www.armanlab.com/GoogleCloudMes/mesaj.png',
      'color'     => '#f45342'
      );

      $data  = array (
      'id'         => $msgId,
      'message'    => $msgText,
      'site_adi'   => 'armanlab.com',
      'link'       => 'http://www.armanlab.com'
      );

      $fields = array (
      'priority'         => 'normal',
      'registration_ids' => getRegistrationIds(),
      'collapse_key'     => 'Bilgi_Mesaj',
      'notification'     => $notification,
      'data'             => $data
      );

      // Baðlantýyý Hazýrladýk
      $ch = curl_init();

      // Hazýrlanan baðlantýya url, POST variables ile POST data'yý set ettik
      curl_setopt($ch, CURLOPT_URL,            $Url);
      curl_setopt($ch, CURLOPT_POST,           true);
      curl_setopt($ch, CURLOPT_HTTPHEADER,     $headers);
      curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

      // Geçici olarak SSL sertifika desteðini kapattýk çünkü burada gerek yok
      curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
      curl_setopt($ch, CURLOPT_POSTFIELDS,     json_encode($fields));

      // post iþlemini yaptýk
      $result = curl_exec($ch);

      if ($result === FALSE) {
          die('Curl failed: ' . curl_error($ch));
      } else {
          print_r( "<br>".$result."<br>" );
      }
    // Baðlantýmýzý kapattýk
    curl_close($ch);

    // Gönderdiðimiz Mesajý LOG'layalým
      $sorgu  = ""
                ."INSERT INTO messages"
                ." (MessageText, MessResult)"
                ." VALUES"
                ." ( '$msgText', '$result' )"
                .";";
        // echo $sorgu."<br>";
        if ( @mysql_query( $sorgu ) )
          { echo "ok"; }
          else
          { echo "error_MesLog"; }
      }

//  DeviceID'ye göre gruplandýrýlmýþ en son TokenID'ler
// -----------------------------------------------------
    function getRegistrationIds()
    {
      $sorgu  = ""
                ."SELECT id, deviceID, deviceToken"
                ." FROM devices"
                ." WHERE id IN ("
                ."    SELECT MAX(id)"
                ."    FROM devices"
                ."    GROUP BY deviceID"
                ." );";
      $sonuc        =  mysql_query( $sorgu );
      $result_array = array();
      while($row = mysql_fetch_assoc($sonuc ))
      {
        $result_array[] = $row['deviceToken'];
      }
      return $result_array;
    }

    function DeviceList()
    {
      $sorgu  = ""
         ."SELECT id, deviceID, deviceToken, devicePlatform, deviceSignDate, deviceLastDate"
         ." FROM devices"
         ." WHERE id IN ("
         ."    SELECT MAX(id)"
         ."    FROM devices"
         ."    GROUP BY deviceID"
         ." );";
      //$sorgu  = "SELECT deviceID, deviceToken FROM devices;";
      //echo $sorgu."<br>";
      $sonuc  =  mysql_query( $sorgu );
      $xsql   = 'select';

      if (!$sonuc)
           { $sayi = -1; }
      else { $sayi = mysql_num_rows($sonuc); }
      //echo "SQL Query : ".$sorgu."<br>";
      //echo "Rec Count : ".$sayi."<br>";

      if ( $sayi > 0 )
      {
        $Result = "<?xml version='1.0' encoding='utf-8'?>\n<arman>\n";
        while($data = mysql_fetch_assoc($sonuc)) {
          $Result .= " <rec>\n";
          foreach($data as $key => $value) {
            $Result .=  "  <$key>$value</$key>\n"."<br>";
          }
            $Result .= " </rec>\n"."<br>";
        }
        $Result .= "</arman>\n";
        echo $Result;
      }
    }
?>