#!/bin/sh

#variables
cr="\033[1;31m"
cg="\033[1;32m"
cb="\033[1;34m"

	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd

  yay -Syy sddm
  sudo rm -rf /etc/systemd/system/display-manager.service
  sudo systemctl enable sddm
  cd

dependencias=(awesome bluez flameshot alacritty mpd mpDris2 nmcli picom playerctl pulsemixer redshift rofi xsettingsd zsh kitty chromium ncmpcpp neovim lf zathura)

is_installed() {
  pacman -Qi "$1" &> /dev/null
  return $?
}

printf "%s%sChecking for required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for paquete in "${dependencias[@]}"
do
  if ! is_installed "$paquete"; then
    yay -S "$paquete"
    printf "\n"
  else
    printf '%s%s is already installed on your system!%s\n' "${CGR}" "$paquete" "${CNC}"
    sleep 1
  fi
done

printf "${cg}Proceeding further would replace all of the current configs, consider making a backup.\n"
printf "${cr}"
read -p "Do you wish to proceed? [y/n]: " allowed
dir="$HOME/.config $HOME/.fonts"

case $allowed in
  Y*|y*)
    for a in $dir; do 
      mkdir -p $a 
    done
    printf "${cg}Copying Dotfiles\n"
    printf "${cb}  Copying Configs\n"
    cp -ra cfg/. ~/.config
    cp -ra home/. ~/
    printf "${cg}    Configs Copied\n"
    printf "${cb}  Copying Fonts\n"
    cp -ran fonts/. ~/.fonts
    printf "${cg}    Fonts Copied\n"
    printf "${cb}  Copying Scripts\n"
    cp -ra bin/. ~/.local/bin/
    printf "${cg}    Scripts Copied\n"
    printf "${cg}Dotfiles Installed\n";;
  *) printf "${cr}Aborting!\n";;
esac
