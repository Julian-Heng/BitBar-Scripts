#!/usr/bin/env bash

# <bitbar.title>Temperature</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Julian Heng</bitbar.author>
# <bitbar.author.github>julian-heng</bitbar.author.github>
# <bitbar.desc>This plugin displays the current CPU temperatures</bitbar.desc>
# <bitbar.dependencies>osx-cpu-temp</bitbar.dependencies>

echo "$(/usr/local/bin/osx-cpu-temp)"
echo "---"
echo "Fahrenheit: $(/usr/local/bin/osx-cpu-temp -F)"
echo "---"
echo "Refresh | refresh=true"