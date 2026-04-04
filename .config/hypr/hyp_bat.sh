#!/bin/bash

bat_power=$(cat /sys/class/power_supply/BAT0/capacity)
bat_state=$(cat /sys/class/power_supply/BAT0/status)
tom=75
border=25
crit=15

if [[ "$bat_power" -gt "$tom" || "$bat_power" -lt "$crit" ]]; then
  notify-send -a m_stat -c hyp_bat_red "BATTERY" "$(figlet -f Fraktur $bat_power%)"
  #notify-send -a hy_bat -c bat_red "$bat_power%"

  if [[ "$bat_power" = "Discharging" ]]; then
    notify-send "Low battery!" "Connect the adapter"
  else
    notify-send "Battery overcharging!" "Disconnect the adapter"
  fi

elif [[ "$bat_power" -gt "$crit" && "$bat_power" -lt "$border" ]]; then
  notify-send -a m_stat -c hyp_bat_yellow "BATTERY" "$(figlet -f Fraktur $bat_power%)"
  #notify-send -a hy_bat -c bat_yellow "$bat_power%"

else
  notify-send -a m_stat -c hyp_bat_green "BATTERY" "$(figlet -f Fraktur $bat_power%)"
  #notify-send -a hy_bat -c bat_green "$bat_power%"

fi
