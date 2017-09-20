#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y


sudo apt-get install nginx -y
sudo rm /etc/nginx/sites-available/default 
sudo cp /home/ubuntu/app/environment/nginx.default /etc/nginx/sites-available/default
sudo service nginx restart

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install pm2 -g




