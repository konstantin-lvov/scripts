#!/bin/bash
# SSH HELPER 0.1 beta
# /etc/ssh/ssh_config -> HashKnownHosts must be 'no'
# script will filter the occurance in known_hosts ssh config file
# and print them as list for selection and connection via ssh

ALL_HOSTS=($(cat ~/.ssh/known_hosts | sed 's/,/ /g' | awk '{print $1}'))

IPS=""
NAMES=""
WITH_PORTS=""
MODE=$(echo $1)

for str in ${ALL_HOSTS[@]}; do
  TEMP_IP=$(echo $str | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
  TEMP_NAME=$(echo $str | grep -E '[a-zA-Z]' | sed -E 's/\[[a-zA-Z0-9.]*\]:[0-9]+//g')
  TEMP_WITH_PORT=$(echo $str | grep -oE '\[[a-zA-Z0-9.]+\]:[0-9]+')

  if [[ $MODE == "debug" ]]; then
    echo "[HANDLED LINE IS $str]"
    echo "==>TEMP_IP $TEMP_IP"
    echo "==>TEMP_NAME $TEMP_NAME"
    echo "==>TEMP_WITH_PORT $TEMP_WITH_PORT"
  fi
 
  if [[ $TEMP_IP != "" ]]; then
    IPS=$(echo "$IPS $TEMP_IP")
  fi
  if [[ $TEMP_NAME != "" ]]; then
    NAMES=$(echo "$NAMES $TEMP_NAME")
  fi
  if [[ $TEMP_WITH_PORT != "" ]]; then
    WITH_PORTS=$(echo "$WITH_PORTS $TEMP_WITH_PORT")
  fi
  TEMP_IP=""
  TEMP_NAME=""
  TEMP_WITH_PORT=""
done

if [[ $MODE == "debug" ]]; then
  echo '[IPS]'
  echo $IPS
  echo '[NAMES]'
  echo $NAME
  echo '[WITH_PORTS]'
  echo $WITH_PORTS
fi

if [[ $IPS != "" ]]; then
  IPS=$(echo $IPS | sed 's/ /\n/g' | sed 's/$/:22/g' | sort | uniq)
fi
if [[ $NAMES != "" ]]; then
  NAMES=$(echo $NAMES | sed 's/ /\n/g' | sed 's/$/:22/g' | sort | uniq)
fi
if [[ $WITH_PORTS != "" ]]; then
  WITH_PORTS=$(echo $WITH_PORTS | sed 's/ /\n/g' | sed 's/\[//g' | sed 's/\]//g' | sort | uniq)
fi

if [[ $MODE == "debug" ]]; then
  echo '[IPS]'
  echo $IPS
  echo '[NAMES]'
  echo $NAMES
  echo '[WITH_PORTS]'
  echo $WITH_PORTS
fi

ALL_FILTRED_HOSTS=($(echo "$IPS $NAMES $WITH_PORTS"))

if [[ $MODE == "debug" ]]; then
  echo '[ALL_FILTRED_HOSTS]'
  for str in ${ALL_FILTRED_HOSTS[@]}; do
    echo $str
  done
fi

echo "Witch of them do you choose:"
for i in ${!ALL_FILTRED_HOSTS[@]}; do
  echo "Host $((i+1)) is ${ALL_FILTRED_HOSTS[i]}"
done

read CHOOSE
CHOOSE=$(echo "$((CHOOSE-1))")
if [[ $MODE == "debug" ]]; then
  echo "CHOOSED INDEX is $CHOOSE"
fi

echo "Username:"
read USERNAME

TARGET_HOST=$(echo ${ALL_FILTRED_HOSTS[CHOOSE]} | sed 's/:/ /' | awk '{ print $1}')
TARGET_PORT=$(echo ${ALL_FILTRED_HOSTS[CHOOSE]} | sed 's/:/ /' | awk '{ print $2}')
if [[ $MODE == "debug" ]]; then
  echo "TARGET HOST IS $TARGET_HOST, TARGET PORT IS $TARGET_PORT"
fi

exec ssh -p $TARGET_PORT $USERNAME@$TARGET_HOST
