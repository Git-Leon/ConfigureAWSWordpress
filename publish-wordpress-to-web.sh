#!/bin/bash
source ~/environment/aws-wordpress-installation/import_utils.sh
#source ./import_utils.sh

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
  echo -e "\nRun the WordPress website from within the AWS Cloud9 IDE by pressing \`Run\` from the top menu bar"
  echo "View the WordPress website from within the AWS Cloud9 IDE."
  echo "To do this, on the main menu bar, choose 'Preview' > 'Preview Running Application'"
  echo "A new window opens in the IDE and displays a 'Not Found' page."
  echo -e "\tThis is expected at this point!"
  echo "Open the WordPress website in a new tab by selecting 'Pop Out Into New Window' on the address bar."
  echo "The new tab displays the same 'Not Found' page."
  echo -e "\tThis is still expected at this point!"
  echo "In the new tab add \`/index.php\` to the end of the existing URL, and then press Enter."
  echo "The WordPress websites home page is displayed"
}



execute() {
  kill8080

  echo Part 4, Step 2 - backing up copies of key Apache HTTP Server configuration files
  if promptUser $1; then backupApacheHTTPServerKey; fi

  echo Part 4, Step 3 - binding Apache HTTP Server to port 8080, instead of the default port of 80.
  if promptUser $1; then bindApacheHTTPServerTo8080; fi

  echo Part 4, Step 4 - changing virtual host settings to listen on port 8080
  if promptUser $1; then changeVirtualHostPort; fi

  echo Part 4, Step 5 - restarting Apache HTTP Server to have it use the new settings
  if promptUser $1; then restartApacheServer; fi

  echo Part 4, Step 6 and 7 - setting Apache HTTP Server to use the WordPress websites root directory
  if promptUser $1; then setServerRootDirectory; fi

  echo Part 4, Step 6 and 7 - setting document root
  if promptUser $1; then setDocumentRoot; fi

  echo Part 4, Step 9A - creating web content group
  if promptUser $1; then createWebContentGroup; fi

  echo Part 4, Step 9B - adding EC2 user
  if promptUser $1; then addEC2User; fi

  echo Part 4, Step 9C - adding apache user
  if promptUser $1; then addApacheUser; fi

  echo Part 4, Step 9D - changing wordpress environment owner
  if promptUser $1; then changeWordpressEnvironmentOwner; fi

  echo Part 4, Step 9E - changing wordpress environment permissions
  if promptUser $1; then changeWordpressEnvironmentPermissions; fi


  echo Part 4, Step 10 - restarting Apache HTTP Server to have it use the new settings
  if promptUser $1; then restartApacheServer; fi

  printNextStep
}

execute
