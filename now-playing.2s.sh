#!/usr/bin/env bash

# <bitbar.title>Song Info</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the song info</bitbar.desc>

# Original author: Adam Kenyon
# Github: adampk90
# Modified by me for personal use

check_app_state() {

	apps=(iTunes Spotify)
	for i in "${apps[@]}"; do

		if ! app_state="$(osascript -e "application \"${i}\" is running")"; then
			exit
		fi

		if [[ "$app_state" == "true" && -z "$track" ]]; then
			app_playing="$(osascript -e "tell application \"${i}\" to player state as string")"
			case "${app_playing}" in
				"paused"|0)		paused="${i}" ;;
				"playing"|1)	playing="${i}" ;;
			esac
		fi
	done

}

open_app() {

	case "$1" in
		"open") osascript -e "tell application \"${2}\" to activate"; exit ;;
		"play"|"pause") osascript -e "tell application \"${2}\" to ${1}"; exit ;;
		"next"|"previous") next_previous "$@"; exit ;;
	esac

}

next_previous() {

	osascript -e "tell application \"${2}\" to ${1} track"
	if [[ "$playing" == "Spotify" && "$1" == "previous" ]]; then
		osascript -e "tell application \"${2}\" to ${1} track"
	fi
	osascript -e "tell application \"${2}\" to play"

}

print_to_bar() {

	if [[ -z "$playing" && -z "$paused" ]]; then
		echo "♫ | color=#767676"
		echo "---"
		echo "No music playing"
	else
		unset track
		unset artist

		if [[ -z "$playing" ]]; then
			echo "♫ | color=#767676"
			echo "---"
			app="${paused}"
		else
			app="${playing}"
		fi

		track_cmd="name of current track"
		artist_cmd="artist of current track"
		album_cmd="album of current track"

		track="$(osascript -e "tell application \"${app}\" to ${track_cmd}")"
		artist="$(osascript -e "tell application \"${app}\" to ${artist_cmd}")"
		album="$(osascript -e "tell application \"${app}\" to ${album_cmd}")"

		if [[ ! -z "$playing" ]]; then
			echo "♫"
		fi

		echo "---"
		echo "${artist} - ${album}"
		echo "${track}"
		
		echo "---"
		if [[ -z "$playing" ]]; then
			echo "Play | bash='${0}' param1=play param2=${app} refresh=true terminal=false"
		else
			echo "Pause | bash='${0}' param1=pause param2=${app} refresh=true terminal=false"
		fi
		echo "Next | bash='${0}' param1=next param2=${app} refresh=true terminal=false"
		echo "Previous | bash='${0}' param1=previous param2=${app} refresh=true terminal=false"
	fi

	echo "---"
	for i in "${apps[@]}"; do
		echo "Open ${i} | bash='${0}' param1=open param2=${i} terminal=false"
	done
	echo "---"
	echo "Refresh | refresh=true"

}

check_app_state
open_app "$@"
print_to_bar