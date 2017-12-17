#!/usr/bin/env bash

# <bitbar.title>Memory</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current memory usage</bitbar.desc>
# Code snippet from Neofetch by Dylan Arapsch
# https://github.com/dylanaraps/neofet

get_memory() {

	mem_total="$(bc <<< "scale = 0; "$(sysctl -n hw.memsize)" / 1024 / 1024 / 1024")"
	mem_wired="$(vm_stat | awk '/wired/ { print $4 }')"
	mem_active="$(vm_stat | awk '/active / { printf $3 }')"
	mem_compressed="$(vm_stat | awk '/occupied/ { printf $5 }')"
	mem_used="$((${mem_wired//.} + ${mem_active//.} + ${mem_compressed//.}))"
	mem_used="$(bc <<< "scale = 2; ((("${mem_used}" * 4) / 1024) / 1024)")"
	memory="${mem_used} / ${mem_total}GiB "

}

get_memory
echo "Mem: ${memory}"