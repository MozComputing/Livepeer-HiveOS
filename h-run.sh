#!/usr/bin/env bash

cd `dirname $0`

. h-manifest.conf
. colors

url_nvidia_patch="https://github.com/keylase/nvidia-patch"

echo -e "${YELLOW}> Downloading ${url_nvidia_patch}${NOCOLOR}"
git clone "$url_nvidia_patch"

chown -R user ./nvidia-patch/patch.sh
chown -R user ./nvidia-patch/patch-fbc.sh
chmod +x ./nvidia-patch/patch.sh
chmod +x ./nvidia-patch/patch-fbc.sh

echo -e "${GREEN}Patching nvidia driver...${NOCOLOR}"

./nvidia-patch/patch.sh
./nvidia-patch/patch-fbc.sh

rm ./nvidia-patch -rf

latestVersion=$(curl --silent "https://api.github.com/repos/livepeer/go-livepeer/releases/latest" |
  grep '"tag_name":' |
  sed -E 's/.*"([^"]+)".*/\1/')

if [[ "$(cat version)" != "$latestVersion" ]]; then
  echo -e "${GREEN}New livepeer version found: ${latestVersion}${NOCOLOR}"

  url="https://github.com/livepeer/go-livepeer/releases/download/${latestVersion}/livepeer-linux-amd64.tar.gz"
  basename=`basename -s .tar.gz "$url"`
  archname=`basename "$url"`

  echo -e "${YELLOW}> Downloading ${url}${NOCOLOR}"
  wget -c "$url"
  echo -e "${YELLOW}> Unpacking ${archname}${NOCOLOR}"
  tar -xzv -f $archname
  mv $basename/livepeer ./livepeer

  chown -R user ./livepeer
  chmod +x ./livepeer
  rm $basename -rf
  rm $archname -f

  echo "$latestVersion" > ./version
fi

[[ -z $CUSTOM_LOG_BASENAME ]] && echo -e "${RED}No CUSTOM_LOG_BASENAME is set${NOCOLOR}" && exit 1
[[ -z $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}No CUSTOM_CONFIG_FILENAME is set${NOCOLOR}" && exit 1
[[ ! -f $CUSTOM_CONFIG_FILENAME ]] && echo -e "${RED}Custom config ${YELLOW}$CUSTOM_CONFIG_FILENAME${RED} is not found${NOCOLOR}" && exit 1
CUSTOM_LOG_BASEDIR=$(dirname "$CUSTOM_LOG_BASENAME")
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p "$CUSTOM_LOG_BASEDIR"

./livepeer $(< /hive/miners/custom/$CUSTOM_NAME/$CUSTOM_NAME.conf) $@ 2>&1 | tee "$CUSTOM_LOG_BASENAME".log
