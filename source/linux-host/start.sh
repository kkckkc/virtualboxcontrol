#!/bin/bash

source `dirname $(readlink -f $0)`/../../etc/settings.conf
source `dirname $(readlink -f $0)`/common.sh

virtualBoxStart "$1"

