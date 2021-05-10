#!/bin/bash

service caddy start
yes "4" | bash status.sh s

yes "4" | bash status.sh c


touch /root/.aria2/aria2.session
chmod 0777 /root/.aria2/ -R

 mkdir -p /etc/filebrowser
		cat >/etc/filebrowser/filebrowser.json <<-EOF
{
    "port": 9184,
    "baseURL": "",
    "address": "127.0.0.1",
    "log": "stdout",
    "database": "/etc/filebrowser/database.db",
    "root": "/"
}
		EOF

#rm /etc/filebrowser/database.db
filebrowser -d /etc/filebrowser/database.db config init
filebrowser -d /etc/filebrowser/database.db config set --locale zh-cn

filebrowser -d /etc/filebrowser/database.db users add root $Aria2_secret --perm.admin
nohup  filebrowser -c /etc/filebrowser/filebrowser.json  &


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