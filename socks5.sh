#!/bin/bash

wget -O brook https://github.com/txthinking/brook/releases/download/v20210701/brook_linux_amd64
chmod +x brook
echo "[Unit]
Description=Brook Service
After=network.service

[Service]
#Type=forking
WorkingDirectory=/root
ExecStart=/usr/bin/nohup /root/brook socks5 --socks5 0.0.0.0:$1 --username $2 --password $3 >/dev/null 2>&1 &
#SuccessExitStatus=143
ExecStop=/usr/bin/kill -9 \$MAINPID
Environment=HOME=/home/hxcl PWD=/home/hxcl/app
StandardOutput=null

[Install]
WantedBy=multi-user.target" > /usr/lib/systemd/system/brook.service
systemctl start brook.service
systemctl enable brook.service