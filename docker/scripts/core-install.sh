#!/usr/bin/env bash
bash docker/scripts/message.sh headline "This script installs WordPress Core"
bash docker/scripts/message.sh info "Provide the following values:"

read -e -r -p "Title: " title
read -e -r -p "Admin User: " admin
read -e -r -s -p "Admin Password: " pass1
read -e -r -s -p "Confirm Password: " pass2
read -e -r -p "Delete all themes except active? [N/y]: " themeDelete
[[ "$themeDelete" =~ ^([yY][eE][sS]|[yY])$ ]] && themeDelete=true || themeDelete=false
read -e -r -p "Delete all plugins? [N/y]: " pluginDelete
[[ "$pluginDelete" =~ ^([yY][eE][sS]|[yY])$ ]] && pluginDelete=true || pluginDelete=false

bash docker/scripts/message.sh text ""

if [[ "$pass1" != "$pass2" ]]; then
  bash docker/scripts/message.sh warning "Error: Wrong password"
  return 2>/dev/null || exit 0
fi

bash docker/scripts/message.sh headline "Installing WordPress Core with following values:"
bash docker/scripts/message.sh text ""
bash docker/scripts/message.sh text "URL                        $1"
bash docker/scripts/message.sh text "Title                      $title"
bash docker/scripts/message.sh text "Admin User                 $admin"
bash docker/scripts/message.sh text "Admin Password             $pass2"
bash docker/scripts/message.sh text "Admin Email                $2"
bash docker/scripts/message.sh text "Delete non-active themes?  $themeDelete"
bash docker/scripts/message.sh text "Delete all plugins?        $pluginDelete"
bash docker/scripts/message.sh text ""

bash docker/scripts/message.sh info "Installing WordPress Core..."
docker-compose run --rm wpcli core install --url=$1 --title=$title --admin_user=$admin --admin_password=$pass2 --admin_email=$2

if [[ "$themeDelete" ]]; then
  bash docker/scripts/message.sh info "Deleting non-active themes..."
  docker-compose run --rm wpcli theme delete --all
fi

if [[ "$pluginDelete" ]]; then
  bash docker/scripts/message.sh info "Deleting all plugins:"
  docker-compose run --rm wpcli plugin uninstall --all
fi
