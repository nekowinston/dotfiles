#! /bin/bash
#
# /usr/bin/setcursor

# config files
gtk2=$HOME/.gtkrc-2.0
gtk3=$HOME/.config/gtk-3.0/settings.ini
[[ -e $HOME/.extend.Xresources ]] && xr=$HOME/.extend.Xresources || xr=$HOME/.Xresources

# we'll have to override libxcursor's default
default=share/icons/default/index.theme
glob_default=/usr/$default
user_default=$HOME/.local/$default
[[ -e $glob_default ]] && [[ ! -e $user_default ]] && install -D $glob_default $user_default 

# cursor-theme entries
cursor_gtk2=$(grep "cursor-theme-name" $gtk2 | cut -d'"' -f2)
cursor_gtk3=$(grep "cursor-theme-name" $gtk3 | cut -d'=' -f2)
cursor_xr=$(grep "Xcursor.theme" $xr | cut -d' ' -f2)

cursor=$1

# find config last modified
if [ -z $1 ]; then
	cursor=$cursor_gtk2; newest=$gtk2
	[[ $xr -nt $gtk2 ]] && [[ ! -z $cursor_xr ]] && cursor=$cursor_xr && newest=$xr
	[[ $gtk3 -nt $newest ]] && [[ ! -z $cursor_gtk3 ]] && cursor=$cursor_gtk3
fi

# Strip any quotes from cursor string
cursor=$(echo $cursor | sed -e 's/"//g')

# set theme in all config files
echo "setting cursortheme \"$cursor\""
[[ "$cursor" != "$cursor_xr" ]] && \
	sed -i "s/Xcursor.theme:.*/Xcursor.theme: $cursor/g" $xr &>/dev/null && \
	xrdb -merge -I$HOME ~/.Xresources
[[ "$cursor" != "$cursor_gtk2" ]] && \
	sed -i "s/cursor-theme-name=\".*\"/cursor-theme-name=\"$cursor\"/" $gtk2
[[ "$cursor" != "$cursor_gtk3" ]] && \
	sed -i "s/cursor-theme-name=.*/cursor-theme-name=$cursor/" $gtk3 &>/dev/null
[[ -e $user_default ]] && sed -i "s/Inherits=.*/Inherits=$cursor/" $user_default &>/dev/null

# and in the realms of the GNOMEs
[[ -f /usr/bin/gconftool-2 ]] && gconftool-2 --type string -s /desktop/gnome/peripherals/mouse/cursor $cursor
[[ -f /usr/bin/gsettings ]] && gsettings set org.gnome.desktop.interface cursor-theme $cursor

exit

# oberon 2016
