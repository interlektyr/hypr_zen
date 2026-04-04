#!/bin/bash

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')
hyprctl dispatch movetoworkspace $activ_ws,title:stash >/dev/null 2>&1

if [ ! -f /tmp/hyp_stash/widtitle.txt ]; then
  mkdir /tmp/hyp_stash/
  touch /tmp/hyp_stash/widtitle.txt
  touch /tmp/hyp_stash/widclass.txt
  touch /tmp/hyp_stash/widid.txt
  touch /tmp/hyp_stash/widentry.txt
fi

truncate -s 0 /tmp/hyp_stash/widtitle.txt
truncate -s 0 /tmp/hyp_stash/widclass.txt
truncate -s 0 /tmp/hyp_stash/widid.txt
truncate -s 0 /tmp/hyp_stash/widentry.txt

echo -e "EMPTY" >/tmp/hyp_stash/widclass.txt
n=0

hyprctl clients -j | jq -r --arg WORKSPACE "-96" 'map(select(.workspace.id == ($WORKSPACE|tonumber)))' | grep "class" | awk '{print $2}' | sed 's|[",]||g' >>/tmp/hyp_stash/widclass.txt

hyprctl clients -j | jq -r --arg WORKSPACE "-96" 'map(select(.workspace.id == ($WORKSPACE|tonumber)))' | grep "title" | awk '{print $2}' | sed 's|[",]||g' >>/tmp/hyp_stash/widtitle.txt

hyprctl clients -j | jq -r --arg WORKSPACE "-96" 'map(select(.workspace.id == ($WORKSPACE|tonumber)))' | grep "address" | awk '{print $2}' | sed 's|[",]||g' >>/tmp/hyp_stash/widid.txt

for cl in $(cat /tmp/hyp_stash/widclass.txt); do
  if [[ $n = 0 ]]; then
    echo -e "esc quit" >/tmp/hyp_stash/widentry.txt
  else
    echo "$cl: $(sed -n "${n}p" </tmp/hyp_stash/widtitle.txt)" >>/tmp/hyp_stash/widentry.txt
  fi
  n=$((n + 1))
done

sel=$(

  cat /tmp/hyp_stash/widentry.txt | fzf --preview 'echo -e "\n\n\n" ; figlet -f Fraktur stash' --bind "ctrl-s:execute(~/.config/hypr/hyp_appcommander.sh -u)+become(~/.config/hypr/hyp_appcommander.sh)" \
    --info=hidden --header-lines=1 --border --padding=5%,0%,0%,0% --border-label="" --border-label-pos=3 \
    --footer-border=line --color=bg+:#1e2528,bg:#1e2528,border:#1e2528,label:italic:yellow,spinner:#E6DB74,hl:green,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:magenta,marker:green,fg+:#F8F8F2,prompt:blue,hl+:#F92672,preview-fg:#F6CEE5 --accept-nth={n}

)

if [ -z "$sel" ]; then
  exit
fi

widid=$(sed -n "${sel}p" </tmp/hyp_stash/widid.txt)

activ_ws=$(hyprctl activeworkspace | grep 'workspace' | awk '{print $3}')

hyprctl dispatch movetoworkspace $activ_ws,address:$widid
hyprctl dispatch bringactivetotop
