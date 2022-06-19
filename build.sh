#!/usr/bin/env bash
#
# SPDX-License-Identifier: GPL-3.0-or-later

# Custom tools
source "custom_tools.sh"

# On failure, immediately stop building the ISO
set -e -u

# Make ${work_dir} directory
mkdir -p "${work_dir}"

# Generate local repo
run_once make_local_repo

# Run mkarchiso
#printf '\n[%s] WARNING: %s\n\n' "mkarchiso" "build.sh scripts are deprecated! Please use mkarchiso directly." >&2
_buildsh_path="$(realpath -- "$0")"
mkarchiso "$@" "${_buildsh_path%/*}"

# Remove ${work_dir} folder
wrap_up
