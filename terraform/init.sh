#!/bin/bash

echo "starting app"
export DB_HOST=mongodb://11.3.2.55/posts
cd /home/ubuntu/app
npm install
pm2 start app.js