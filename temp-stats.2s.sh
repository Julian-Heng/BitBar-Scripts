#!/usr/bin/env bash

# <bitbar.title>Temperature</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current CPU temperatures</bitbar.desc>
# <bitbar.dependencies>osx-cpu-temp</bitbar.dependencies>
# <bitbar.dependencies>istats</bitbar.dependencies>

osx_cpu_temp="/usr/local/bin/osx-cpu-temp"
istats="/usr/local/bin/istats"

use_osx_cpu_temp() {

    temp="$(${osx_cpu_temp})"

}

use_istats() {

    temp="$(${istats} cpu --value-only)"
    temp="${temp// }°C"

}

get_fan_speed() {

    fan="$(${istats} fan --value-only | awk 'NR==2{print;exit}')"
    fan="${fan// }"

}

print_to_bar() {

    echo "${temp}"
    echo "---" 
    echo "Fahrenheit: $(awk -v t="${temp}" 'BEGIN {printf "%2.1f", t * 1.8 + 32}')°F"
    [[ ! -z "$fan" ]] && echo "Fan Speed: ${fan} RPM"
    echo "---"
    echo "Refresh | refresh=true"

}

# Comment/uncomment which application to use
use_osx_cpu_temp
#use_istats

get_fan_speed
print_to_bar