#!/bin/bash


echo "
__________.__                         .__         _________                __                 __
\______   \  |__   ____   ____   ____ |__|__  ___ \_   ___ \  ____   _____/  |______    _____/  |_
 |     ___/  |  \ /  _ \_/ __ \ /    \|  \  \/  / /    \  \/ /  _ \ /    \   __\__  \ _/ ___\   __|
 |    |   |   Y  (  <_> )  ___/|   |  \  |>    <  \     \___(  <_> )   |  \  |  / __ \\  \___|  |
 |____|   |___|  /\____/ \___  >___|  /__/__/\_ \  \______  /\____/|___|  /__| (____  /\___  >__|
               \/            \/     \/         \/         \/            \/          \/     \/

                                                                                              USA "

echo "AWS/Azure Client Build - REVISION 01 - by Yuri Chamarelli, Grant Vandebrake, Jake Kustan, and Dan Clark

node.js armv7l version 10.16.3 LTS with PM2 and AWS IoT Device SDK and Azure IOT Device
"
echo "Disclamer - Warning: All examples listed are meant to showcase potential use cases.
Always adhere to best practices and mandatory safety regulations. The end-user is soly
responsible for a safe application/implementation of the examples listed - AWS/Azure Client Build."

sleep 5s


#(Execute this logic before start script execution)
read -r -p "Do you accept the term above and wish to continue the installation (y/n)" response
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then

#testing for connection with the internet before execution
echo "Checking PLC internet conection please wait....."
echo -e "GET http://google.com HTTP/1.0|n|n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
echo "Connection established"

#(User chooses the type of client they want to install)
PS3='Please enter your choice: '
options=("AWS Client" "Azure Client")
select opt in "${options[@]}"
do
    case $opt in
        "AWS Client")
         echo "You chose AWS client"
         cd /
         wget -O - http://ipkg.nslu2-linux.org/optware-ng/bootstrap/buildroot-armeabihf-bootstrap.sh | sh
         cd /opt
         export PATH=$PATH:/opt/bin:/opt/sbin
         ipkg install gcc
         ipkg install python27
         ipkg install make
         ipkg install node
         cd /plcnext
         wget -O - https://github.com/dclark3774/AWS_AZURE_CLIENT.git
         mkdir /projects/awsclient
         rm azureClient.js
         mv index.js projects/awsclient
         cd /projects/awscleint
         npm install aws-iot-device-sdk
         npm install express
         npm install net

         echo "downloading and installing npm pm2 auto boot please wait......."
         cd /opt
         npm install pm2
         pm2 start node /opt/plcnext/projects/awsclient/index.js
         pm2 save
         pm2 startup
         echo "npm pm2 auto boot installed"

         break;;

        "Azure Client")
        echo "You chose Azure client"
        cd /
        wget -O - http://ipkg.nslu2-linux.org/optware-ng/bootstrap/buildroot-armeabihf-bootstrap.sh | sh
        cd /opt
        export PATH=$PATH:/opt/bin:/opt/sbin
        ipkg install gcc
        ipkg install python27
        ipkg install make
        ipkg install node
        cd /plcnext
        wget -O - https://github.com/dclark3774/AWS_AZURE_CLIENT.git
        mkdir /projects/azureclient
        rm index.js
        mv azureClient.js projects/azureclient
        cd /projects/azurecleint
        npm install azure-iot-device
        npm install azure-iot-device-mqtt
        npm install express
        npm install net

        echo "downloading and installing npm pm2 auto boot please wait......."
        cd /opt
        npm install pm2
        pm2 start node /opt/plcnext/projects/azuresclient/azureClient.js
        pm2 save
        pm2 startup
        echo "npm pm2 auto boot installed"

        break;;
        *) echo "invalid option $REPLY";;
    esac
done

#clean files from PLCnext directory
cd /opt/plcnext
rm -r nodejs.tar nodescript.sh &dev/null

echo "Your IOT client is ready"

echo "Yor IOT Client will be using Port 3999 and 4000."

echo "for support please subriscribe at https://www.plcnext-community.net"
echo "thank you for choosing Phoenix Contact"
echo "your AWS/Azure Client installation is complete"

#else for the network checking statment
else
echo "PLC offline, please check you network settings"
fi

fi

echo "Script stoped"
