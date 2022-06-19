#!/usr/bin/env bash

RECIPES_DIR="airootfs/root/ArchScripts/recipes"
ALL_PACKAGES=""

for recipe_file in $(find ${RECIPES_DIR} -name "*.sh")
do
    source ${recipe_file}
    export ALL_PACKAGES="${ALL_PACKAGES} ${RECIPE_PKGS}"
done
