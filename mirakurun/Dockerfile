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
	# recdvb
	&& git clone https://github.com/dogeel/recdvb /tmp/recdvb \
	&& cd /tmp/recdvb \
	&& chmod +x autogen.sh \
	&& ./autogen.sh \
	&& ./configure --enable-b25 \
	&& sed -i '/#include <sys\/msg.h>/d' recpt1core.h \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' recpt1.c \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' recpt1ctl.c \
	&& sed -i -E 's!(#include <sys/msg.h>)!#undef _GNU_SOURCE\n#undef _BSD_SOURCE\n\1!' checksignal.c \
	&& sed -i -E 's!(#include <ctype.h>)!\1\n#include <event.h>!' tssplitter_lite.c \
	&& sed -i "$(grep -n '#include' tssplitter_lite.h | tail -n 1 | cut -d ':' -f1)a #include <sys/types.h>" tssplitter_lite.h \
	&& make \
	&& make install \
	# ccid for ACR39U Card Reader
	&& cd /tmp \
	# && curl -o ccid.zip https://www.acs.com.hk/download-driver-unified/6258/ACS-Unified-Driver-Lnx-Mac-114-P.zip \
	# && unzip -o ccid.zip \
	&& curl -L -o acsccid-1.1.5.tar.bz2 http://downloads.sourceforge.net/acsccid/acsccid-1.1.5.tar.bz2 \
	&& tar xjf acsccid-*.tar.bz2 \
	&& cd acsccid-* \
	&& ./configure \
	&& make \
	&& make install \
	# Cleaning
	&& apk del --purge .build-deps \
	&& npm cache clean \
	&& rm -rf /tmp/* \
	&& rm -rf /var/cache/apk/*

	# forward request and error logs to docker log collector
	#&& ln -sf /dev/stdout /usr/local/var/log/mirakurun.stdout-0.log \
	#&& ln -sf /dev/stderr /usr/local/var/log/mirakurun.stderr-0.log

COPY services.sh /usr/local/bin

WORKDIR /usr/lib/node_modules/mirakurun
CMD ["/usr/local/bin/services.sh"]
EXPOSE 40772
