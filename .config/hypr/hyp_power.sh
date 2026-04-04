#!/bin/bash

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:pmenu >/dev/null 2>&1

val=$(
  echo -e "enter select  esc exit\nLock\nLog out/Reload\nShutdown\nReboot\nReboot into firmware" | fzf --info=hidden \
    --header-lines=1 --color=pointer:magenta --color=border:'#232A2C' --color=bg+:#232A2C,bg:#232A2C \
    --footer="Power" --color=footer:italic:yellow --header-border=line --footer-border=line --accept-nth={n}
)

case $val in
1)
  hyprctl dispatch movetoworkspacesilent special:stash
  sleep 0.2
  setsid hyprlock >/dev/null 2>&1
  exit
  ;;
2)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pl >/dev/null 2>&1 &
  sleep 0.1
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
  setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -pf >/dev/null 2>&1 &
  sleep 0.1
  exit
  ;;
*)
  exit
  ;;
esac
