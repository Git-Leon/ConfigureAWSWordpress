#!/bin/bash
source ~/environment/aws-wordpress-installation/import_utils.sh
#source ./import_utils.sh

updateSecurity() {
  sudo yum -y update
}


installApacheServer() {
  sudo yum install -y httpd24
}


installPHP() {
  sudo yum install -y php56
}

installSQL() {
  sudo yum install -y mysql-server
}

startApacheServer() {
  sudo service httpd start
}

checkServerRunStatus() {
  sudo service httpd status
}

startMySQL() {
  sudo service mysqld start
}

checkMySQLStatus() {
  sudo service mysqld status
}

downloadWordPress() {
	wget http://wordpress.org/latest.tar.gz
	cd /home/ec2-user/environment/wordpress/
}

installWordPress() {
	tar -xzvf latest.tar.gz
}

setUpMySQL() {
	sudo mysql_secure_installation
}

printHowToCreateDatabase() {
 echo "Create a MySQL database for the WordPress site to use."
 echo "To do this, run the following command, replacing 'wordpress_db' with a name for the new database, for example, 'mysite'."
 echo "Be sure to save this database name in a secure location for later use."
 echo "CREATE DATABASE wordpress_db;"
}

printHowToCreateDatabaseUser() {
  sleep 1
	echo "Create a MySQL user for the WordPress site to use."
	echo "To do this, run the following command, replacing 'wordpress_user' with the users name and replacing 'my_password' with a password for the user"
	echo "GRANT ALL PRIVILEGES ON *.* TO 'wordpress_user'@'localhost' IDENTIFIED BY 'my_password';"
}

startMySQLAsRoot() {
	printHowToCreateDatabase
	printHowToCreateDatabaseUser
	sudo mysql -uroot -p
}

printRenameAndSetConfiguration() {
  echo "Step 3, Part 3 - rename and configure config file"
	echo -e "\nRename \`wp-config-sample.php\` to \`wp-config.php\`"
	echo "Configure the \`wp-config.php\` file for the WordPress website before continuing."
	echo "To do this, double-click the \`wp-config.php\` file to open it in the editor, replace the following values, and then save and close the file."
	echo -e "\tReplace \`database_name_here\` with the name of the MySQL database that you created earlier."
	echo -e "\tReplace \`username_here\` with the name of the MySQL user that you created earlier."
	echo -e "\tReplace \`password_here\` with the password for the MySQL user that you created earlier."
}

printSetWordPressWebsiteLanguage() {
  echo "Step 3, Part 6 - rename and configure config file"
  echo -e "\nSet the WordPress website's language, user name, password, and other settings."
  echo "To do this, add /wordpress/ to the end of the existing URL in the application preview."
  echo "The WordPress > Installation webpage is displayed."
  echo "Follow the on-screen instructions to finish specifying the website's settings."
}

printSetWordPressUserAndPassword(){
  echo -e "\nImportant"
  echo "In the Information needed section, for Username and Password, enter the user name (for example, wordpress_user) and password of the MySQL user that you set earlier for WordPress to use."
}

printNextStep() {
  printRenameAndSetConfiguration
  printSetWordPressWebsiteLanguage
  printSetWordPressUserAndPassword
}

execute() {
	echo "Step 1, Part 1 - updating with latest security"
	if promptUser $1; then updateSecurity; fi

	echo "Step 1, Part 2 - installing Apache HTTP Server"
	if promptUser $1; then installApacheServer; fi

	echo "Step 1, Part 3 - installing PHP"
	if promptUser $1; then installPHP; fi

	echo "Step 1, Part 4 - installing SQL"
	if promptUser $1; then installSQL; fi

	echo "Step 1, Part 5A - starting apache server"
	if promptUser $1; then startApacheServer; fi

	echo "Step 1, Part 5B - checking server run-status"
	if promptUser $1; then checkServerRunStatus; fi

	echo "Step 1, Part 6A - starting MySQL"
	if promptUser $1; then startMySQL; fi

	echo "Step 1, Part 6B - checking server"
	if promptUser $1; then checkMySQLStatus; fi

	echo "Step 1, Part 7 - downloading wordpress"
	if promptUser $1; then downloadWordPress; fi

	echo "Step 1, Part 8 - installing wordpressing"
	if promptUser $1; then installWordPress; fi

	echo "Step 2, Part 1 and 2 - beginning MySQL setup"
	if promptUser $1; then setUpMySQL; fi

	echo "Step 2, Part 3 - starting mysql as root user"
	if promptUser $1; then startMySQLAsRoot; fi

	sleep 1
	echo "Step 3, Part 1 and 2 - edit \`wp-config-sample.php\`."
	printNextStep
}


execute
