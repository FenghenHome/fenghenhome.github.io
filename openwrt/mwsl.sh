#!/bin/bash
# This is to fetch the list of malware websites collected by www.mwsl.org.cn/. Probably update once a week.
# By YCN on the first day of CNY, Feb 08 2016.


NULLIP="127.0.0.1"
TMP1="temp1"
TMP2="get-hostlist"
CONFIGFILE="mal-hostlist.conf"
TXT="domain-block-manual.txt"

PRIV_FILE="mal-hostlist.conf"

if [ -f $PRIV_FILE ]; then
        rm $PRIV_FILE
fi

wget -O $TMP1 http://hosts.mwsl.org.cn/hosts

[ ! -s $TMP1 ] && echo "$TMP1 is empty. Please re-download." && exit
[ -s $CONFIGFILE ] && rm -f $CONFIGFILE

grep -a -e ^191.101.229.116 $TMP1 | \
sed -e "s/191.101.229.116 //" \
 -e "s/^[ \x09]*//;s/[ \x09]*$//" \
 -e "/^$/ d" > $TMP2 

while read line; do
        ADDRESS="/${line}/${NULLIP}"
        echo "address=${ADDRESS}" >> $CONFIGFILE 
done < $TMP2

TITLE=$(read line < $TMP1 && echo ${line})
echo "Updated successfully: $TITLE"

[ -e $TXT ] && cat $TXT >> $CONFIGFILE
echo "A manual list founded and it's been added."

tail $CONFIGFILE

rm $TMP1
rm $TMP2
# /etc/init.d/dnsmasq restart

exit
