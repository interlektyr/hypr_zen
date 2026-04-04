#!/bin/bash

opt=$1

if [ "$opt" = "-m" ]; then
  notify-send -a test2 "$(figlet -c -f Fraktur power)" "l lock\ne exit/log out\ns shut down\nr reboot\nf reboot into firmware\nesc exit menu"
  exit
fi

makoctl dismiss -a
hyprctl dispatch submap reset
sleep .1

case $opt in
"-l")
  hyprlock
  ;;
"-e")
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pl >/dev/null 2>&1 &
  sleep 0.1
  ;;
"-s")
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -ps >/dev/null 2>&1 &
  sleep 0.1
  ;;
"-r")
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pr >/dev/null 2>&1 &
  sleep 0.1
  exit
  ;;
"-f")
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pf >/dev/null 2>&1 &
  sleep 0.1
  exit
  ;;
"-q")
  exit
  ;;
esac
