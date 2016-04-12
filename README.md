# rpi-inhot
Easy setup your Raspberry Pi as a fully functional hotspot with Internet access and TOR routing for secure browsing

You'll need 2 usb wifi dongles for this to work.

Give permissions to the script with the command "sudo chmod 777 setup.sh" and then run it by using "./setup.sh"

The standard configuration will create a new wireless network called "rpi-hotspot" with the password "wifipass". You can change the parameter “ssid=rpi-hotspot” to the SSID wifi name you want and the parameter “wpa_passphrase=wifipass” to your own password by modifying hostapd.conf
  
To connect to any wifi simply change the arguments "ssidnetwork" and "password" at wlan1 lines on the interfaces file



