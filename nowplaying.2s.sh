#!/usr/bin/env bash

# <bitbar.title>Song Info</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the song info only</bitbar.desc>

# Original author: Adam Kenyon
# Github: adampk90
# Modified by me for personal use

apps=(iTunes Spotify)

for i in "${apps[@]}"; do
	app_state="$(osascript -e "application \"${i}\" is running")"

	if [[ "$?" != "0" ]]; then
		exit
	fi

	if [[ "$app_state" == "true" ]] && [[ "$track" == "" ]]; then
		app_playing="$(osascript -e "tell application \"${i}\" to player state as string")"
		if [[ "$app_playing" == "paused" ]] ||  [[ "$app_playing" == "0" ]]; then
			paused="${i}"
		elif [[ "$app_playing" == "playing" ]] ||  [[ "$app_playing" == "1" ]]; then
			playing="${i}"
		fi
	fi
done

# open a specified app
if [[ "$1" == "open" ]]; then
	osascript -e "tell application \"${2}\" to activate"
	exit
fi

if [[ "$playing" == "" ]] && [[ "$paused" == "" ]]; then
	echo "♫ | color=#767676"
	echo "---"
	echo "🙉 No music playing"
else
	track=""
	artist=""

	if [ "$playing" = "" ]; then
		echo "♫ | color=#767676"
		echo "---"
		app="$paused"
	else
		app="$playing"
	fi

	track_query="name of current track"
	artist_query="artist of current track"

	track=$(osascript -e "tell application \"${app}\" to ${track_query}")
	artist=$(osascript -e "tell application \"${app}\" to ${artist_query}")

	if [[ "$playing" != "" ]]; then
		echo "♫"
	fi
	echo "---"
	echo "$artist - $track"
	
fi

echo "---"
for i in "${apps[@]}"; do
	echo "Open $i | bash='$0' param1=open param2=$i terminal=false"
done