#!/bin/bash
# this shell script is used to create a new worpress project
# using the wp-cli tool
#
# if the current folder is not a wordpress installation

# import the colors.sh file
source colors.sh

if [ ! -f wp-config.php ]; then
    echo -e "${RED}This is not a wordpress installation${NC}"
    echo ""
    read -p "$(echo -e ${PURPLE}Enter the folder name or full path for the project:${NC}) " foldername

    cd $foldername
fi
echo ""

echo -e "${YELLOW}Listing themes${NC}"

wp theme list
echo ""

read -p "$(echo -e ${PURPLE}Do you want to delete all the themes except the default theme? [y/n]:${NC}) " deletethemes

if [ $deletethemes == "y" ]; then

    echo -e "${YELLOW}Deleting themes${NC}"

    wp theme delete $(wp theme list --status=inactive --field=name)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Themes deleted${NC}"
    else
        echo -e "${RED}Themes deletion failed${NC}"
    fi
fi
echo ""

echo -e "${YELLOW}Installing plugins${NC}"

plugins=("wordpress-seo" "akismet" "wp-super-cache")

for i in "${plugins[@]}"; do
    wp plugin install $i --activate
    echo ""

done
wp plugin list
echo ""

read -p "$(echo -e ${PURPLE}Enter the number of categories:${NC}) " numcategories
echo ""

echo -e "${YELLOW}Creating categories${NC}"
echo ""

categoryname=("lorem" "ipsum" "dolor" "sit" "amet" "consectetur" "adipiscing" "elit" "sed" "do" "eiusmod" "tempor" "incididunt" "ut" "labore" "et" "dolore" "magna" "aliqua" "ut" "enim" "ad" "minim" "veniam")

childcategoryname=("quis" "nostrud" "exercitation" "ullamco" "laboris" "nisi" "ut" "aliquip" "ex" "ea" "commodo" "consequat" "duis" "aute" "irure" "dolor" "in" "reprehenderit" "in" "voluptate" "velit" "esse" "cillum" "dolore" "eu" "fugiat" "nulla" "pariatur" "excepteur" "sint")

categorydescription=$(curl -s https://loripsum.net/api/1/short/headers/plaintext)

for ((i = 1; i <= $numcategories; i++)); do

    wp term create category ${categoryname[$i]} --description="$categorydescription"
done
echo ""

read -p "$(echo -e ${PURPLE}Enter the number of child categories:${NC}) " numchildcategories
echo ""

for ((i = 1; i <= $numchildcategories; i++)); do
    categories=$(wp term list category --field=term_id)

    parentcategory=$(echo $categories | cut -d' ' -f$i)

    wp term create category ${childcategoryname[$i]} --description="$categorydescription" --parent=$parentcategory
done
echo ""

echo -e "${YELLOW}Creating pages${NC}"

# array of pages to create
pages=("home" "about" "contact" "faqs" "services")

for i in "${pages[@]}"; do

    pagetitle=$(echo $i | sed 's/\b\(.\)/\u\1/g')

    pagecontent=$(curl -s https://loripsum.net/api/10/short/headers/ol/link/bl/ul/bq/code/prude/medium)

    wp post create --post_type=page --post_title="$pagetitle" --post_content="$pagecontent" --post_status=publish
done
echo ""

read -p "$(echo -e ${PURPLE}Enter the number of posts:${NC}) " numposts

echo -e "${YELLOW}Creating posts${NC}"
echo ""

for ((i = 1; i <= $numposts; i++)); do

    posttitle=$(curl -s http://loripsum.net/api/1/short/headers/plaintext | awk '{print $1$2$3$4$5$6$7$8$9$10}')

    postcontent=$(curl -s https://loripsum.net/api/10/short/headers/ol/link/bl/ul/bq/code/prude/medium)

    category=$(wp term list category --field=term_id)

    categoryid=$(echo $category | cut -d' ' -f1)

    wp post create --post_title="$posttitle" --post_content="$postcontent" --post_status=publish --post_category=$categoryid
done

echo ""

echo -e "${YELLOW}Creating users${NC}"

users=("Administrator" "Editor" "Subscriber" "Seo-manager" "External")

for i in "${users[@]}"; do

    if wp role exists $i; then
        echo -e "${RED}Role $i already exists${NC}"
        continue
    fi

    wp role create $i $i
done

echo ""

for i in "${users[@]}"; do

    username=$(echo $i)

    useremail=$(echo $i | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')@example.com

    displaynames=("John Doe" "Jane Doe" "John Smith" "Jane Smith" "John Brown" "Jane Brown" "John Black" "Jane Black" "John White" "Jane White" "John Green" "Jane Green" "John Blue" "Jane Blue" "John Yellow" "Jane Yellow" "John Orange" "Jane Orange" "John Purple" "Jane Purple")
    # create the user
    wp user create $username $useremail --role=$username --display_name="${displaynames[$RANDOM % ${#displaynames[@]}]}"
done
echo ""

echo -e "${GREEN}---------- Done ----------${NC}"
