#!/usr/bin/env bash

# <bitbar.title>Temperature</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current CPU temperatures</bitbar.desc>
# <bitbar.dependencies>osx-cpu-temp</bitbar.dependencies>

temp="$(/usr/local/bin/osx-cpu-temp)"
echo "${temp}"
echo "---"
echo "Fahrenheit: $(awk -v t=${temp} 'BEGIN {printf "%2.1f", t * 1.8 + 32}')°F"
echo "---"
echo "Refresh | refresh=true"