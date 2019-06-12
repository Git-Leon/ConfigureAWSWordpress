promptUser() {
	while true; do
	    read -p "Do you wish to execute this command?" yn
	    case $yn in
	        [Yy]* ) return 0; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}
