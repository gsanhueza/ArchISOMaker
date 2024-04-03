#!/usr/bin/env bash

BASEDIR=$(dirname "$0")
source "${BASEDIR}/banned_recipes.sh"

RECIPES_DIR="airootfs/root/ArchScripts/recipes"
ALL_PACKAGES=""

for path in $(find ${RECIPES_DIR} -name "*.sh")
do
    # Skip packages if recipe is banned
    recipe=${path##*/}
    [[ ${BANNED_RECIPES} == *"${recipe}"* ]] && continue

    source ${path}
    export ALL_PACKAGES="${ALL_PACKAGES} ${RECIPE_PKGS}"
done
