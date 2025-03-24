#!/bin/sh

nmcli device wifi list

read -p "Enter SSID: " ssid
read -p "Enter password: " pass

nmcli device wifi connect "${ssid}" password "${pass}"
