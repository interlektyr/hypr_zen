#!/bin/bash

clear

installdir=$(pwd)

sudo pacman -Syu --needed gum figlet

fdir="$(figlet -I2)/Fraktur.flf"

if [ -e "$fdir" ]; then
  sudo cp Fraktur.flf $(figlet -I2)
fi

banner() {
  figlet -f Fraktur hypr
  figlet -f Fraktur zen
}

cpy() {

  chlist=(
    "hyp_m_system.sh"
    "hyprland.conf"
    "hyprlock.conf"
    "hyp_appcommander.sh"
    "hyp_bat.sh"
    "hyp_clock.sh"
    "hyp_confirm.sh"
    "hyp_conn.sh"
    "hyp_mon.sh"
    "hyp_m_power.sh"
    "hyp_power.sh"
    "hyp_stash.sh"
    "hyp_system.sh"
    "hyp_update.sh"
    "hyp_vol.sh"
    "hyp_win.sh"
  )

  clear

  banner
  echo "Install script: Copying files..."
  echo " "
  echo " "

  # check if /$HOME/.config/ exit, if it dosen't create it
  confdir="~/.config/"

  if [ ! -d "$confdir" ]; then
    mkdir "$confdir"
    echo "Creating .config..."
    sleep 2
  fi

  cd .config/hypr/

  echo "Setting permissions..."
  chmod +x ${chlist[@]}
  sleep 2

  cd ..

  echo "Copying files..."
  cp -r hypr kitty mako nvim yazi wallpapers $confdir
  sleep 2

  cd ..

  # If not on a laptop
  if [ "$ComT" = "S" ]; then
    cd $confdir
    cd hypr
    rm hyp_bat.sh
    cd $installdir
  fi

  inst

}

inst() {
  clear

  banner
  echo "Install script: Installing dependencies..."
  echo " "
  echo " "

  pmpkg=(
    "egl-wayland"
    "grim"
    "hyprland"
    "hyprpolkitagent"
    "qt5-wayland"
    "qt6-wayland"
    "noto-fonts"
    "xdg-desktop-portal-hyprland"
    "xdg-utils"
    "smartmontools"
    "wireplumber"
    "udisks2"
    "udiskie"
    "uwsm"
    "hyprpicker"
    "hyprlock"
    "wl-clipboard"
    "mako"
    "figlet"
    "gum"
    "git"
    "wget"
    "grim"
    "slurp"
    "kitty"
    "networkmanager"
    "transmission-cli"
    "wireless_tools"
    "nano"
    "vim"
    "neovide"
    "bottom"
    "imv"
    "yazi"
    "ffmpeg"
    "7zip"
    "jq"
    "poppler"
    "fd"
    "ripgrep"
    "zoxide"
    "resvg"
    "imagemagick"
    "ouch"
  )

  parpkg=(
    "awww-bin"
    "hyprshutdown"
    "rose-pine-hyprcursor"
    "tremc"
    "tufw"
    "zen-browser-bin"
    "arch-update"
    "rate-mirrors-bin"
  )

  sudo pacman -S --needed ${pmpkg[@]}

  # If not CachyOS
  if [ "$CO" = "no" ]; then
    sudo pacman -S fish ufw fzf
    sudo pacman -S --needed base-devel
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd $installdir
  fi

  paru -S ${parpkg[@]}

  # If ASUS laptop
  if [ "$ComT" = "ASUS" ]; then
    paru -S asusctl
  fi

}

spec() {

  clear

  banner
  echo "Install script: Specs"
  echo " "
  echo " "

  case $(gum choose --header="What is your base OS?" "CachyOS" "Vanilla Arch" "Quit") in
  "CachyOS")
    CO="yes"
    ;;
  "Vanilla Arch")
    CO="no"
    ;;
  "Quit")
    exit
    ;;
  esac

  case $(gum choose --header="What kind of computer do you have?" "ASUS Laptop" "Other Laptop" "Stationary" "Quit") in
  "ASUS Laptop")
    ComT="ASUS"
    ;;
  "Other Laptop")
    ComT="L"
    ;;
  "Stationary")
    ComT="S"
    ;;
  "Quit")
    exit
    ;;
  esac

  case $(gum choose --header="Monitor setup" "Hyprland default" "interlektyr's personal setup" "Quit") in
  "Hyprland default")
    MonT="1"
    ;;
  "interlektyr's personal setup")
    MonT="2"
    ;;
  "Quit")
    exit
    ;;
  esac

  if [ "$CO" = "yes" ]; then
    p1="Catchy"
  else
    p1="Vanilla Arch"
  fi

  if [ "$ComT" = "ASUS" ]; then
    p2="ASUS Laptop"
  elif [ "$ComT" = "L" ]; then
    p2="Non-ASUS Laptop"
  else
    p2="Stationary computer"
  fi

  if [ "$MonT" = "1" ]; then
    p3="Hyprland default"
  else
    p3="interlektyr's personal setup (WARNING: If you are not interlektyr you chould problably dont pick this option)"
  fi

  gum style \
    --foreground 212 --border-foreground 212 --border double \
    --align center --width 50 --margin "1 2" --padding "2 4" \
    'You have choosen:' ' ' "OS: $p1" "Computer: $p2" "Monitor setup: $p3"

  gum confirm Correct? && cpy || spec

}

spec

#how to install dawn in the browser
#sudo pacman -S emscripten
#git clone --recursive https://github.com/andrewmd5/dawn.git
#cd dawn
#export PATH="/usr/lib/emscripten/:$PATH"
#make web

#to run
#cd build-web
#cd web
#python -m http.server 8000
