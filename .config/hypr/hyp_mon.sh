#!/bin/bash

CHECK_MON=$(hyprctl monitors | grep 'Monitor DP-2')

if [[ -z $CHECK_MON ]]; then
# "No external display"

hyprctl keyword monitor ,preferred,auto,1.33

exit

else
# "external display"

hyprctl keyword monitor DP-2,preferred,auto,1.07
hyprctl keyword monitor eDP-2, disable
#hyprctl keyword exec-once [workspace special:zbrowser silent] zen-browser --start-fullscreen


fi
