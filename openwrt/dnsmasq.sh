#!/bin/sh
rm -rf accelerated-domains.china.conf bogus-nxdomain.china.conf google.china.conf adblock.conf ignore.list
cnlist() {
    wget -4 --no-check-certificate -O accelerated-domains.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf
    wget -4 --no-check-certificate -O bogus-nxdomain.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf
    wget -4 --no-check-certificate -O google.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
    sed -i "s/114.114.114.114/115.159.96.69/g" *.conf
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
    wget -O- 'http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest' | awk -F\| '/CN\|ipv4/ { printf("%s/%d\n", $4, 32-log($5)/log(2)) }' > ignore.list
}

cnlist
adblock
ignore