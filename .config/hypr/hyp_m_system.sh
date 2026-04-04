#!/bin/bash

opt=$1

if [ "$opt" = "-m" ]; then
  notify-send -a test2 "$(figlet -c -f Fraktur system)" "u update system (arch-update)\nm update mirrors (rate-mirrors)\ns manage snapshots (btrfs-assistant)\nc clean system (moonbit)\nb Monitor system (btm)\nesc exit menu"
  exit
fi

makoctl dismiss -a
hyprctl dispatch submap reset
sleep .1

case $opt in
"-u")
  kitty --title yazi -e ~/.config/hypr/hyp_update.sh >/dev/null &
  ;;
"-mi")
  kitty --title yazi -e rate-mirrors arch
  notify-send "rate-mirrors" "update has been finished"
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -update >/dev/null 2>&1 &
  exit
  ;;
"-s")
  sleep 0.1
  ;;
"-c")
  kitty --title moonbit -e moonbit
  exit
  ;;
"-b")
  kitty --title yazi -e btm
  sleep 0.1
  exit
  ;;
"-q")
  exit
  ;;
esac
