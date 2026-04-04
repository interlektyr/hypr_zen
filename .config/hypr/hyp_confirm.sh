#!/bin/bash

power_logout() {

  gum confirm Exit? --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && hyprshutdown || exit

}

power_shutdown() {

  gum confirm Shutdown? --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && hyprshutdown -t 'Shutting down...' --post-cmd 'shutdown -P 0' || exit

}

power_reboot() {

  gum confirm Reboot? --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && hyprshutdown -t 'Restarting...' --post-cmd 'reboot' || exit

}

power_firmware_reboot() {

  gum confirm Bios? --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && hyprshutdown -t 'Restarting...' --post-cmd 'systemctl reboot --firmware-setup' || exit

}

tremc_l() {

  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e tremc >/dev/null 2>&1 &
  hyprctl dispatch closewindow title:cmenu
  exit

}

tremc_d() {

  hyprctl dispatch movetoworkspacesilent special:stash
  transmission-remote --exit
  hyprctl dispatch closewindow title:cmenu
  notify-send "Transmission" "The deamon has been shut down"
  exit

}

tremc_lod() {

  gum confirm Choose --affirmative="tremc" --negative="Disconnect" --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && tremc_l || tremc_d

}

run_update() {

  hyprctl dispatch movetoworkspacesilent special:stash
  setsid kitty --title yazi -e ~/.config/hypr/hyp_update.sh >/dev/null 2>&1 &
  sleep 0.1
  exit

}

update() {

  gum confirm Update? --no-show-help --prompt.foreground="#f5d098" --selected.background="#D699B6" && run_update || exit

}

case $1 in
-pl)
  power_logout
  ;;
-ps)
  power_shutdown
  ;;
-pr)
  power_reboot
  ;;
-pf)
  power_firmware_reboot
  ;;
-tremc)
  tremc_lod
  ;;
-update)
  update
  ;;
*)
  exit
  ;;
esac

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:pmenu >/dev/null 2>&1
