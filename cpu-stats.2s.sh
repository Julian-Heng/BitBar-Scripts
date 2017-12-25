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
	load="${load/' }'}"
	printf "%s" "${load/'{ '}"

}

get_cpu_info() {

	cpu="$(sysctl -n machdep.cpu.brand_string)"
	printf "%s" "${cpu/@/(${cores}) @}"

}

get_os_info() {

	osx_version="$(sw_vers -productVersion)"
	case "${osx_version}" in
		"10.7"*)	printf "%s" "Mac OS X Lion ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.8"*)	printf "%s" "OS X Mountain Lion ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.9"*)	printf "%s" "OS X Mavericks ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.10"*)	printf "%s" "OS X Yosemite ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.11"*)	printf "%s" "OS X El Capitan ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.12"*)	printf "%s" "macOS Sierra ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		"10.13"*)	printf "%s" "macOS High Sierra ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
		*)			printf "%s" "macOS ${osx_version} $(sw_vers -buildVersion) $(uname -m)" ;;
	esac    

}

get_model() {

	if [[ ! -z "$(kextstat | grep "FakeSMC")" ]]; then
		printf "%s" "Hackintosh (SMBIOS: $(sysctl -n hw.model))"
	else
		printf "%s" "$(sysctl -n hw.model)"
	fi

}

strip() {

	case "$2" in
		"0")	unset "$1" ;;
		*) 		printf "%s" "$2${1:0:1} " ;;
	esac

}

get_uptime() {

	boot="$(sysctl -n kern.boottime)"
	boot="${boot/'{ sec = '}"
	boot="${boot/,*}"
	seconds="$(($(date +%s) - boot))"
	
	days="$(strip days $((seconds / 60 / 60 / 24)))"
	hours="$(strip hours $((seconds / 60 / 60 % 24)))"
	mins="$(strip mins $((seconds / 60 % 60)))"
	secs="$(strip secs $((seconds % 60 % 60 % 24)))"
	printf "%s" "${days}${hours}${mins}${secs}"

}

get_cpu_usage() {

	cpu_usage="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
	cpu_usage="$((${cpu_usage/\.*} / ${cores:-1}))"

	case "1:${cpu_usage:--}" in 
		($((cpu_usage >= 100))*)	printf "%s" "${cpu_usage}% | color=#d77c79" ;;
		($((cpu_usage >= 75))*)		printf "%s" "${cpu_usage}% | color=#f4b887" ;;
		*)							printf "%s" "${cpu_usage}%" ;;
	esac

}

cores="$(sysctl -n hw.logicalcpu_max)"
echo "CPU: $(get_cpu_usage)"
echo "---"
echo "$(get_os_info)"
echo "$(get_cpu_info)"
echo "$(get_model)"
echo "---"
echo "Load Averages: $(get_load)"
echo "Uptime: $(get_uptime)"
echo "---"
echo "Refresh | refresh=true"