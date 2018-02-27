#!/bin/sh
rm -rf accelerated-domains.china.conf bogus-nxdomain.china.conf google.china.conf adblock.conf ignore.list
cnlist() {
    wget -4 --no-check-certificate -O accelerated-domains.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf
    wget -4 --no-check-certificate -O bogus-nxdomain.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf
    wget -4 --no-check-certificate -O bogus-nxdomain.china.ext.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/ip.conf
    wget -4 --no-check-certificate -O google.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
    sed -i "s/114.114.114.114/115.159.146.99/g" *.conf
}

adblock() {
    wget -4 --no-check-certificate -O - https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq > adblock.conf

    wget -4 --no-check-certificate -O - https://raw.githubusercontent.com/kcschan/AdditionalAdblock/master/list.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq >> adblock.conf
}


ignore() {
    wget -4 --no-check-certificate -O ignore.list https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ip_list
}

cnlist
adblock
ignore
