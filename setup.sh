#!/bin/bash

clear
sleep 1

echo "This script will setup your Raspberry Pi as a fully functional hotspot with Internet access and TOR routing for secure browsing"
read -r -p "Did you modify your configuration files? [Y/n] " input

case $input in
    [yY][eE][sS]|[yY]) 
      echo "Starting setup"
      sleep 1
    
      echo "Updating repositories"
      sudo apt-get -y update
      sudo apt-get -y rpi-update
      sleep 1

      echo "Upgrading system"
      sudo apt-get -y upgrade
      sudo apt-get -y dist-upgrade
      sleep 1

      echo "Cleaning packages"
      sudo apt-get -y autoclean
      sudo apt-get -y autoremove
      sleep 1

      echo "Installing hostapd and isc-dhcp-server packages"
      sudo apt-get install isc-dhcp-server
      wget https://github.com/jenssegers/RTL8188-hostapd/archive/v1.1.tar.gz
      tar -zxvf v1.1.tar.gz
      cd RTL8188-hostapd-1.1/hostapd
      sudo make
      sudo make install
      sleep 1

      echo "Moving configuration files"
      cd ~/rpi-inhot
      sudo rm -rf /etc/dhcp/dhcpd.conf
      sudo cp dhcp.conf /etc/dhcp/
      sudo rm -rf /etc/default/isc-dhcp-server
      sudo cp isc-dhcp-server /etc/default/
      sudo ifdown wlan0
      sudo rm -rf /etc/network/interfaces
      sudo cp interfaces /etc/network/
      sudo rm -rf /etc/sysctl.conf
      sudo cp sysctl.conf /etc/
      sleep 1

      echo "Backing up NAT configuration"
      sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
      sleep 1

      echo "Starting wireless network"
      sudo ifdown wlan0
      sudo ifup wlan0
      sudo ifdown wlan1
      sudo ifup wlan1
      sleep 1

      echo "Setting up routing"
      sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
      sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
      sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
      sudo iptables -t nat -A POSTROUTING -o wlan1 -j MASQUERADE
      sudo iptables -A FORWARD -i wlan1 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
      sudo iptables -A FORWARD -i wlan0 -o wlan1 -j ACCEPT
      sleep 1

      echo "Starting hotspot and dhcp server"
      sudo service isc-dhcp-server start
      sudo service hostapd start
      sudo systemctl enable isc-dhcp-server
      sudo systemctl enable hostapd
      sleep 1

      echo "Backing up NAT configuration"
      sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
      sleep 1

      echo "Installing TOR"
      sudo apt-get -y install tor
      sleep 1

      echo "Starting TOR networking"
      sudo service tor start
      sudo systemctl enable tor

      echo "All done!"
      sleep 2
      
      echo "Use sudo reboot command to make changes work"
      sleep 2
      
      echo "Remember you can always change your wifi connection by simply modifying the arguments "ssidnetwork" and "password" on /etc/network/interfaces file"
      sleep 2

      echo "To see connected devices on your Pi use the arp command: sudo arp –i wlan0"
      sleep 2
      
      ;;
    
    [nN][oO]|[nN])
      echo "No"
      ;;

    *)
      echo "Invalid input..."
      exit 1
      ;;
esac
