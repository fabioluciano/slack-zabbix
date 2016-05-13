#!/bin/bash

declare -A configurations

configurations=(
  [webhook]=''
  [user_to_use]='Zabbix'
  [channel]='#zabbix-notification'
  [notification_type]=$1
  [server]=$2
  [message]=$3
)

case "${configurations['notification_type']}" in
  problem)
    configurations[color]='#ff0000'
  ;;
  recovery)
    configurations[color]='#48b613'
  ;;
  *)
    configurations[color]='#d3d3d3'
  ;;
esac

json=$(cat message.json)
json=$(echo $json | sed 's/__USERNAME__/'${configurations['user_to_use']}'/g')
json=$(echo $json | sed 's/__CHANNEL__/'${configurations['channel']}'/g')
json=$(echo $json | sed 's/__SERVER__/'${configurations['server']}'/g')
json=$(echo $json | sed 's/__TYPE__/'${configurations['notification_type']}'/g')
json=$(echo $json | sed 's/__COLOR__/'${configurations['color']}'/g')
json=$(echo $json | sed 's/_MSG_/'${configurations['message']}'/g')

echo "$json"

curl -X "POST" -H 'Content-type: application/json'  --data "$json" ${configurations['webhook']}
