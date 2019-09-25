#!/bin/bash


echo "
__________.__                         .__         _________                __                 __
\______   \  |__   ____   ____   ____ |__|__  ___ \_   ___ \  ____   _____/  |______    _____/  |_
 |     ___/  |  \ /  _ \_/ __ \ /    \|  \  \/  / /    \  \/ /  _ \ /    \   __\__  \ _/ ___\   __\
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
read -r -p "Do you accept the term above and wish to continue the installation (y/n)"  response
if [[ $response =~ ^(yes|y| ) ]] || [[ -z $response ]]; then

#testing for connection with the internet before execution
echo "Checking PLC conections and files please wait....."
echo -e "GET http://google.com HTTP/1.0|n|n" | nc google.com 80 > /dev/null 2>&1
if [ $? -eq 0 ]; then
echo "Connection established"


#when the script find internet conection it looks for the nodejs.tar file next
cd /opt/plcnext
if [ -f nodejs.tar ]; then
echo "nodejs.tar found"


#(User chooses the type of client they want to install)
PS3='Please enter your choice: '
options=("AWS Client" "Azure Client")
select opt in "${options[@]}"
do
    case $opt in
        "AWS Client")
            echo "You chose AWS client"
            #(Here we prepare unzip the files and move to the OPT directory)
            echo "setting up files please wait......."
            rm azureClient.js
            cd /opt
            mkdir /opt/plcnext/projects/awsclient
            chmod 777 /opt/plcnext/projects/awsclient
            mv index.js /opt/plcnext/projects/awsclient
            tar -xvf nodejs.tar

            #(Here we prepare the file for the installation)
            cd /opt/nodejs/bin

            chmod -c 7 npm &> /dev/null
            chmod -c 7 node &> /dev/null
            chmod -c 7 npx &> /dev/null
            mv npm npm-org &> /dev/null

            cd /opt/nodejs/lib/node_modules/npm/bin
            chmod -c 7 npm-cli.js &> /dev/null
            chmod -c 7 npm.cmd &> /dev/null
            chmod -c 7 npx &> /dev/null
            chmod -c 7 npx.cmd &> /dev/null
            chmod -c 7 npx-cli.js &> /dev/null
            chmod -c 7 npm &> /dev/null

            cd /opt/nodejs/bin
            ln -s /opt/nodejs/lib/node_modules/npm/bin/npm-cli.js npm &> /dev/null

            cd /
            ln -s /opt/nodejs/bin/node /usr/bin/node &> /dev/null
            ln -s /opt/nodejs/bin/npm /usr/bin/npm &> /dev/null

            cd /usr/bin
            chmod -c 7 node &> /dev/null
            chmod -c 7 npm &> /dev/null
            break;;
        "Azure Client")
            echo "You chose Azure client"

              echo "setting up files please wait......."
              rm index.js
              cd /opt
              mkdir /opt/plcnext/projects/azureclient
              chmod 777 /opt/plcnext/projects/azureclient
              mv azureClient.js /opt/plcnext/projects/azureclient
              tar -xvf nodejs.tar

              #(Here we prepare the file for the installation)
              cd /opt/nodejs/bin

              chmod -c 7 npm &> /dev/null
              chmod -c 7 node &> /dev/null
              chmod -c 7 npx &> /dev/null
              mv npm npm-org &> /dev/null

              cd /opt/nodejs/lib/node_modules/npm/bin
              chmod -c 7 npm-cli.js &> /dev/null
              chmod -c 7 npm.cmd &> /dev/null
              chmod -c 7 npx &> /dev/null
              chmod -c 7 npx.cmd &> /dev/null
              chmod -c 7 npx-cli.js &> /dev/null
              chmod -c 7 npm &> /dev/null

              cd /opt/nodejs/bin
              ln -s /opt/nodejs/lib/node_modules/npm/bin/npm-cli.js npm &> /dev/null

              cd /
              ln -s /opt/nodejs/bin/node /usr/bin/node &> /dev/null
              ln -s /opt/nodejs/bin/npm /usr/bin/npm &> /dev/null

              cd /usr/bin
              chmod -c 7 node &> /dev/null
              chmod -c 7 npm &> /dev/null

              echo "Building project files please wait..."
              cd /opt/plcnext/projects/azureclient
              npm install net &> /dev/null
              npm install azure-iot-device &> /dev/null
              npm install azure-iot-device-mqtt &> /dev/null
              npm install express &> /dev/null
            fi
            break;;
        *) echo "invalid option $REPLY";;
    esac
done

#this may be removed from the script, in case client is not meant to start-up as PLC boots

echo "Downloading and installing pm2 process manager for auto boot please wait..."
cd /opt/nodejs/lib
npm install pm2 &> /dev/null
cd /
ln -s /opt/nodejs/lib/node_modules/pm2/bin/pm2 /usr/bin/pm2 &> /dev/null

#else for the file nodejs.tar checking
else
echo "File nodejs.tar not found"
fi


#else for the network checking statment
else
echo "PLC offline, please check you network settings"
fi

fi
echo "For support please subscribe at https://www.plcnext-community.net"
echo "Thank you for choosing Phoenix Contact"

echo "Script stoped"
