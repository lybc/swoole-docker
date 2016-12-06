FROM php:7.0-cli

MAINTAINER liyibocheng, lybcli@163.com
# WORKSPACE=/home/swoole \
ENV EXT_DIR=/usr/local/lib/php/extensions/no-debug-non-zts-20151012 \
REDIS_VERSION=3.2.5 \
BUILDS='wget zip bzip2 libssl-dev'
RUN mkdir -p /home/swoole/redis

WORKDIR /home/swoole
COPY swoole-server.php .
COPY redis.conf .

RUN apt-get update \
	&& apt-get install -y $BUILDS \
	# Download
	&& wget -O redis.tar.gz http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz \
	&& wget -O php7.zip https://github.com/phpredis/phpredis/archive/php7.zip \
	&& tar -xzf redis.tar.gz -C /home/swoole/redis --strip-components=1 \
    && make -C /home/swoole/redis \
    && make -C /home/swoole/redis install
    && mkdir data

VOLUME /home/swoole/data
EXPOSE 6379
CMD redis-server redis.conf

# install swoole
RUN pecl install swoole \
	&& touch /usr/local/etc/php/conf.d/extensions.ini \
	&& echo "extension=${EXT_DIR}/swoole.so" >> /usr/local/etc/php/conf.d/extensions.ini

# install redis-php-lib
RUN unzip php7.zip \
	&& cd phpredis-php7 \
	&& phpize && ./configure \
	&& make && make install \
	&& echo "extension=${EXT_DIR}/redis.so" >> /usr/local/etc/php/conf.d/extensions.ini

WORKDIR /home/swoole
RUN rm -rf /var/lib/apt/lists/* \
    && rm redis.tar.gz \
    && rm php7.zip \
    && rm -r redis \
    && rm -r phpredis-php7 \
    && apt-get purge -y --auto-remove $BUILDS \
    && apt-get clean

