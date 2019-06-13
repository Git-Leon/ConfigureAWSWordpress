#!/bin/bash

promptUser() {
	while true; do
	    read -p "Do you wish to continue?" yn
	    case $yn in
	        [Yy]* ) return 0; break;;
	        [Nn]* ) exit;;
	        * ) echo "Please answer yes or no.";;
	    esac
	done
}

kill8080() {
	fuser -k 8080/tcp
}

export -f promptUser
export -f kill8080
