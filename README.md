# rpi-inhot
Easy setup your Raspberry Pi as a fully functional hotspot with Internet access and TOR routing for secure browsing

You'll need 2 usb wifi dongles for this to work.

The standard configuration will create a new wireless network called "rpi-hotspot" with the password "wifipass". You can change the parameter “ssid=rpi-hotspot” to the SSID wifi name you want and the parameter “wpa_passphrase=wifipass” to your own password by modifying the hostapd.conf file before running the script:
  
To connect to any wifi simply change the following arguments on the /etc/network/interfaces file:
    allow-hotplug wlan1
    iface wlan1 inet dhcp
      wpa-ssid "ssidnetwork"
      wpa-psk "password"



