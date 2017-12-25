#!/usr/bin/env bash

# <bitbar.title>Memory</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current memory usage</bitbar.desc>

# Code snippet from Neofetch by Dylan Arapsch
# https://github.com/dylanaraps/neofetch

get_memory() {

	mem_total="$(($(sysctl -n hw.memsize) / 1024 / 1024))"
	mem_wired="$(vm_stat | awk '/wired/ { print $4 }')"
	mem_active="$(vm_stat | awk '/active / { printf $3 }')"
	mem_compressed="$(vm_stat | awk '/occupied/ { printf $5 }')"
	mem_used="$(((${mem_wired//.} + ${mem_active//.} + ${mem_compressed//.}) * 4 / 1024))"
	memoryM="${mem_used}MiB / ${mem_total}MiB"

	mem_total="$(awk -v a=${mem_total} 'BEGIN {printf "%2.0f", a / 1024}')"
	mem_used="$(awk -v a=${mem_used} 'BEGIN {printf "%2.2f", a / 1024}')"
	memoryG="${mem_used} / ${mem_total}GiB"

}

get_swap() {

	swap_total="$(sysctl vm.swapusage | awk '{ print $4 }')"
	swap_used="$(sysctl vm.swapusage | awk '{ print $7 }')"

	swap_total="$(trim_digits "${swap_total/M*}")"
	swap_used="$(trim_digits "${swap_used/M*}")"

	swap_usage="${swap_used}MiB / ${swap_total}MiB"

}

trim_digits() {

	case "${1##*.}" in
		"00")	printf "%s" "${1/.*}" ;;
		*)		printf "%s" "${1}" ;;
	esac

}

get_memory
get_swap
echo "Mem: ${memoryG}"
echo "---"
echo "${memoryM}"
echo "Swap: ${swap_usage}"
echo "---"
echo "Refresh | refresh=true"