FROM php:7.0-cli

MAINTAINER liyibocheng, lybcli@163.com


ENV WORKSPACE /home/swoole
RUN mkdir ${WORKSPACE}
COPY swoole-server.php ${WORKSPACE}
COPY redis.conf ${WORKSPACE}
COPY install.sh ${WORKSPACE}

RUN chmod -x ${WORKSPACE}/install.sh && sh ${WORKSPACE}/install.sh