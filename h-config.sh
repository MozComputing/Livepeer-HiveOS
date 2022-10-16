#!/usr/bin/env bash

[[ -z $CUSTOM_USER_CONFIG ]] && echo -e "${YELLOW}CUSTOM_USER_CONFIG is empty${NOCOLOR}" && return 1

conf="${CUSTOM_USER_CONFIG}"

[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && return 1
echo "$conf" > "$CUSTOM_CONFIG_FILENAME"
