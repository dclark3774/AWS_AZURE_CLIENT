const Client = require('azure-iot-device').Client;
const ConnectionString = require('azure-iot-device').ConnectionString;
const Message = require('azure-iot-device').Message;
const Protocol = require('azure-iot-device-mqtt').Mqtt;
const express = require('express');
const app = express();
const http = require('http').Server(app);
const net =  require('net');


var sendingMessage = true;
var messageId = 0;
var client, config;
var configInterval = 1000;
var obj = {};
var key = '';


//Key Server connection
var keyServer = net.createServer();

keyServer.on('connection', function(socket) {

    console.log('PLC key server Connected');

    socket.on('data', function(data) {
        key = data.toString();
        //console.log(key);
        socket.write('Key activated');
    });

    socket.on('close', function() {
        console.log('Key Connection Closed');
        //Server connection
        var plcServer = net.createServer();

        plcServer.on('connection', function(socket) {

            console.log('PLC Connected');

            socket.on('data', function(data) {
                var dataString = data.toString();
                obj = JSON.parse(dataString);
                socket.write('Echo');
            });

            socket.on('close', function() {
                console.log('Connection Closed');
            });

            socket.on('error', function(err) {
                console.log(err);
            });
        });

        plcServer.listen(3999);

        if (plcServer.listening) {
            console.log('Data Server is listening');
        } else {
            console.log('Data Server is not listening');
        };


        //Send data
        function sendMessage() {
          if (!sendingMessage) {
            console.log('Azure client stopped.');
            setTimeout(sendMessage, configInterval);
          } else if (sendingMessage) {
            messageId++;

            //Build payload
            var content = JSON.stringify({
              messageId: messageId,
              deviceId: 'PLCnext-2019_3',
              payload: obj
             });

            //Build MQTT packet with payload
            var message = new Message(content);
            console.log('Sending message: ' + content);

            //Send packet
            client.sendEvent(message, err => {
              if (err) {
                console.error('Failed to send message to Azure IoT Hub');
              } else {
                console.log('Message sent to Azure IoT Hub: ' + message);
              }

              setTimeout(sendMessage, configInterval);
            });
          }
        }

        //Remote commands from Azure broker
        function onStart(request, response) {
          console.log('Try to invoke method start(' + request.payload || '' + ')');
          sendingMessage = true;

          response.send(
            200,
            'Azure client messaging status: ' + sendingMessage,
            function(err) {
              if (err) {
                console.error(
                  '[IoT hub Client] Failed sending a method response:\n' + err.message
                );
              }
            }
          );
        }

        function onStop(request, response) {
          console.log('Try to invoke method stop(' + request.payload || '' + ')');
          sendingMessage = false;

          response.send(
            200,
            'Azure client messaging status: ' + sendingMessage,
            function(err) {
              if (err) {
                console.error(
                  '[IoT hub Client] Failed sending a method response:\n' + err.message
                );
              }
            }
          );
        }

        function onDO(request, response) {
          console.log('Try to invoke method DO(' + request.payload || '' + ')');
          do_1 = request.payload.payload.input1;
          sqlTrans = 'UPDATE io SET do_1=' + do_1 + ' WHERE id=1';

          db.query(sqlTrans, function(err, result) {
            if (err) {
              throw err;
            } else {
              console.log(sqlTrans);
            }
          });

          response.send(200, 'do_1 status: ' + do_1, function(err) {
            if (err) {
              console.error(
                '[IoT hub Client] Failed sending a method response:\n' + err.message
              );
            }
          });

          return do_1;
        }

        //Receive data from Azure
        function receiveMessageCallback(msg) {
          var message = msg.getData().toString('utf-8');
          client.complete(msg, () => {
            console.log('Receive message: ' + message);
          });
        }

        //Sec stuffs (not implemented yet)
        function initClient(connectionStringParam, credentialPath) {
          var connectionString = ConnectionString.parse(connectionStringParam);
          var deviceId = connectionString.DeviceId;

          // fromConnectionString must specify a transport constructor, coming from any transport package.
          client = Client.fromConnectionString(connectionStringParam, Protocol);

          // Configure the client to use X509 authentication if required by the connection string.
          if (connectionString.x509) {
            // Read X.509 certificate and private key.
            // These files should be in the current folder and use the following naming convention:
            // [device name]-cert.pem and [device name]-key.pem, example: myraspberrypi-cert.pem
            var connectionOptions = {
              cert: fs
                .readFileSync(path.join(credentialPath, deviceId + '-cert.pem'))
                .toString(),
              key: fs
                .readFileSync(path.join(credentialPath, deviceId + '-key.pem'))
                .toString()
            };

            client.setOptions(connectionOptions);

            console.log('[Device] Using X.509 client certificate authentication');
          }
          return client;
        }

        //Client
        (function(connectionString) {
          200;
          connectionString = key;
          client = initClient(connectionString, config);

          client.open(err => {
            if (err) {
              console.error('[IoT hub Client] Connect error: ' + err.message);
              return;
            }

            //Cloud-2-Device and device method callbacks
            client.onDeviceMethod('start', onStart);
            client.onDeviceMethod('stop', onStop);
            client.onDeviceMethod('DO', onDO);
            client.on('message', receiveMessageCallback);
            setInterval(() => {
              client.getTwin((err, twin) => {
                if (err) {
                  console.error('get twin message error');
                  return;
                }
                configInterval = twin.properties.desired.interval || configInterval;
              });
            }, configInterval);
            sendMessage();
          });
        })(process.argv[2]);

    });

    socket.on('error', function(err) {
        console.log(err);
    });
});

keyServer.listen(4000);

if (keyServer.listening) {
    console.log('Key Server is listening');
} else {
    console.log('Key Server is not listening');
};
