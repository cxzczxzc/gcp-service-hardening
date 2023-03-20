#!/bin/bash
curl -s "http://metadata.google.internal/computeMetadata/v1/instance/tags?alt=text" -H "Metadata-Flavor: Google" 2 > /tmp/tags.txt
for i in $(cat /tmp/tags.txt) ; do
 if [[ "$i" == nonprod* ]]; then
   str=$i
# Domain join for nonprod vms
   envs="dev"
   sudo yum install adcli sssd authconfig oddjob oddjob-mkhomedir samba-common-tools krb5-workstation jq realmd -y
   ouPath="OU=lnx,OU=gcp,OU=$envs,OU=servers,DC=dnbapp,DC=net"
   service_object=$(curl --location --request GET 'https://pvwaus.dnb.com/AIMWebService/api/Accounts?AppID=z-dreg-gcp&Safe=app-gcp-join&Folder=Root&Object=dnbapp.net_z-dreg-gcp')
   username=$(echo $service_object | jq -r '.UserName')"@DNBAPP.NET"
   password=$(echo $service_object | jq -r '.Content')
   domain="aeinfadspw01.dnbapp.net"
   sudo echo -n $password | realm join --client-software=sssd ${domain^^} --user=$username --computer-ou=$ouPath --verbose
   sudo authconfig  --enablesssd --enablesssdauth --enablemkhomedir --update
   sudo systemctl enable --now oddjobd.service
# Adding AD groups sudoers.d directory
       echo "%devx-$i-devops ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/devx-"$i"-devops
       echo "%devx-$i-dev ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/devx-"$i"-dev
       echo "%devx-$i-sre ALL= /usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-sre
       echo "%devx-$i-qa ALL= /usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-qa
       echo "%devx-$i-system ALL= /usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-system
       echo "%devx-$i-dba ALL=(oracle,mysql,postgres,mongo) ALL" > /etc/sudoers.d/devx-"$i"-dba
       echo "%devx-$i-ds ALL= /usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-ds
       echo "%devx-$i-relmgmt ALL= /usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-relmgmt
       echo "%devx-$i-global-soc ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devx-"$i"-global-soc
       echo "%devx-$i-global-linux-admin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/devx-"$i"-global-linux-admin
       echo "%devx-$i-global-dba ALL=(oracle,mysql,postgres,mongo) ALL" > /etc/sudoers.d/devx-"$i"-global-dba
# Adding AD groups to sssd.conf file
       if ! grep -q "ad_access_filter" /etc/sssd/sssd.conf ; then
         sudo echo "ad_access_filter = dnbapp.net:(|(memberOf=cn=devx-replace-devops,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-sre,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-dev,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-qa,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-db-admin,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-system,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-ds,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-global-soc,ou=groups,dc=dnbapp,dc=net)\n (memberOf=cn=devx-replace-global-linux-admin,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-global-db-admin,ou=groups,dc=dnbapp,dc=net) )" >> /etc/sssd/sssd.conf
         sudo sed -i "s/devx-replace-/devx-$i-/g" /etc/sssd/sssd.conf
       fi
   sudo service sssd restart
 elif [[ "$i" == prod* ]]; then
# Domain join for prod vms
   envs="prd"
   sudo yum install adcli sssd authconfig oddjob oddjob-mkhomedir samba-common-tools krb5-workstation jq realmd -y
   ouPath="OU=lnx,OU=gcp,OU=$envs,OU=servers,DC=dnbapp,DC=net"
   service_object=$(curl --location --request GET 'https://pvwaus.dnb.com/AIMWebService/api/Accounts?AppID=z-dreg-gcp&Safe=app-gcp-join&Folder=Root&Object=dnbapp.net_z-dreg-gcp')
   username=$(echo $service_object | jq -r '.UserName')"@DNBAPP.NET"
   password=$(echo $service_object | jq -r '.Content')
   domain="aeinfadspw01.dnbapp.net"
   sudo echo -n $password | realm join --client-software=sssd ${domain^^} --user=$username --computer-ou=$ouPath --verbose
   sudo authconfig  --enablesssd --enablesssdauth --enablemkhomedir --update
   sudo systemctl enable --now oddjobd.service
# Adding AD groups sudoers.d directory
       echo "%devx-$i-devops ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-devops
       echo "%devx-$i-system ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-sre
       echo "%devx-$i-system ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-system
       echo "%devx-$i-dba ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-dba
       echo "%devx-$i-global-soc ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-global-soc
       echo "%devx-$i-global-linux-admin ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-global-linux-admin
       echo "%devx-$i-global-dba ALL=/usr/bin/cat, /var/log/*" > /etc/sudoers.d/devx-"$i"-global-dba
# Adding AD groups to sssd.conf file
        if ! grep -q "ad_access_filter" /etc/sssd/sssd.conf ; then
          sudo echo "ad_access_filter = dnbapp.net:(|(memberOf=cn=devx-replace-devops,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-sre,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-dev,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-qa,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-db-admin,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-system,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-ds,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-global-soc,ou=groups,dc=dnbapp,dc=net)\n (memberOf=cn=devx-replace-global-linux-admin,ou=groups,dc=dnbapp,dc=net) \n (memberOf=cn=devx-replace-global-db-admin,ou=groups,dc=dnbapp,dc=net) )" >> /etc/sssd/sssd.conf
          sudo sed -i "s/devx-replace-/devx-$i-/g" /etc/sssd/sssd.conf
        fi
   sudo service sssd restart
 fi
done;
