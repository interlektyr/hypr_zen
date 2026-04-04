#!/bin/bash

#ex hyp_win jump 2

operation=$1
workspace_id=$2

show_ws_2() {
  activwsnb=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
  getcritb="hyp_wsb$activwsnb"

  notify-send -a m_stat -c $getcritb "WORKSPACE" "$(figlet -f Fraktur $activwsnb)"

}

show_ws() {
  activwsn=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
  getcrit="wsa$activwsn"

  case $activwsn in
  1) wso="         " ;;
  2) wso="         " ;;
  3) wso="         " ;;
  4) wso="         " ;;
  5) wso="         " ;;
  6) wso="         " ;;
  7) wso="         " ;;
  8) wso="         " ;;
  9) wso="         " ;;
  10) wso="         " ;;
  esac

  #notify-send -a hy_ws -c $getcrit "$activwsn"
  notify-send -a hy_ws -c $getcrit "$wso"
}

set_wall() {

  activws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')

  case $activws in

  1)
    awww img --transition-type fade ~/.config/hypr/wallpapers/1.jpg
    ;;

  2)
    awww img --transition-type fade ~/.config/hypr/wallpapers/2.jpg
    ;;

  3)
    awww img --transition-type fade ~/.config/hypr/wallpapers/3.jpg
    ;;

  4)
    awww img --transition-type fade ~/.config/hypr/wallpapers/4.jpg
    ;;

  5)
    awww img --transition-type fade ~.config/hypr/wallpapers/5.png
    ;;

  6)
    awww img --transition-type fade ~/.config/hypr/wallpapers/6.jpg
    ;;

  7)
    awww img --transition-type fade ~/.config/hypr/wallpapers/7.jpg
    ;;

  8)
    awww img --transition-type fade ~/.config/hypr/wallpapers/8.jpg
    ;;

  9)
    awww img --transition-type fade ~/.config/hypr/wallpapers/9.jpg
    ;;

  10)
    awww img --transition-type fade ~/.config/hypr/wallpapers/0.jpg
    ;;

  *) ;;
  esac

}

if [[ $operation == "jump" ]]; then
  hyprctl dispatch workspace $workspace_id
  set_wall
  show_ws
  exit
fi

if [[ $operation == "move" ]]; then
  hyprctl dispatch movetoworkspace $workspace_id
  set_wall
  show_ws
  exit
fi

if [[ $operation == "f" ]]; then
  currw=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
  neww=$(($currw + 1))

  if [[ $neww == "11" ]]; then
    hyprctl dispatch workspace 1
  else
    hyprctl dispatch workspace $neww
  fi

  set_wall
  show_ws
  exit
fi

if [[ $operation == "b" ]]; then
  currw=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
  neww=$(($currw - 1))

  if [[ $neww == "0" ]]; then
    hyprctl dispatch workspace 10
  else
    hyprctl dispatch workspace $neww
  fi

  set_wall
  show_ws
  exit
fi

if [[ $operation == "show" ]]; then
  show_ws_2
  exit
fi

if [[ $operation == "d" ]]; then
#	echo $mon $activws
fi
