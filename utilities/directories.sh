#!/usr/bin/env bash

BASE_DIR=`dirname $(readlink -f $0)`

export WORK_DIR="${BASE_DIR}/work"
export OUT_DIR="${BASE_DIR}/out"
export TEMP_MNT="${BASE_DIR}/TEMPMNT"
export PKG_CACHE_DIR="${BASE_DIR}/airootfs/root/pkg"
export RECIPES_DIR="${BASE_DIR}/airootfs/root/ArchScripts/recipes"
