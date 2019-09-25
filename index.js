const aws = require('aws-iot-device-sdk');
const net = require('net');
const express = require('express');
const app = express();
const http = require('http').Server(app);

let plcData = {};
var key ={};

//Key Server connection
var keyServer = net.createServer();

keyServer.on('connection', function(socket) {

    console.log('PLC key server Connected');

    socket.on('data', function(data) {
        key = JSON.parse(data);
        //console.log(key.keyPath);
        //console.log(key.certPath);
        //console.log(key.caPath);
        //console.log(key.clientId);
        //console.log(key.host);
        socket.write('Key activated');
    });

    socket.on('close', function() {
        console.log('Key Connection Closed');

var awsClient = new aws.device({
    keyPath: key.keyPath,
    certPath: key.certPath,
    caPath: key.caPath,
    clientId: key.clientId,
    host: key.host,
    baseReconnectTimeMs: 5000,
    maximumReconnectTimeMs: 300000
});

var plcServer = net.createServer();

plcServer.on('connection', function(socket) {

    console.log('PLC Connected');

    socket.on('data', function(data) {
        var dataString = data.toString();
        plcData = JSON.parse(dataString);
        console.log(plcData);

        for (dat in plcData) {
            awsClient.publish('data', JSON.stringify({[dat]: plcData[dat]}));
        };
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
    console.log('Server is listening');
} else {
    console.log('Server is not listening');
};

awsClient.on('connect', function(success) {
    if (success) {
      console.log('Client Connected to AWS');
    } else {
      console.log('Client Failed to Connect to AWS');
    };
});

//On sent packet then log packet
awsClient.on('packetsend', function(msg) {
    console.log('sent', JSON.stringify(msg));
});
//On received packet then log packet
awsClient.on('packetreceive', function(msg) {
    console.log('received', JSON.stringify(msg));
});
//On any error during connection then notify and change status
awsClient.on('error', function(err) {
    console.log('error', err);
});
//On client close connection then notify and change status
awsClient.on('close', function() {
    console.log('AWS Disconnected');
});
//On client trying to reconnection then notify and change status
awsClient.on('reconnect', function() {
    console.log('Reconnecting to AWS...');
});

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
