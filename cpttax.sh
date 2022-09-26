#!/bin/bash

source colors.sh

if [ ! -f wp-config.php ]; then
   echo -e "${RED}This is not a wordpress installation${NC}"

   echo ""

   read -p "$(echo -e ${PURPLE}Enter the folder name or full path for the project:${NC}) " foldername

   cd $foldername
fi

echo ""

echo -e "${YELLOW}Creating plugin to register custom post types and taxonomies${NC}"

read -p "$(echo -e ${PURPLE}Enter the name of the plugin to create:${NC}) " pluginname

wp scaffold plugin $pluginname --activate

read -p "$(echo -e ${PURPLE}Enter the name of the custom post types to create [comma separated]:${NC})" cptnames

for cptname in $(echo $cptnames | sed "s/,/ /g"); do

   wp scaffold post-type $cptname --plugin=$pluginname --force

   for ((i = 1; i <= 5; i++)); do

      posttitle=$(curl -s http://loripsum.net/api/1/short/headers/plaintext | awk '{print $1$2$3$4$5$6$7$8$9$10}')

      postcontent=$(curl -s https://loripsum.net/api/10/short/headers/ol/link/bl/ul/bq/code/prude/medium)

      wp post create --post_type=$cptname --post_title="$posttitle" --post_content="$postcontent" --post_status=publish
   done
done

echo -e "${YELLOW}Adding code to the main plugin file to include the cpt files${NC}"

pluginfilepath=$(wp plugin path $pluginname)

plugindirpath=$(echo $pluginfilepath | sed "s/\/$pluginname.php//g")

for file in $(ls $plugindirpath/post-types); do

   echo "include_once plugin_dir_path(__FILE__) . 'post-types/$file';" >>$pluginfilepath

done

echo -e "${GREEN}---------- Done ----------${NC}"
