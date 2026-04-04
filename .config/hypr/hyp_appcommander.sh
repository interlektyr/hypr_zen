#!/bin/bash

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:appcom >/dev/null 2>&1

check_tmp() {

  if [ ! -f /tmp/appcommander/AC_Exec.txt ]; then
    mkdir /tmp/appcommander/
    touch /tmp/appcommander/AC_Exec.txt
    touch /tmp/appcommander/AC_Name.txt
    touch /tmp/appcommander/AC_Term.txt
    update
  fi

}

update() {

  if [ ! -f /tmp/appcommander/AC_Exec.txt ]; then
    check_tmp
  else

    truncate -s 0 /tmp/appcommander/AC_Exec.txt
    truncate -s 0 /tmp/appcommander/AC_Name.txt
    truncate -s 0 /tmp/appcommander/AC_Term.txt

  fi

  echo " enter launch  ctrl-s sync  esc quit" >>/tmp/appcommander/AC_Name.txt
  echo "null" >>/tmp/appcommander/AC_Exec.txt
  echo "null" >>/tmp/appcommander/AC_Term.txt

  #echo "Syncing .desktop-files found in /usr/share/applications..."

  for entry in $(find /usr/share/applications -name "*.desktop"); do
    onlyname=$(echo $entry | cut -d/ -f5)
    echo "$entry" >>/tmp/appcommander/AC_Exec.txt
    nameApp=$(grep -m 1 '^Name=' $entry | head -1 | cut -d= -f2)

    if grep -qwF "$nameApp" "/tmp/appcommander/AC_Name.txt"; then
      echo "$nameApp ($onlyname)" >>/tmp/appcommander/AC_Name.txt
    else
      echo "$nameApp" >>/tmp/appcommander/AC_Name.txt
    fi

    hterm=$(grep '^Terminal=' $entry | head -1 | cut -d= -f2)

    if [ "$hterm" = "true" ]; then
      echo "$(grep -m 1 '^Exec=' $entry | head -1 | cut -d= -f2)" >>/tmp/appcommander/AC_Term.txt
    else
      echo "false" >>/tmp/appcommander/AC_Term.txt
    fi

  done

}

main() {

  truncate -s 0 ~/nohup.out

  check_tmp

  v=$(
    cat /tmp/appcommander/AC_Name.txt | fzf --preview 'echo -e "\n\n\n" ; figlet -f Fraktur apps' --bind "ctrl-s:execute(~/.config/hypr/hyp_appcommander.sh -u)+become(~/.config/hypr/hyp_appcommander.sh)" \
      --info=hidden --header-lines=1 --border --padding=5%,0%,0%,0% --border-label="" --border-label-pos=3 \
      --footer-border=line --color=bg+:#1e2528,bg:#1e2528,border:#1e2528,label:italic:yellow,spinner:#E6DB74,hl:green,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:magenta,marker:green,fg+:#F8F8F2,prompt:blue,hl+:#F92672,preview-fg:#F7A182
  )

  if [ -z "$v" ]; then
    exit
  fi

  lineNum=$(grep -n "$v" "/tmp/appcommander/AC_Name.txt" | cut -d: -f1)

  checkterm=$(sed -n "${lineNum}p" </tmp/appcommander/AC_Term.txt)

  if [ "$checkterm" = "false" ]; then

    sel=$(sed -n "${lineNum}p" </tmp/appcommander/AC_Exec.txt)

    nohup dex $sel >/dev/null 2>&1

    exit 0

  else

    setsid kitty --title yazi -e $checkterm >/dev/null 2>&1 &

    sleep 1

    exit

  fi

}

case $1 in
-u)
  update
  ;;
*)
  main
  ;;
esac
