#!/bin/sh
bash dnsmasq.sh
git add -A
git commit -m "Update *.conf"
git push origin master
