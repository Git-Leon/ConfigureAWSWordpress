#!/bin/bash
source ~/environment/aws-wordpress-installation/import_utils.sh
#source ~/environment/import_utils.sh


enableIncomingTraffic() {
  MY_INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id) # Get the ID of the instance for the environment, and store it temporarily.
  MY_SECURITY_GROUP_ID=$(aws ec2 describe-instances --instance-id $MY_INSTANCE_ID --query 'Reservations[].Instances[0].SecurityGroups[0].GroupId' --output text) # Get the ID of the security group associated with the instance, and store it temporarily.
  aws ec2 authorize-security-group-ingress --group-id $MY_SECURITY_GROUP_ID --protocol tcp --cidr 0.0.0.0/0 --port 8080 # Add an inbound rule to the security group to allow all incoming IPv4-based traffic over port 8080.
  aws ec2 authorize-security-group-ingress --group-id $MY_SECURITY_GROUP_ID --ip-permissions IpProtocol=tcp,Ipv6Ranges='[{CidrIpv6=::/0}]',FromPort=8080,ToPort=8080 # Add an inbound rule to the securty group to allow all incoming IPv6-based traffic over port 8080.
  MY_SUBNET_ID=$(aws ec2 describe-instances --instance-id $MY_INSTANCE_ID --query 'Reservations[].Instances[0].SubnetId' --output text) # Get the ID of the subnet associated with the instance, and store it temporarily.
  MY_NETWORK_ACL_ID=$(aws ec2 describe-network-acls --filters Name=association.subnet-id,Values=$MY_SUBNET_ID --query 'NetworkAcls[].Associations[0].NetworkAclId' --output text) # Get the ID of the network ACL associated with the subnet, and store it temporarily.
  aws ec2 create-network-acl-entry --network-acl-id $MY_NETWORK_ACL_ID --ingress --protocol tcp --rule-action allow --rule-number 10000 --cidr-block 0.0.0.0/0 --port-range From=8080,To=8080 # Add an inbound rule to the network ACL to allow all IPv4-based traffic over port 8080. Advanced users: change this suggested rule number as desired.
  aws ec2 create-network-acl-entry --network-acl-id $MY_NETWORK_ACL_ID --ingress --protocol tcp --rule-action allow --rule-number 10100 --ipv6-cidr-block ::/0 --port-range From=8080,To=8080 # Add an inbound rule to the network ACL to allow all IPv6-based traffic over port 8080. Advanced users: change this suggested rule number as desired.
}

getIndexPageURI() {
  MY_PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4) && echo http://$MY_PUBLIC_IP:8080/index.php # Get the URL to the index.php file within the web server root.
}


execute() {
  echo -e "\nPart 4, Step 14 - enabling incoming traffic"
  if promptUser $1; then enableIncomingTraffic; fi

  echo -e "\nPart 4, Step 15 - getting uri of wordpress \`index.html\`"
  if promptUser $1; then getIndexPageURI; fi
  
  echo "Configuration complete"
}


execute
