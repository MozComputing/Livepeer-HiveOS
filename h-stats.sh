#!/usr/bin/env bash

. /hive/miners/custom/livepeer/h-manifest.conf
LOG_NAME="$CUSTOM_LOG_BASENAME.log"

[[ -z $GPU_COUNT_NVIDIA ]] &&
  GPU_COUNT_NVIDIA=$(gpu-detect NVIDIA)

gpu_stats=$(cat $GPU_STATS_JSON)
gpu_busid=(`cat /var/run/hive/gpu-detect.json | jq -r '.[] | select(.brand == "nvidia") | .busid' | cut -d ':' -f 1`)
nvidia_indexes_array=(`echo "$gpu_stats" | jq '.brand | to_entries[] | select(.value == "nvidia") | .key' | jq -sc '.'`)
gpu_selected_indexes_array=(`cat $LOG_NAME | head -n 10 | grep -a 'Transcoding on these Nvidia devices:' | grep -o '\[.*\]' | tr -d '[]'`)

if [ -z $gpu_selected_indexes_array ]; then
  for (( i=0; i<$GPU_COUNT_NVIDIA; i++ )); do
    gpu_selected_indexes_array+=($i+1)
  done
fi

#######################
# Functions
#######################

get_cards_hashes(){
  hs=()
  for (( i=0; i<${#gpu_selected_indexes_array[@]}; i++ )); do
    hs[i]="\"1\""
  done
}

get_nvidia_cards_temp(){
  echo $(jq -c "[.temp$nvidia_indexes_array]" <<< $gpu_stats)
}

get_nvidia_cards_fan(){
  echo $(jq -c "[.fan$nvidia_indexes_array]" <<< $gpu_stats)
}

get_cards_busid(){
  busids=()
  for gpu in "${gpu_selected_indexes_array[@]}"; do
    busids+=(${gpu_busid[$gpu]})
  done
}

#######################
# MAIN script body
#######################

get_cards_hashes
get_cards_busid

bus_numbers=$(echo ${busids[@]} | jq -cs '.')
hs=$(echo ${hs[@]} | tr " " "\n" | jq -cs '.')
hs_units="hs"
temp=$(get_nvidia_cards_temp)
fan=$(get_nvidia_cards_fan)
algo="Livepeer"
ver=$(cat /hive/miners/custom/livepeer/version)

khs=0.00${#gpu_selected_indexes_array[@]}
stats=$(jq -nc \
  --argjson bus_numbers $bus_numbers \
  --argjson hs $hs \
  --arg hs_units "$hs_units" \
  --argjson temp $temp \
  --argjson fan $fan \
  --arg algo "$algo" \
  --arg ver "$ver" \
  '{$bus_numbers, $hs, $hs_units, $temp, $fan, $algo, $ver}')

# debug output
#echo temp:  $temp
#echo fan:   $fan
#echo stats: $stats
#echo khs:   $khs
