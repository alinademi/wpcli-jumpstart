#!/bin/bash
# Path: start.sh
# https://gist.github.com/sergiofbsilva/099172ea597657b0d0008dc367946953
source multiselect.sh

OPTIONS_VALUES=("1" "2" "3" "4" "5")

OPTIONS_LABELS=("Install WordPress" "Seed database with posts & pages" "Create custom post-types and taxonomies" "All" "None")

declare OPTIONS_FILES
OPTIONS_FILES["1"]="./wp-install.sh"
OPTIONS_FILES["2"]="./seed.sh"
OPTIONS_FILES["3"]="./cpttax.sh"

for i in "${!OPTIONS_VALUES[@]}"; do

   OPTIONS_STRING+="${OPTIONS_VALUES[$i]} (${OPTIONS_LABELS[$i]});"

done

prompt_for_multiselect SELECTED "$OPTIONS_STRING"

for i in "${!SELECTED[@]}"; do

   if [ "${SELECTED[$i]}" == "true" ]; then

      CHECKED+=("${OPTIONS_VALUES[$i]}")

   fi

done

# trying to makeit work in zsh
for i in "${!CHECKED[@]}"; do

   bash ${OPTIONS_FILES[${CHECKED[$i]}]}

done
