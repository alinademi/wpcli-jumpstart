#!/bin/bash
# this shell script is used to create a new worpress project
# using the wp-cli tool
#
# Path: test.sh
# step 1: create a new project
# step 2: create a new database
# step 3: install wordpress
# step 4: install plugins
# step 5: activate plugins
# step 6: install theme
# step 7: activate theme
# step 8: message to user that the project is ready

# import the colors.sh file
source colors.sh

# prompt for folder name and download wordpress into it, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the folder name for the project:${NC}) " foldername
# enter the folder
# generate a git repo in the folder
git init $foldername
# create a wordpress gitignore file in the folder from gitigore.io
curl -L https://www.gitignore.io/api/wordpress >$foldername/.gitignore

cd $foldername
# download wordpress into the current folder
wp core download
# # when done downloading, message to user that the download is complete, message color is green
# if [ $? -eq 0 ]; then
#     echo -e "${GREEN}Download Complete${NC}"
# else
#     echo -e "${RED}Download Failed${NC}"
# fi
#add an empty line here
echo ""

# prompt for database name, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the database name:${NC}) " dbname
echo ""
# prompt for database user, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the database user:${NC}) " dbuser
echo ""
# prompt for database password, prompt color is purple, password is hidden
# read -sp "$(echo -e ${PURPLE}Enter the database password:${NC}) " dbpass
# echo ""
# message to user that wp config is being created, message color is yellow
echo -e "${YELLOW}Creating wp-config.php${NC}"
echo ""
# if can't create wp-config.php, message to user that wp config failed, message color is red, possible fix is to restart mysql
# also set wp debug to true
# if ! wp core config --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpass --extra-php <<PHP
# define( 'WP_DEBUG', true );
# define( 'WP_DEBUG_LOG', true );
# define( 'WP_DEBUG_DISPLAY', false );
# PHP
# then
#     echo -e "${RED}wp config failed${NC}"
#     exit 1
# fi

# # restart mysql service
# brew services restart mysql
# # message to user that mysql is restarting, message color is yellow
# echo -e "${YELLOW}Restarting mysql${NC}"
# # if mysql restart fails, message to user that mysql restart failed, message color is red
# if ! brew services restart mysql; then
#     echo -e "${RED}mysql restart failed${NC}"
#     exit 1
# fi

# set the wp debug to true
wp config create --dbname=$dbname --dbuser=$dbuser

if [ $? -eq 0 ]; then
    echo -e "${GREEN}wp-config.php created${NC}"
else
    echo -e "${RED}wp-config.php creation failed, restarting mysql might fix this :)${NC}"
fi

# now create the database, message color is yellow
echo -e "${YELLOW}Creating database${NC}"
# use wp-cli to create the database, message color is green
wp db create
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Database created${NC}"
else
    echo -e "${RED}Database creation failed${NC}"
fi
echo ""
# now install wordpress, message color is yellow
echo -e "${YELLOW}Installing wordpress${NC}"
echo ""
# prompt for site title, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the site title:${NC}) " sitetitle
echo ""
# prompt for url, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the site url:${NC}) " url
echo ""
# prompt for admin user, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the admin user:${NC}) " adminuser
echo ""
# prompt for admin password, prompt color is purple, password is hidden
read -sp "$(echo -e ${PURPLE}Enter the admin password:${NC}) " adminpass
echo ""
# prompt for admin email, prompt color is purple
read -p "$(echo -e ${PURPLE}Enter the admin email:${NC}) " adminemail
echo ""
# install wordpress, message color is green
wp core install --url=$url --title=$sitetitle --admin_user=$adminuser --admin_password=$adminpass --admin_email=$adminemail --skip-email
echo ""
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Wordpress installed${NC}"
else
    echo -e "${RED}Wordpress installation failed${NC}"
fi
echo ""

# ask user if they want to run the built-in server, prompt color is purple
read -p "$(echo -e ${PURPLE}Do you want to run the built-in server? [y/n]:${NC}) " runserver
echo ""
# if user says yes, run the built-in server
if [ $runserver == "y" ]; then
    echo -e "${YELLOW}Running server${NC}"
    echo ""
    #promp for host, prompt color is purple
    read -p "$(echo -e ${PURPLE}Enter the host:${NC}) " host
    echo ""
    # prompt for port, prompt color is purple
    read -p "$(echo -e ${PURPLE}Enter the port:${NC}) " port
    # ask for the protocol, prompt color is purple
    read -p "$(echo -e ${PURPLE}Enter the protocol [http/https]:${NC}) " protocol
    echo ""
    wp server --host=$host --port=$port
    # open the browser tab
    open $protocol//$host:$port
else
    exit
fi

# now run the server, wp server is a built in command that runs a local server
# message color is yellow

# run the server, message color is green
# wp server
# if [ $? -eq 0 ]; then
#     echo -e "${GREEN}Server running${NC}"
# else
#     echo -e "${RED}Server failed to run${NC}"
# fi
# echo ""
