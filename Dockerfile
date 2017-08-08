FROM centos:latest

# bitrix
ADD http://repos.1c-bitrix.ru/yum/bitrix-env.sh /tmp/
RUN chmod +x /tmp/bitrix-env.sh
RUN /tmp/bitrix-env.sh

# update + ssh
RUN yum update -y
RUN yum install -y openssh-server

#bvat bitrix(default 256M)
WORKDIR /etc/init.d
RUN sed -i 's/memory=`free.*/memory=$\{BVAT_MEM\:\=262144\}/gi' bvat

#xdebug enable
WORKDIR /etc/php.d
RUN sed -i 's/;xdebug.remote_enable=1/xdebug.remote_enable=1/gi' xdebug.ini

# default password
ENV SSH_PASS="bitrix"
RUN echo "bitrix:$SSH_PASS" | chpasswd

# zoneinfo
ENV TIMEZONE="Europe/Moscow"
RUN cp -f /usr/share/zoneinfo/$TIMEZONE /etc/localtime
RUN date

# entrypoint
WORKDIR /
ADD run.sh /
RUN chmod +x /run.sh

ENTRYPOINT exec /run.sh