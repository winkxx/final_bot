#!/bin/bash

service caddy start
yes "4" | bash status.sh s

yes "4" | bash status.sh c


touch /root/.aria2/aria2.session
chmod 0777 /root/.aria2/ -R

wget https://github.com/FolderMagic/FolderMagic/raw/master/FolderMagic
chmod +x FolderMagic
nohup ./FolderMagic -aria "http://127.0.0.1:6800/jsonrpc" -auth root:$Aria2_secret -bind :9184 -root /  >> /dev/null 2>&1 & 

mkdir /.config/
mkdir /.config/rclone
touch /.config/rclone/rclone.conf
echo "$Rclone" >>/.config/rclone/rclone.conf
wget git.io/tracker.sh
chmod 0777 /tracker.sh
/bin/bash tracker.sh "/root/.aria2/aria2.conf"



git clone "https://${git_admin}:${git_pass}@github.com/666wcy/new_bot"  >> /dev/null 2>&1
mkdir /bot/
mv /new_bot/bot/* /bot/
cp /new_bot/nginx.conf /etc/nginx/
chmod 0777 /bot/ -R
rm -rf /new_bot
python3 /bot/nginx.py
nginx -c /etc/nginx/nginx.conf
nginx -s reload

nohup aria2c --conf-path=/root/.aria2/aria2.conf --rpc-listen-port=8080 --rpc-secret=$Aria2_secret &
#nohup python3 /bot/web.py &

python3 /bot/main.py