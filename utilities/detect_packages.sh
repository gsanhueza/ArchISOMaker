#!/usr/bin/env bash

BASE_DIR=`dirname $(readlink -f $0)`
source "${BASE_DIR}/utilities/directories.sh"
source "${BASE_DIR}/utilities/banned_recipes.sh"

ALL_PACKAGES=""

for path in $(find ${RECIPES_DIR} -name "*.sh")
do
    # Skip packages if recipe is banned
    recipe=${path##*/}
    [[ ${BANNED_RECIPES} == *"${recipe}"* ]] && continue

    source ${path}
    export ALL_PACKAGES="${ALL_PACKAGES} ${RECIPE_PKGS}"
done
