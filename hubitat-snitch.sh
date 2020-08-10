#!/bin/sh -x
#
# Toggles a hubitat virtual switch based on microsnitch's log
#

exec > /tmp/vlog 2>&1

# ACCESS_TOKEN is from your hubitat maker api 
if [ -z "$ACCESS_TOKEN" ]; then
	echo "Missing ACCESS_TOKEN env var"
	exit 1
fi

# Configuration
# Micro Snitch log location
LOG="$HOME/Library/Logs/Micro Snitch.log"
# Name of the Camera event you'd like to listen for
CAMERA="FaceTime HD Camera (Built-in)"
# The hubitat switch id to toggle
SWITCHID="108"
# How frequently to check the log (default: 5s)
POLL_TIME=5

# This uses the maker api, your URL has to change 
switch_status=$(http GET "http://192.168.7.46/apps/api/18/devices/$SWITCHID?access_token=$ACCESS_TOKEN" | jq -r '.attributes[0].currentValue')


if [[ ! -f $LOG ]]; then
    echo >&2 "Error: No Micro Snitch log found in $LOG."
    exit 1
fi

function toggle_switch(){
    local action=$1
    if [[ "$switch_status" != "$action" ]]; then
    # get this url from your maker api
	http GET "http://192.168.7.46/apps/api/18/devices/$SWITCHID/$action?access_token=$ACCESS_TOKEN"
	echo $action
	switch_status=$action
    fi
}


while true
do
    status=$(grep Camera "$LOG" | awk 'END{o=$10; for (i=11; i<=NF; i++) {o=o" "$i}; print o}')
    if [[ "$status" = "active: $CAMERA" ]]; then
      toggle_switch on
    fi
    if [[ "$status" = "inactive: $CAMERA" ]]; then
       toggle_switch off
    fi
    sleep $POLL_TIME
done

