<?php
  include("ctrl.include.php");
 $veri[1] = "DROP TABLE devices";
 $veri[2] = "DROP TABLE messages";
 if ( @mysql_query( $veri[1] ) )
 { echo "Tablomuz 'devices' Silindi...<br>"; }
 else
 { echo "HATA: Tablo silme iþlemi baþarýsýz oldu...<br>"; }

 if ( @mysql_query( $veri[2] ) )
 { echo "Tablomuz 'messages' Silindi...<br>"; }
 else
 { echo "HATA: Tablo silme iþlemi baþarýsýz oldu...<br>"; }
?>