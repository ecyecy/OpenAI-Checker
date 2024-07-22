#!/bin/bash
###
# @Author: Vincent Young
# @Date: 2023-02-09 17:39:59
# @LastEditors: ecyecy
# @LastEditTime: 2024-07-22 21:21:00
# @FilePath: /OpenAI-Checker/openai.sh
# @Telegram: https://t.me/missuo
# 
# Copyright © 2023 by Vincent, All Rights Reserved.
###

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PLAIN='\033[0m'
BLUE="\033[36m"

SUPPORT_COUNTRY=(AL DZ AD AO AG AR AM AU AT AZ BS BD BB BE BZ BJ BT BO BA BW BR BN BG BF CV CA CL CO KM CG CR CI HR CY CZ DK DJ DM DO EC SV EE FJ FI FR GA GM GE DE GH GR GD GT GN GW GY HT VA HN HU IS IN ID IQ IE IL IT JM JP JO KZ KE KI KW KG LV LB LS LR LI LT LU MG MW MY MV ML MT MH MR MU MX FM MD MC MN ME MA MZ MM NA NR NP NL NZ NI NE NG MK NO OM PK PW PS PA PG PY PE PH PL PT QA RO RW KN LC VC WS SM ST SN RS SC SL SG SK SI SB ZA KR ES LK SR SE CH TW TZ TH TL TG TO TT TN TR TV UG UA AE GB US UY VU ZM)
echo -e "${BLUE}OpenAI Access Checker. Made by Vincent${PLAIN}"
echo -e "${BLUE}https://github.com/missuo/OpenAI-Checker${PLAIN}"
echo "-------------------------------------"

check_additional_endpoints() {
    tmpresult1=$(curl -s 'https://api.openai.com/compliance/cookie_requirements' -H 'authority: api.openai.com' -H 'accept: */*' -H 'accept-language: en-US,en;q=0.9' -H 'authorization: Bearer null' -H 'content-type: application/json' -H 'origin: https://platform.openai.com' -H 'referer: https://platform.openai.com/' -H 'sec-ch-ua: "Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' -H 'sec-fetch-dest: empty' -H 'sec-fetch-mode: cors' -H 'sec-fetch-site: same-site' --user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36')
    tmpresult2=$(curl -s 'https://ios.chat.openai.com/' -H 'authority: ios.chat.openai.com' -H 'accept: */*;q=0.8,application/signed-exchange;v=b3;q=0.7' -H 'accept-language: en-US,en;q=0.9' -H 'sec-ch-ua: "Google Chrome";v="89", "Chromium";v="89", ";Not A Brand";v="99"' -H 'sec-ch-ua-mobile: ?0' -H 'sec-ch-ua-platform: "Windows"' -H 'sec-fetch-dest: document' -H 'sec-fetch-mode: navigate' -H 'sec-fetch-site: none' -H 'sec-fetch-user: ?1' -H 'upgrade-insecure-requests: 1' --user-agent 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.82 Safari/537.36')

    if [ -z "$tmpresult1" ] || [ -z "$tmpresult2" ]; then
        echo -e "${RED}Failed (Network Connection)${PLAIN}"
        return 1
    fi

    result1=$(echo "$tmpresult1" | grep -i 'unsupported_country')
    result2=$(echo "$tmpresult2" | grep -i 'VPN')

    if [ -z "$result2" ] && [ -z "$result1" ]; then
        return 0
    elif [ -n "$result2" ] && [ -n "$result1" ]; then
        echo -e "${RED}No${PLAIN}"
        return 1
    elif [ -z "$result1" ] && [ -n "$result2" ]; then
        echo -e "${YELLOW}No (Only Available with Web Browser)${PLAIN}"
        return 1
    elif [ -n "$result1" ] && [ -z "$result2" ]; then
        echo -e "${YELLOW}No (Only Available with Mobile APP)${PLAIN}"
        return 1
    else
        echo -e "${RED}Failed (Error: Unknown)${PLAIN}"
        return 1
    fi
}

if [[ $(curl -sS https://chat.openai.com/ -I | grep "text/plain") != "" ]]
then
    echo -e "${RED}Your IP is BLOCKED!${PLAIN}"
else
    echo -e "[IPv4]"
    check4=$(ping -c 1 1.1.1.1 2>&1)
    if [[ "$check4" != *"1 received"* ]] && [[ "$check4" != *"1 packets transmitted"* ]];then
        echo -e "${BLUE}IPv4 is not supported on the current host. Skip...\033[0m"
    else
        local_ipv4=$(curl -4 -sS https://chat.openai.com/cdn-cgi/trace | grep "ip=" | awk -F= '{print $2}')
        local_isp4=$(curl -s -4 --max-time 10 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv4}" | grep organization | cut -f4 -d '"')
        echo -e "${BLUE}Your IPv4: ${local_ipv4} - ${local_isp4}${PLAIN}"
        iso2_code4=$(curl -4 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')
        if [[ "${SUPPORT_COUNTRY[@]}" =~ "${iso2_code4}" ]]; then
            if check_additional_endpoints; then
                echo -e "${GREEN}Your IP supports access to OpenAI. Region: ${iso2_code4}${PLAIN}"
            fi
        else
            echo -e "${RED}Region: ${iso2_code4}. Not support OpenAI at this time.${PLAIN}"
        fi
    fi

    echo "-------------------------------------"
    echo -e "[IPv6]"
    check6=$(ping6 -c 1 240c::6666 2>&1)
    if [[ "$check6" != *"1 received"* ]] && [[ "$check6" != *"1 packets transmitted"* ]];then
        echo -e "${BLUE}IPv6 is not supported on the current host. Skip...\033[0m"
    else
        local_ipv6=$(curl -6 -sS https://chat.openai.com/cdn-cgi/trace | grep "ip=" | awk -F= '{print $2}')
        local_isp6=$(curl -s -6 --max-time 10 --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36" "https://api.ip.sb/geoip/${local_ipv6}" | grep organization | cut -f4 -d '"')
        echo -e "${BLUE}Your IPv6: ${local_ipv6} - ${local_isp6}${PLAIN}"
        iso2_code6=$(curl -6 -sS https://chat.openai.com/cdn-cgi/trace | grep "loc=" | awk -F= '{print $2}')
        if [[ "${SUPPORT_COUNTRY[@]}" =~ "${iso2_code6}" ]]; then
            if check_additional_endpoints; then
                echo -e "${GREEN}Your IP supports access to OpenAI. Region: ${iso2_code6}${PLAIN}"
            fi
        else
            echo -e "${RED}Region: ${iso2_code6}. Not support OpenAI at this time.${PLAIN}"
        fi
    fi

    echo "-------------------------------------"
fi
