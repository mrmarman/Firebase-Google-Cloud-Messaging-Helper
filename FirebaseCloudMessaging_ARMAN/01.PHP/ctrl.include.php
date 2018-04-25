<?php
/* Firebase Google Server GCM API Key */
  $serverPCK    = 'com.DelphiCan.Uygulamasi.android';
  $senderId     = '508552148797';
  $serverAPIKey = 'AAAAdmgR9z0:APA91bEmBy1XPje24KoigMKC_o26IkflWWZYsDhokjA5E5j3ru6z5JO4V-kR12n1anHmnQH8FkKS8Pqvz1M7uf-XjL5aG7G4ktMRUbSCJ2UePtpF3-iNk-ed_LYLd-pFDe1-sI61iLif';
  $sendUrl      = 'https://fcm.googleapis.com/fcm/send';
 
/* Database host */
  $dbhost = "localhost";

/* Database name */
  $dbname = "armanDB";

/* Database username and password */
  $dblogin= "armanUSER";
  $dbpass = "parola12345";

  $failure = "MySQL problemi. ".$dbhost." baðlantýsý yapýlamadý.";

if(!$connect = @mysql_connect($dbhost, $dblogin, $dbpass)) {
	die($failure);
} else {
	if(!@mysql_select_db($dbname,$connect)) {
		die($failure);
	}
}
// diðer türlü baðlantý saðlanmýþ demektir.
  $dbtable = $dbname;
?>