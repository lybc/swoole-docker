#!/bin/sh
apt-get update && apt-get install -y wget zip bzip2 libssl-dev

# install swoole
pecl install swoole
touch /usr/local/etc/php/conf.d/extensions.ini
echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/swoole.so" > /usr/local/etc/php/conf.d/extensions.ini


wget http://download.redis.io/releases/redis-3.2.5.tar.gz
tar -zxf redis-3.2.5.tar.gz
cd redis-3.2.5
make
src/redis-server /home/swoole/redis.conf
cd /home/swoole


wget https://github.com/phpredis/phpredis/archive/php7.zip
unzip php7.zip
cd phpredis-php7
phpize
./configure
make && make install
echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/redis.so" > /usr/local/etc/php/conf.d/extensions.ini