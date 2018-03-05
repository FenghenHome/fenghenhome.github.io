#!/bin/sh
rm -rf accelerated-domains.china.conf bogus-nxdomain.china.conf adblock.conf china_ssr.txt gfw_list.conf ignore.list
cnlist() {
    wget -4 --no-check-certificate -O accelerated-domains.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf
    wget -4 --no-check-certificate -O bogus-nxdomain.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf
    wget -4 --no-check-certificate -O bogus-nxdomain.china.ext.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/ip.conf
    wget -4 --no-check-certificate -O google.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
    wget -4 --no-check-certificate -O apple.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
    wget -4 --no-check-certificate -O china_ssr.txt https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ip_list

    # DNS:https://puredns.cn、https://pdomo.me、http://aixyz.com、http://www.fundns.cn、https://www.onedns.net、https://baidns.cn
    sed -i "s/114.114.114.114/123.207.137.88/g" *.conf

    # bogus-nxdomain.china.conf
    cat bogus-nxdomain.china.conf bogus-nxdomain.china.ext.conf > file.txt
    rm -rf bogus-nxdomain.china.ext.conf bogus-nxdomain.china.conf
    mv file.txt bogus-nxdomain.china.conf
    sort -n bogus-nxdomain.china.conf | uniq
    sort -n bogus-nxdomain.china.conf | awk '{if($0!=line)print; line=$0}'
    sort -n bogus-nxdomain.china.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'

    # accelerated-domains.china.conf
    cat google.china.conf apple.china.conf > china.conf
    cat accelerated-domains.china.conf china.conf > file.txt
    rm -rf google.china.conf apple.china.conf accelerated-domains.china.conf china.conf
    mv file.txt accelerated-domains.china.conf
    sort -n accelerated-domains.china.conf | uniq
    sort -n accelerated-domains.china.conf | awk '{if($0!=line)print; line=$0}'
    sort -n accelerated-domains.china.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'
}

adblock() {
    wget -4 --no-check-certificate -O - https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq > adblock.conf

    wget -4 --no-check-certificate -O - https://raw.githubusercontent.com/kcschan/AdditionalAdblock/master/list.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq > adblock.ext.conf

    # adblock.conf
    cat adblock.conf adblock.ext.conf > file.txt
    rm -rf adblock.conf adblock.ext.conf
    mv file.txt adblock.conf
    bash blockad.sh
    cat adblock.conf blockad.conf > file.txt
    rm -rf adblock.conf blockad.conf
    mv file.txt adblock.conf
    bash mwsl.sh
    cat adblock.conf mal-hostlist.conf > file.txt
    rm -rf adblock.conf mal-hostlist.conf
    mv file.txt adblock.conf
    sort -n adblock.conf | uniq
    sort -n adblock.conf | awk '{if($0!=line)print; line=$0}'
    sort -n adblock.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'
}

ignore() {
    wget -4 --no-check-certificate -O ignore.list https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ip_list
}

gfwlist() {
    wget https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh && chmod +x gfwlist2dnsmasq.sh && bash gfwlist2dnsmasq.sh -s gfwlist -o gfw_list.conf
    rm -rf gfwlist2dnsmasq.sh
}

cnlist
adblock
ignore
gfwlist
