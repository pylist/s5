#!/bin/bash

yum install -y make gcc
mkdir /tmp/3proxy
cd /tmp/3proxy
wget --no-check-certificate https://github.com/z3APA3A/3proxy/archive/0.8.13.tar.gz
tar -xvzf 0.8.13.tar.gz
cd 3proxy-0.8.13
make -f Makefile.Linux
cd src/
mv 3proxy /usr/bin
chmod +x /usr/bin/3proxy
cd $HOME
wget --no-check-certificate https://raw.githubusercontent.com/fakegit/bash/master/misc/3proxy.cfg
rm -rf /tmp/3proxy
mkdir /var/log/3proxy

cat > $HOME/3proxy_restart.sh << 'EOF'
#!/bin/sh
ps -ef | grep 3proxy | grep -v grep | grep -v $$ | cut -c 9-15 | xargs -r kill -s 9 > /dev/null 2>&1
# ps -ef | grep 3proxy | grep -v grep | grep -v $$ | awk '{print $2}' | xargs -r kill -9 > /dev/null 2>&1
/usr/bin/3proxy $HOME/3proxy.cfg > /dev/null 2>&1 &
EOF
chmod +x $HOME/3proxy_restart.sh

cat > $HOME/3proxy_check.sh << 'EOF'
ps -ef|grep 3proxy|grep -v grep|grep -v $$
if [ $? -ne 0 ]
then
/usr/bin/3proxy $HOME/3proxy.cfg > /dev/null 2>&1 &
fi
EOF
chmod +x $HOME/3proxy_check.sh
echo '*/5 * * * * $HOME/3proxy_check.sh' >> /etc/crontab
service crond restart


