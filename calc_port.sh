#!/bin/bash

#ポート開放用スクリプト。0～65535番号の中からIPとキーワードで決定

_check_Ip(){
    IP=$(cat -)
    IP_CHECK=$(echo ${IP} | egrep "^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$")
    if [ ! "${IP_CHECK}" ] ; then
        echo ${IP} is not IP Address.
        exit 1
    fi
}

_calc_Port(){
    ori_Number=$(echo $@ | awk -F. '{ print $1*2^24 + $2*2^16 + $3*2^8 + $4}')
    while [ ${ori_Number} -ge 65535 ]
    do
        ori_Number=`expr $ori_Number / $your_Secret_Number`
    done
    echo $ori_Number
}

if [ -p /dev/stdin ]; then
    cat -
else
    echo $@
fi | _check_Ip

if [ $? -eq 0 ]; then
    echo "Input your secret number"
    read your_Secret_Number
    _calc_Port $@ ${your_Secret_Number}
fi