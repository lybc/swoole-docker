FROM php:7.0-cli

MAINTAINER liyibocheng, lybcli@163.com

ENV WORKSPACE /home/swoole
ENV EXT_DIR /usr/local/lib/php/extensions/no-debug-non-zts-20151012
COPY swoole-server.php ${WORKSPACE}
COPY redis.conf ${WORKSPACE}

RUN mkdir -p ${WORKSPACE} && cd ${WORKSPACE}
RUN apt-get update && apt-get install -y wget zip bzip2 libssl-dev


# install swoole
RUN pecl install swoole \
	&& touch /usr/local/etc/php/conf.d/extensions.ini \
	&& echo "extension=${EXT_DIR}/swoole.so" > /usr/local/etc/php/conf.d/extensions.ini

# install&run redis
RUN wget http://download.redis.io/releases/redis-3.2.5.tar.gz \
	&& tar -zxf redis-3.2.5.tar.gz \
	&& cd redis-3.2.5 \
	&& make \
	&& src/redis-server ${WORKSPACE}/redis.conf
	&& cd ${WORKSPACE}

# install redis-php-lib
RUN wget https://github.com/phpredis/phpredis/archive/php7.zip \
	&& unzip php7.zip \
	&& cd phpredis-php7 \
	&& phpize && ./configure \
	&& make && make install
	&& echo "extension=${EXT_DIR}/redis.so" > /usr/local/etc/php/conf.d/extensions.ini

RUN php -m


# install git
#RUN curl -O https://www.kernel.org/pub/software/scm/git/git-2.11.0.tar.gz \
#	&& tar -zxf git-2.11.0.tar.gz \
#	&& cd git-2.11.0 \
#	&& make prefix=/usr/local all \
#	&& make prefix=/usr/local install
