#!/usr/bin/env bash

set -Ee

function _run() {
  if [[ "$QUIET" ]]; then
    echo "$*"
  else
    eval "$@"
  fi
}


# install build requirements
./build-host-setup_debian.sh
# create pyinstall executable
./build.sh
# create debian package
./package_deb.sh

# this version number is not based on any reality, needs to be changed
ARCH=armhf
VERSION=0.1.0
# upload to s3
cd ./dist
_run s3cmd -c ${HOME}/.s3cfg.mycroft-artifact-writer sync --acl-public . s3://bootstrap.mycroft.ai/artifacts/apt/daily/${ARCH}/wifi-setup-client/${VERSION}/
echo ${VERSION} > latest
_run s3cmd -c ${HOME}/.s3cfg.mycroft-artifact-writer put --acl-public ./latest s3://bootstrap.mycroft.ai/artifacts/apt/daily/${ARCH}/wifi-setup-client/latest
