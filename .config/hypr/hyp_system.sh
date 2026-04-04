#!/bin/bash

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:smenu >/dev/null 2>&1

val=$(
  echo -e "enter select  esc exit\nUpdate system (arch-update)\nUpdate mirrors (rate-mirrors)\nManage snapshots (btrfs-assistant)\nClean system (moonbit)\nMonitor system (btm)" | fzf --info=hidden \
    --header-lines=1 --color=pointer:magenta --color=border:'#232A2C' --color=bg+:#232A2C,bg:#232A2C \
    --footer="System" --color=footer:italic:yellow --header-border=line --footer-border=line --accept-nth={n}
)

case $val in
1)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e ~/.config/hypr/hyp_update.sh >/dev/null 2>&1 &
  sleep 0.1
  hyprctl dispatch closewindow title:smenu
  exit
  ;;
2)
  hyprctl dispatch movetoworkspacesilent special:stash
  kitty --title yazi -e rate-mirrors arch
  notify-send "rate-mirrors" "Update has been finished"
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -update >/dev/null 2>&1 &
  sleep 0.1
  hyprctl dispatch closewindow title:smenu
  exit
  ;;
3)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -ps >/dev/null 2>&1 &
  sleep 0.1
  exit
  ;;
4)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pr >/dev/null 2>&1 &
  sleep 0.1
  exit
  ;;
5)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e btm >/dev/null 2>&1 &
  sleep 0.1
  hyprctl dispatch closewindow title:smenu
  exit
  ;;
*)
  exit
  ;;
esac
