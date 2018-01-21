#!/usr/bin/env bash

# <bitbar.title>Song Info</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the song info</bitbar.desc>

# Original author: Adam Kenyon
# Github: adampk90
# Modified by me for personal use

cmus_remote="/usr/local/bin/cmus-remote"

check_app_state() {

	apps=(Spotify iTunes cmus)
	for i in "${apps[@]}"; do

		if [[ "$i" == "cmus" ]]; then
			if pgrep -x "cmus" > /dev/null; then
				app_state="true"
				cmus_cache="$(${cmus_remote} -Q)"
				app_playing="$(awk '/status/ { print $2 }' <<< "${cmus_cache}")"
				determine_state "$app_playing" "$i"
			fi
		else
			if ! app_state="$(osascript -e "application \"$i\" is running")"; then
				exit
			fi
			if [[ "$app_state" == "true" && -z "$track" ]]; then
				app_playing="$(osascript -e "tell application \"$i\" to player state as string")"
				determine_state "$app_playing" "$i"
			fi
		fi

	done

}

determine_state() {
	case "$1" in
		"paused"|0)		paused="$2" ;;
		"playing"|1)	playing="$2" ;;
	esac
}

app_action() {

	case "$2" in
		"cmus") 
			case "$1" in
				"play"|"pause") ${cmus_remote} --pause && exit ;;
				"next") ${cmus_remote} --next && exit ;;
				"previous") ${cmus_remote} --previous && exit ;;
			esac
		;;

		*)
			case "$1" in
				"open") osascript -e "tell application \"$2\" to activate" && exit ;;
				"play"|"pause") osascript -e "tell application \"$2\" to $1" && exit ;;
				"next"|"previous") next_previous "$@" && exit ;;
			esac
		;;

	esac

}

next_previous() {

	osascript -e "tell application \"${2}\" to ${1} track"
	[[ "$playing" == "Spotify" && "$1" == "previous" ]] && osascript -e "tell application \"${2}\" to ${1} track"
	osascript -e "tell application \"${2}\" to play"

}

get_song_info() {

	if [[ "$app" == "cmus" ]]; then

		track="$(${cmus_remote} -C "format_print %{title}")"
		artist="$(${cmus_remote} -C "format_print %{artist}")"
		album="$(${cmus_remote} -C "format_print %{album}")"

		duration="$(awk '/duration/' <<< "${cmus_cache}")"
		position="$(awk '/position/' <<< "${cmus_cache}")"

		duration="${duration//duration }"
		position="${position//position }"
		percentage=$((200 * position/duration % 2 + 100 * position/duration))

		duration="$("${cmus_remote}" -C "format_print %{duration}")"
		position="$("${cmus_remote}" -C "format_print %{position}")"

	else

		track_cmd="name of current track"
		artist_cmd="artist of current track"
		album_cmd="album of current track"
	
		track="$(osascript -e "tell application \"$app\" to ${track_cmd}")"
		artist="$(osascript -e "tell application \"$app\" to ${artist_cmd}")"
		album="$(osascript -e "tell application \"$app\" to ${album_cmd}")"

	fi

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

		get_song_info

		[[ ! -z "$playing" ]] && echo "♫"

		echo "---"
		if [[ "$album" == "$track" ]]; then
			echo "${artist} - ${track}"
		else
			echo "${artist} - ${album}"
			echo "${track}"
		fi
		[[ "$app" == "cmus" ]] && echo -e "---\\n${position} / ${duration} (${percentage}%)"
		echo "---"
		echo "${app}"
		echo "---"

		if [[ -z "$playing" ]]; then
			echo "Play | bash='$0' param1=play param2=$app refresh=true terminal=false"
		else
			echo "Pause | bash='$0' param1=pause param2=$app refresh=true terminal=false"
		fi
		echo "Next | bash='$0' param1=next param2=$app refresh=true terminal=false"
		echo "Previous | bash='$0' param1=previous param2=$app refresh=true terminal=false"
	fi

	echo "---"
	for i in "${apps[@]}"; do
		[[ "$i" != "cmus" ]] && echo "Open $i | bash='$0' param1=open param2=$i terminal=false"
	done
	echo "---"
	echo "Refresh | refresh=true"

}

check_app_state
app_action "$@"
print_to_bar