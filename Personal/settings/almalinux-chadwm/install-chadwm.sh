#!/bin/bash
# set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Installing Chadwm"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "###### Installing packages"
echo "################################################################"
tput sgr0
echo

# Enable the EPEL Repository
sudo dnf install -y epel-release

sudo dnf upgrade -y

# getting dependencies to be able to build Chadwm
sudo dnf group install -y "Development Tools"
sudo dnf install -y fontawesome-fonts
sudo dnf install -y imlib2-devel
sudo dnf install -y libX11-devel
sudo dnf install -y libXft-devel
sudo dnf install -y libXinerama-devel

# applications to be used in Chadwm

sudo yum install -y dash
sudo yum install -y dmenu
sudo yum install -y picom
sudo yum install -y playerctl
sudo yum install -y polkit-gnome.x86_64
sudo yum install -y rofi
sudo yum install -y thunar
sudo yum install -y thunar-archive-plugin
sudo yum install -y thunar-volman
sudo yum install -y xsetroot

# exit strategy - super + shift + x
git clone https://github.com/arcolinux/arcolinux-powermenu  /tmp/arcolinux-powermenu
sudo cp /tmp/arcolinux-powermenu/usr/local/bin/arcolinux-powermenu /usr/local/bin
cp -r /tmp/arcolinux-powermenu/etc/skel/.bin ~
cp -r /tmp/arcolinux-powermenu/etc/skel/.config ~

# getting the official code from ArcoLinux
git clone https://github.com/arcolinux/arcolinux-chadwm  /tmp/arcolinux-chadwm
sudo cp /tmp/arcolinux-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/arcolinux-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -r /tmp/arcolinux-chadwm/etc/skel/.bin ~
cp -r /tmp/arcolinux-chadwm/etc/skel/.config ~

# overwriting the official code from ArcoLinux with my own
cp run.sh  ~/.config/arco-chadwm/scripts
cp picom.conf  ~/.config/arco-chadwm/picom
cp config.def.h ~/.config/arco-chadwm/chadwm
cp config.mk ~/.config/arco-chadwm/chadwm
cp sxhkdrc  ~/.config/arco-chadwm/sxhkd
cp bar.sh ~/.config/arco-chadwm/scripts
[ -d $HOME"/.config/Thunar" ] || mkdir -p $HOME"/.config/Thunar"
cp uca.xml ~/.config/Thunar/

# building Chadwm
cd ~/.config/arco-chadwm/chadwm
sudo make install

# Building what we do not find
# sudo yum install -y alacritty

if [ ! -f /usr/local/bin/alacritty ]; then

	sudo dnf install -y cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel python3 cargo
	if [ -d "/tmp/alacritty" ]; then
	    echo "Directory /tmp/alacritty exists. Removing it..."
	    rm -rf /tmp/alacritty
	else
	    mkdir -p /tmp/alacritty
	fi
	git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
	cd /tmp/alacritty
	cargo build --release
	sudo cp /tmp/alacritty/target/release/alacritty /usr/local/bin/
fi


if [ ! -f /usr/local/bin/sxhkd ]; then
	# Building what we do not find
	# sudo yum install -y sxhkd

	# Install dependencies
	sudo dnf install -y gcc make xorg-x11-server-devel libX11-devel libxcb-devel xcb-util-keysyms-devel xcb-util-devel

	# Check if /tmp/sxhkd exists and remove if it does
	if [ -d "/tmp/sxhkd" ]; then
	    echo "Directory /tmp/sxhkd exists. Removing it..."
	    rm -rf /tmp/sxhkd
	else
	    mkdir -p /tmp/sxhkd
	fi

	# Clone the sxhkd repository
	git clone https://github.com/baskerville/sxhkd.git /tmp/sxhkd
	cd /tmp/sxhkd

	# Build sxhkd
	make

	# Install sxhkd
	sudo make install

	echo "sxhkd has been installed successfully."
fi



echo
tput setaf 6
echo "################################################################"
echo "###### Chadwm is installed - reboot"
echo "################################################################"
tput sgr0
echo
