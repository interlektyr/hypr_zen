#!/bin/bash

if [ "$(curl -Is http://www.google.com | head -n 1 | grep OK)" ]; then
  con="Connected"
else
  con="Disconected"
fi

if [ "$(cat /etc/ufw/ufw.conf | grep ENABLED=yes)" = "ENABLED=yes" ]; then
  ufw="Up"
else
  ufw="Down"
fi

if [ "$(mullvad status | grep Connected)" ]; then
  vpn="On"
else
  vpn="Off"
fi

if [ -z $(pidof transmission-daemon) ]; then
  torr="Connect"
else
  torr="Launch or disconnect"
fi

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:cmenu >/dev/null 2>&1

val=$(
  echo -e "enter select  esc exit\nInternet (nmtui): $con\nFirewall (ufw): $ufw\nVPN (mullvad): $vpn\nTorrent (tremc): $torr\nBluetooth (bluetuith)\nFile Transfer (localsend)" | fzf --info=hidden \
    --header-lines=1 --color=pointer:magenta --color=border:'#232A2C' --color=bg+:#232A2C,bg:#232A2C \
    --footer="Connections" --color=footer:italic:yellow --header-border=line --footer-border=line --accept-nth={n}
)

tran() {

  if [ $torr = "Connect" ]; then
    hyprctl dispatch movetoworkspacesilent special:stash
    transmission-daemon
    setsid kitty --title yazi -e tremc >/dev/null 2>&1 &
    hyprctl dispatch closewindow title:cmenu
    exit
  else
    hyprctl dispatch movetoworkspacesilent special:stash
    setsid kitty --title gum_con -e ~/.config/hypr/hyp_confirm.sh -tremc >/dev/null 2>&1 &
    sleep 0.1
    exit
  fi

}

case $val in
1)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e nmtui >/dev/null 2>&1 &
  hyprctl dispatch closewindow title:cmenu
  exit
  ;;
2)
  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e sudo tufw >/dev/null 2>&1 &
  hyprctl dispatch closewindow title:cmenu
  exit
  ;;
3)
  exit
  ;;
4)
  tran
  ;;
5)
  sleep 0.1
  exit
  ;;
*)
  exit
  ;;
esac

exit
