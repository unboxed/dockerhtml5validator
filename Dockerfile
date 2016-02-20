FROM ubuntu:14.04.4
MAINTAINER Peter Mescalchin "peter@magnetikonline.com"

# To apply security upgrades, set this to the current date. It will invalidate
# the cache, forcing the apt-get and apt-get -y upgrade to apply
RUN echo 2016-02-20-13:36 GMT

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install \
	apache2 build-essential \
	libapache2-mod-perl2 libhtml-tidy-perl libosp-dev libxml-libxml-perl libxml2-dev \
	openjdk-6-jre opensp supervisor unzip zlib1g-dev

RUN apt-get clean

RUN mkdir /root/build
ADD ./resource/apache.server.conf /etc/apache2/conf-available/server.conf
ADD ./resource/supervisord.conf /etc/supervisor/conf.d/
ADD http://validator.w3.org/validator.tar.gz /root/build/
ADD http://validator.w3.org/sgml-lib.tar.gz /root/build/
ADD https://github.com/validator/validator.github.io/releases/download/20140901/vnu-20140901.jar.zip /root/build/

ADD ./resource/configure.sh /root/build/
WORKDIR /root/build
RUN chmod a+x configure.sh
RUN ./configure.sh

EXPOSE 80

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
