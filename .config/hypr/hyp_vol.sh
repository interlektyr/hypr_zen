#!/bin/bash

volop=$1

not() {

  check_m=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep '[MUTED]')

  if [ -z "$check_m" ]; then

    curr_vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')

    if [ "$curr_vol" != "100" ]; then

      curr_vol=$(echo "$curr_vol" | cut -d "." -f 2)

    fi

    notify-send -a m_stat -c hyp_vol "VOLUME" "$(figlet -f Fraktur $curr_vol%)"
    exit

  else
    notify-send -a m_stat -c hyp_vol "VOLUME" "$(figlet -f Fraktur off)"
    exit
  fi

}

if [ "$volop" = "-u" ]; then

  wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
  not
  exit

fi

if [ "$volop" = "-d" ]; then

  wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
  not
  exit

fi

if [ "$volop" = "-m" ]; then

  wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  not
  exit

fi
