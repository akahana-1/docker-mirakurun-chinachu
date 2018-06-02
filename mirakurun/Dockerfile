FROM node:8.11.2-alpine
LABEL maintainer "akahana-1 <aakahana@gmail.com>"

# ENV DOCKER="YES"

RUN set -x \
	&& apk upgrade --update \
	&& apk add \
		bash \
		coreutils \
		libusb \
		pcsc-lite \
		pcsc-lite-libs \
		curl \
		ca-certificates \
		util-linux \
	&& apk add --virtual .build-deps \
		git \
		make \
		gcc \
		g++ \
		gzip \
		unzip \
		autoconf \
		automake \
		libc-dev \
		musl-dev \
		eudev-dev \
		libevent-dev \
		pcsc-lite-dev \
		linux-headers \
		libusb-dev \
	&& npm install pm2 -g \
	\
	&& npm install arib-b25-stream-test -g --unsafe \
	&& npm install mirakurun@latest -g --unsafe --production \
	# ccid for ACR39U Card Reader
	&& cd /tmp \
	&& curl -L -o acsccid-1.1.5.tar.bz2 http://downloads.sourceforge.net/acsccid/acsccid-1.1.5.tar.bz2 \
	&& tar xjf acsccid-*.tar.bz2 \
	&& cd acsccid-* \
	&& ./configure \
	&& make \
	&& make install \
	# Cleaning
	&& apk del --purge .build-deps \
	&& npm cache verify \
	&& rm -rf /tmp/* \
	&& rm -rf /var/cache/apk/* \

	# forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /usr/local/var/log/mirakurun.stdout-0.log \
	&& ln -sf /dev/stderr /usr/local/var/log/mirakurun.stderr-0.log

COPY services.sh /usr/local/bin

WORKDIR /usr/lib/node_modules/mirakurun
CMD ["/usr/local/bin/services.sh"]
EXPOSE 40772
