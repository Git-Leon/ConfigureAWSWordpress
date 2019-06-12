#!/bin/bash
source ./import_utils.sh

backupApacheHTTPServerKey() {
  sudo cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak
}

bindApacheHTTPServerTo8080() {
  sudo sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf
}

changeVirtualHostPort() {
  sudo echo -e "<VirtualHost *:8080>\n    DocumentRoot /var/www/html\n</VirtualHost>" | sudo tee -a /etc/httpd/conf/httpd.conf
}

restartApacheServer() {
  sudo service httpd restart && sudo service httpd status
}

# switch the Apache HTTP Server to use the WordPress website's root directory
setServerRootDirectory() {
  sudo sed -i 's/<Directory "\/var\/www\/html">/<Directory "\/home\/ec2-user\/environment\/wordpress">/g' /etc/httpd/conf/httpd.conf
}

# Switch the Apache HTTP Server to specify using the document root for the WordPress website
setDocumentRoot() {
  sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/home\/ec2-user\/environment\/wordpress/g' /etc/httpd/conf/httpd.conf
}

createWebContentGroup() {
  sudo groupadd web-content # Create a group named web-content.
}

addEC2User() {
  sudo usermod -G web-content -a ec2-user # Add the user ec2-user (your default user for this environment) to the group web-content.
}

addApacheUser() {
  sudo usermod -G web-content -a apache # Add the user apache (Apache HTTP Server) to the group web-content.
}

changeWordpressEnvironmentOwner() {
  sudo chown -R ec2-user:web-content /home/ec2-user/environment/wordpress # Change the owner of /home/ec2-user/environment/wordpress and its files to user ec2-user and group web-content.
}

changeWordpressEnvironmentPermissions() {
  sudo find /home/ec2-user/environment/wordpress -type f -exec chmod u=rw,g=rx,o=rx {} \; # Change all file permissions within /home/ec2-user/environment/wordpress to user read/write, group read-only, and others read/execute.
  sudo find /home/ec2-user/environment/wordpress -type d -exec chmod u=rwx,g=rx,o=rx {} \; # Change /home/ec2-user/environment/wordpress directory permissions to user read/write/execute, group read/execute, and others read/execute.
}

printNextStep() {
  echo View the WordPress website from within the AWS Cloud9 IDE.
  echo To do this, on the main menu bar, choose Preview, Preview Running Application.
  echo A new window opens in the IDE and displays a Not Found page. This is expected at this point.
  echo Open the WordPress website in a new tab within the same web browser as the AWS Cloud9 IDE.
  echo To do this, on the address bar in the new window, choose Pop Out Into New Window.
  echo The new tab displays the same Not Found page, which is still expected at this point.
  echo In the new tab within the same web browser as the AWS Cloud9 IDE, add /index.php to the end of the existing URL, and then press Enter.
  echo The WordPress websites home page is displayed
}


execute() {
  echo creating web content group
  if promptUser $1; then createWebContentGroup; fi

  echo adding EC2 user
  if promptUser $1; then addEC2User; fi

  echo adding apache user
  if promptUser $1; then addApacheUser; fi

  echo changing wordpress environment owner
  if promptUser $1; then changeWordpressEnvironmentOwner; fi

  echo changing wordpress environment permissions
  if promptUser $1; then changeWordpressEnvironmentPermissions; fi

  echo restarting apache server
  if promptUser $1; then restartApacheServer; fi

  printNextStep
}

execute
