#!/usr/bin/env bash

# <bitbar.title>Load Averages</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current CPU load averages</bitbar.desc>

# Various code snippet from Neofetch by Dylan Araps
# https://github.com/dylanaraps/neofetch

get_load() {

	load="$(sysctl -n vm.loadavg)"
	load="${load%' }'}"
	load="${load#'{ '}"

}

get_cpu_info() {

	cpu="$(sysctl -n machdep.cpu.brand_string)"
	case "$cpu_cores" in
		"logical" | "on") cores="$(sysctl -n hw.logicalcpu_max)" ;;
		"physical") cores="$(sysctl -n hw.physicalcpu_max)" ;;
	esac
	cores="$(sysctl -n hw.logicalcpu_max)"
	cpu="${cpu/@/(${cores}) @}"

}

strip_date() {

	case "$1" in
		"0 "*) unset "${1/* }" ;;
		"1 "*) printf "%s" "${1/s}" ;;
		*)     printf "%s" "$1" ;;
	esac

}

get_uptime() {

	boot="$(sysctl -n kern.boottime)"
	boot="${boot/'{ sec = '}"
	boot="${boot/,*}"
	
	now="$(date +%s)"
	seconds="$((now - boot))"
	
	days="$((seconds / 60 / 60 / 24)) days"
	hours="$((seconds / 60 / 60 % 24)) hours"
	mins="$((seconds / 60 % 60)) minutes"
	
	days="$(strip_date "$days")"
	hours="$(strip_date "$hours")"
	mins="$(strip_date "$mins")"
	
	uptime="${days:+$days, }${hours:+$hours, }${mins}"
	uptime="${uptime%', '}"
	uptime="${uptime:-${seconds} seconds}"
	
	uptime="${uptime/ days/d}"
	uptime="${uptime/ day/d}"
	uptime="${uptime/ hours/h}"
	uptime="${uptime/ hour/h}"
	uptime="${uptime/ minutes/m}"
	uptime="${uptime/ minute/m}"
	uptime="${uptime/ seconds/s}"
	uptime="${uptime//,}"

}

get_cpu_usage() {

	cpu_usage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
	cpu_usage="$((${cpu_usage/\.*} / ${cores:-1}))"

}

get_load
get_cpu_info
get_cpu_usage
get_uptime

echo "CPU: ${cpu_usage}%"
echo "---"
echo "${cpu}"
echo "---"
echo "Load Averages: ${load}"
echo "Uptime: ${uptime}"