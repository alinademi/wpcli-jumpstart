#!/bin/bash
# this shell script is used to create a new worpress project
# using the wp-cli tool
#
# Path: test.sh

# import the colors.sh file
source colors.sh

read -p "$(echo -e ${PURPLE}Enter the folder name for the project:${NC}) " foldername

git init $foldername

curl -L https://www.gitignore.io/api/wordpress >$foldername/.gitignore

cd $foldername

wp core download

echo ""

read -p "$(echo -e ${PURPLE}Enter the database name:${NC}) " dbname
echo ""

read -p "$(echo -e ${PURPLE}Enter the database user:${NC}) " dbuser

echo ""

echo -e "${YELLOW}Creating wp-config.php ...${NC}"

echo ""

wp config create --dbname=$dbname --dbuser=$dbuser

if [ $? -eq 0 ]; then
    echo -e "${GREEN}wp-config.php created${NC}"
else
    echo -e "${RED}wp-config.php creation failed, restarting mysql might fix this :)${NC}"
fi

echo -e "${YELLOW}Creating database${NC}"

wp db create
echo ""

echo -e "${YELLOW}Installing wordpress... ⏱️${NC}"

echo ""

read -p "$(echo -e ${PURPLE}Enter the site title:${NC}) " sitetitle

echo ""

read -p "$(echo -e ${PURPLE}Enter the site url:${NC}) " url

echo ""

read -p "$(echo -e ${PURPLE}Enter the admin user:${NC}) " adminuser

echo ""

read -sp "$(echo -e ${PURPLE}Enter the admin password:${NC}) " adminpass

echo ""

read -p "$(echo -e ${PURPLE}Enter the admin email:${NC}) " adminemail

echo ""

wp core install --url=$url --title=$sitetitle --admin_user=$adminuser --admin_password=$adminpass --admin_email=$adminemail --skip-email

echo ""

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Wordpress installed${NC}"
else
    echo -e "${RED}Wordpress installation failed${NC}"
fi
echo ""

read -p "$(echo -e ${PURPLE}Do you want to run the built-in server? [y/n]:${NC}) " runserver

echo ""

if [ $runserver == "y" ]; then
    echo -e "${YELLOW}Running server${NC}"

    echo ""

    read -p "$(echo -e ${PURPLE}Enter the host:${NC}) " host

    echo ""

    read -p "$(echo -e ${PURPLE}Enter the port:${NC}) " port

    read -p "$(echo -e ${PURPLE}Enter the protocol [http/https]:${NC}) " protocol

    echo ""

    wp server --host=$host --port=$port

    open $protocol//$host:$port
else

    exit

fi

echo -e "${GREEN}---------- Done ----------${NC}"
