#!/bin/bash

YAML=../mirakurun/conf/channels.yml

python -c 'import sys, yaml, json; json.dump(yaml.load(sys.stdin, Loader=yaml.FullLoader), sys.stdout, indent=2)' < ${YAML} > config.json

config=$(jq -Mc '.' config.json)

num_backup=$(echo "${config}" | jq '. | length')


target_type=""
if [ "$#" -eq 1 ]; then
  if [ "$1" = "GR" -o "$1" = "BS" -o "$1" = "CS" ]; then
    target_type=$1
  else
    echo "invalid argument"
  fi
fi

for ((i=0; i < ${num_backup}; i++)); do
  # パラメータを取り出して変数に格納
  name=$(echo "${config}" | jq -r ".[$i].name | select(. != null)")
  type=$(echo "${config}" | jq -r ".[$i].type | select(. != null)")
  channel=$(echo "${config}" | jq -r ".[$i].channel | select(. != null)")
  sid=$(echo "${config}" | jq -r ".[$i].serviceId | select(. != null)")

  if [ -z "${name}" ] || [ -z "${type}" ] || [ -z "${channel}" ]; then
    continue
  fi

  if [ "${target_type}" = "" ]; then
    echo "####################################################################"
    if [ -z "${sid}" ]; then
      echo "# starting ${name} ${type} ${channel}"
      echo "####################################################################"
      filename=${type}_${channel}
      ../../recdvb/recdvb --b25 --strip --sid hd ${channel} 10 ${filename}.ts
    else
      echo "# starting ${name} ${type} ${channel} ${sid}"
      echo "####################################################################"
      filename=${type}_${channel}_${sid}
      ../../recdvb/recdvb --b25 --strip --sid ${sid} ${channel} 10 ${filename}.ts
    fi
  elif [ "${target_type}" = "${type}" ]; then
    echo "####################################################################"
    if [ -z "${sid}" ]; then
      echo "# starting ${name} ${type} ${channel}"
      echo "####################################################################"
      filename=${type}_${channel}
      ../../recdvb/recdvb --b25 --strip --sid hd ${channel} 10 ${filename}.ts
    else
      echo "# starting ${name} ${type} ${channel} ${sid}"
      echo "####################################################################"
      filename=${type}_${channel}_${sid}
      ../../recdvb/recdvb --b25 --strip --sid ${sid} ${channel} 10 ${filename}.ts
    fi
    sleep 1
    ls -ltr ${filename}.ts
  fi

done
cp *.ts /mnt/tvdata
