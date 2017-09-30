#!/bin/bash
if [ ! -s /usr/local/etc/mirakurun/channels.yml ]; then
	cat /usr/local/share/mirakurun/channels.yml > /usr/local/etc/mirakurun/channels.yml
fi
if [ ! -s /usr/local/etc/mirakurun/tuners.yml ]; then
	cat /usr/local/share/mirakurun/tuners.yml > /usr/local/etc/mirakurun/tuners.yml
fi
if [ ! -s /usr/local/etc/mirakurun/server.yml ]; then
	cat /usr/local/share/mirakurun/server.yml > /usr/local/etc/mirakurun/server.yml
fi

rm -f /run/pcscd/pcscd.comm

pcscd -f --error 2>&1 > pcscd-error.log &
# /usr/bin/mirakurun start
# /usr/bin/mirakurun log server
npm start 2>&1 mirakurun-error.log
