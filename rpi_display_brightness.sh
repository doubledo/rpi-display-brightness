#!/bin/bash

set_bright()
{
	echo "$1" > /sys/class/backlight/rpi_backlight/brightness
}

change_bright()
{
	local bright=`cat /sys/class/backlight/rpi_backlight/brightness`
	local esc=$'\e'
	local up=$'\e[A'
	local down=$'\e[B'

	local step=6;

	echo $bright
	while IFS="" read -n1 -s char ; do
		if [[ "$char" == "$esc" ]]; then 
			while read -n2 -s rest ; do
				char+="$rest"
                		break
            		done
        	fi
		
		if [[ "$char" == "$up" ]]; then
			if [[ $bright+$step -le "255" ]]; then
				((bright=bright+step))
			else
				bright=255
			fi
			
			set_bright $bright
			echo $bright
		elif [[ "$char" == "$down" ]]; then
			if [[ $bright-$step -ge "0"  ]]; then
				((bright=bright-step))
			else
				bright=0
			fi

			set_bright $bright
			echo $bright
		elif [[ "$char" == "x" ]]; then
			bright=255;
			set_bright $bright
			
		elif [[ -z "$char" || $char == "q" ]]; then # user pressed ENTER
			exit 0
		fi
	done
}

re='^[0-9]+$'
if [[ $1 =~ $re && $1 -le "255" && $1 -ge "0" ]]; then
	set_bright $1
	echo $bright
else
	echo up/down arrow - display brightness adjustments
	echo x - set max display brightness
	echo q/enter - exit
	echo
	change_bright
fi
