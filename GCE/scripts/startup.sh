#!/bin/bash
# This script is used to join a Linux machine to a Windows domain# using the realm command.
# It accepts four arguments:# - domainName: the domain name to join
# - user: the username to use when joining the domain
# - password: the password for the user
# - ouPath: the Organizational Unit (OU) path where the computer will be added
# Set the domain name and credentials

# Install utilities
sudo yum install adcli sssd authconfig oddjob oddjob-mkhomedir samba-common-tools krb5-workstation jq realmd -y
# Some brief overview on these individual packages:
#
#samba-common-tools: This denotes the shared tools for servers and clients
# oddjob: This is a D-bus service that runs the odd jobs for clients
# oddjob-mkhomedir: This is used with the odd job services to create home directories for AD accounts, if needed
# sssd: The System Security Services daemon can be used to divert client authentication as required
# adcli: These are the tools for joining and managing AD domains
# krb5-workstation: provides Kerberos klist command that are useful for verifying Kerberos-related configurations.

# Get the environment from Google instance metadata
envs="prd"
value=$(curl "metadata.google.internal/computeMetadata/v1/instance/tags?alt=text" -H "Metadata-Flavor: Google")

if [[ $value == *"dev"* ]]; then
    envs="dev"
fi

ouPath="OU=lnx,OU=gcp,OU=$envs,OU=servers,DC=dnbapp,DC=net"

# Get Service Account from CyberArk
service_object=$(curl --location --request GET 'https://pvwaus.dnb.com/AIMWebService/api/Accounts?AppID=z-dreg-gcp&Safe=app-gcp-join&Folder=Root&Object=dnbapp.net_z-dreg-gcp')

username=$(echo $service_object | jq -r '.UserName')"@DNBAPP.NET"
password=$(echo $service_object | jq -r '.Content')
domain="aeinfadspw01.dnbapp.net"

# Join the computer to the domain
sudo echo -n $password | realm join --client-software=sssd ${domain^^} --user=$username --computer-ou=$ouPath --verbose

sudo service sssd restart

sudo authconfig  --enablesssd --enablesssdauth --enablemkhomedir --update

sudo systemctl enable --now oddjobd.service
