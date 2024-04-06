#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

BASE_PATH=$(readlink -f $0)
BASE_DIR=`dirname $BASE_PATH`

# Custom tools
source "${BASE_DIR}/utilities/directories.sh"
source "${BASE_DIR}/utilities/custom_tools.sh"

# On failure, immediately stop building the ISO
set -e -u

# Make ${WORK_DIR} directory
mkdir -p "${WORK_DIR}"

# Generate local repo
run_once make_local_repo

# Run mkarchiso
#printf '\n[%s] WARNING: %s\n\n' "mkarchiso" "build.sh scripts are deprecated! Please use mkarchiso directly." >&2
mkarchiso "$@" "${BASE_PATH%/*}"

# Remove ${WORK_DIR} folder
wrap_up
