FROM alpine:latest
LABEL mainteiner "akahana_1 <aakahana@gmail.com>"

COPY extension /tmp/shared/

RUN set -x \
		&& apk upgrade --update \
		&& apk add bash \
			'nodejs>=6.5.0' \
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
			autoconf \
			automake \
			libc-dev \
			musl-dev \
			eudev-dev \
			libevent-dev \
			pcsc-lite-dev \
			libusb-dev \
			linux-headers \
		&& npm install pm2 -g \
		&& npm install mirakurun -g --unsafe --production \
		&& npm install arib-b25-stream-test -g --unsafe \
		# softcas
		&& cd /tmp \
		&& unzip shared/softcas.zip \
		&& cd softcas/ \
		&& curl -s https://gist.githubusercontent.com/tyage/3d201580549bc84e24cd/raw/Makefile -o Makefile \
		&& curl -s https://gist.github.com/tyage/3d201580549bc84e24cd/raw/winscard.cpp -o winscard.cpp \
		&& make \
		&& cp libpcsclite.so.1.0.0 /usr/lib/pkgconfig \
		# libarib25
		&& cd /tmp \
		&& unzip shared/libarib25.zip \
		&& cd libarib25-master/src \
		&& sed -i '/ldconfig/d' Makefile \
		&& cd ../ \
		&& make \
		&& make install \
		# recfsusb2i
		&& cd /tmp \
		&& unzip shared/recfsusb2i-20160220.zip \
		&& cd recfsusb2i-20160220/src \
		&& sed -i '6a #include <fcntl.h>\n#include <linux/limits.h>' usbdevfile.c \
		&& make B25=1 \
		&& cp recfsusb2i /usr/local/bin \
		# cleaning
		&& cd / \
		&& npm cache clean \
		&& apk del --purge .build-deps \
		&& rm -rf /tmp/* \\
		&& rm -rf /var/cache/apk/*

COPY services.sh /usr/local/bin

WORKDIR /usr/lib/node_modules/mirakurun
CMD ["/usr/local/bin/services.sh"]

EXPOSE 40772

