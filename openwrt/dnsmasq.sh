#!/bin/bash
rm -rf accelerated-domains.china.conf bogus-nxdomain.china.conf adblock-domains.china.conf ignore-ips.china.conf gfw-domains.china.conf ignore.list
cnlist() {
    wget -4 -O accelerated-domains.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf
    wget -4 -O bogus-nxdomain.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/bogus-nxdomain.china.conf
    wget -4 -O bogus-nxdomain.china.ext.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/ip.conf
    wget -4 -O google.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf
    wget -4 -O apple.china.conf https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf
    # china_ipv4_ipv6_list：https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ipv4_ipv6_list
    wget -4 -O ignore-ips.china.conf https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ipv4_list

    # DNS:https://puredns.cn、https://pdomo.me、https://www.onedns.net、https://hixns.cn
    sed -i "s/114.114.114.114/193.112.15.186/g" *.conf

    # bogus-nxdomain.china.conf
    cat bogus-nxdomain.china.conf bogus-nxdomain.china.ext.conf > file.txt
    rm -rf bogus-nxdomain.china.ext.conf bogus-nxdomain.china.conf
    awk '!x[$0]++' file.txt > bogus-nxdomain.china.conf
    rm -rf file.txt
    sort -n bogus-nxdomain.china.conf | uniq
    sort -n bogus-nxdomain.china.conf | awk '{if($0!=line)print; line=$0}'
    sort -n bogus-nxdomain.china.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'

    # accelerated-domains.china.conf
    cat google.china.conf apple.china.conf > china.conf
    cat accelerated-domains.china.conf china.conf > file.txt
    rm -rf google.china.conf apple.china.conf accelerated-domains.china.conf china.conf
    awk '!x[$0]++' file.txt > accelerated-domains.china.conf
    rm -rf file.txt
    cat accelerated-domains.china.conf mydns.conf > file.txt
    rm -rf accelerated-domains.china.conf
    awk '!x[$0]++' file.txt > accelerated-domains.china.conf
    rm -rf file.txt
    sort -n accelerated-domains.china.conf | uniq
    sort -n accelerated-domains.china.conf | awk '{if($0!=line)print; line=$0}'
    sort -n accelerated-domains.china.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'
}

adblock() {
    wget -4 -O - https://easylist-downloads.adblockplus.org/easylistchina+easylist.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq > adblock-domains.china.conf

    wget -4 -O - https://raw.githubusercontent.com/cjx82630/cjxlist/master/cjx-annoyance.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq > adblock.ext.conf

    wget -4 -O - https://easylist-downloads.adblockplus.org/easyprivacy.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq >> adblock.ext.conf

    wget -4 -O - https://raw.githubusercontent.com/xinggsf/Adblock-Plus-Rule/master/ABP-FX.txt |
    grep ^\|\|[^\*]*\^$ |
    sed -e 's:||:address\=\/:' -e 's:\^:/127\.0\.0\.1:' | uniq >> adblock.ext.conf

    wget -4 -O union.conf https://raw.githubusercontent.com/vokins/yhosts/master/dnsmasq/union.conf
    sed -i "s/0.0.0.0/127.0.0.1/g" union.conf
    sed -i '/#/d' union.conf
    sed -i '/^$/d' union.conf
    sed -i "s/address\=\/\./address\=\//g" union.conf

    wget -4 -O ad.conf http://iytc.net/tools/ad.conf

    # adblock-domains.china.conf
    cat adblock-domains.china.conf adblock.ext.conf > file.txt
    rm -rf adblock-domains.china.conf adblock.ext.conf
    awk '!x[$0]++' file.txt > adblock-domains.china.conf
    rm -rf file.txt
    cat adblock-domains.china.conf union.conf > file.txt
    rm -rf adblock-domains.china.conf union.conf
    awk '!x[$0]++' file.txt > adblock-domains.china.conf
    rm -rf file.txt
    cat adblock-domains.china.conf ad.conf > file.txt
    rm -rf adblock-domains.china.conf ad.conf
    awk '!x[$0]++' file.txt > adblock-domains.china.conf
    rm -rf file.txt
    bash blockad.sh
    cat adblock-domains.china.conf blockad.conf > file.txt
    rm -rf adblock-domains.china.conf blockad.conf
    awk '!x[$0]++' file.txt > adblock-domains.china.conf
    rm -rf file.txt
    cat adblock-domains.china.conf myblock.conf > file.txt
    rm -rf adblock-domains.china.conf
    awk '!x[$0]++' file.txt > adblock-domains.china.conf
    rm -rf file.txt
    sort -n adblock-domains.china.conf | uniq
    sort -n adblock-domains.china.conf | awk '{if($0!=line)print; line=$0}'
    sort -n adblock-domains.china.conf | sed '$!N; /^\(.*\)\n\1$/!P; D'
    sed -i '/\/m\.baidu\.com\/127/d' adblock-domains.china.conf
}

ignore() {
    # china_ipv4_ipv6_list：https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ipv4_ipv6_list
    wget -4 -O ignore.list https://raw.githubusercontent.com/LisonFan/china_ip_list/master/china_ipv4_list
}

gfwlist() {
    # wget -4 -O gfw-domains.china.conf https://cokebar.github.io/gfwlist2dnsmasq/dnsmasq_gfwlist_ipset.conf
    # wget -4 -O gfw-domains.china.conf https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/gh-pages/dnsmasq_gfwlist_ipset.conf
    wget -4 -O gfwlist2dnsmasq.sh https://raw.githubusercontent.com/cokebar/gfwlist2dnsmasq/master/gfwlist2dnsmasq.sh && chmod +x gfwlist2dnsmasq.sh && bash gfwlist2dnsmasq.sh -s gfwlist -o gfw-domains.china.conf
    rm -rf gfwlist2dnsmasq.sh
}

pushcommit() {
    git add -A
    git commit -m "Update *.conf"
    git push origin master
}

cnlist
adblock
ignore
gfwlist
pushcommit
