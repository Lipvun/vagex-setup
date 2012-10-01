#!/bin/sh

rm -rf ~/.vnc/*.log /tmp/plugtmp* > /dev/null 2>&1
/etc/init.d/vncserverd restart > /dev/null 2>&1
