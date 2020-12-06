#!/bin/bash
########
# Function: batch ssh free secret login
########
#
#Author: LiFei
#Date: 2019-09-24
# description: 有些免密会失效，定时设置免密
#########################


IP_PASSWORD=$1
set timeout 10

for IP in $(cat $IP_PASSWORD)
do
  ip=$(echo "$IP" | cut -f1 -d ":")
  password=$(echo "$IP" | cut -f2 -d ":")
  expect -c "
 spawn ssh-copy-id $ip
    expect {
          \"(yes/no)?\" {\
send \"yes\n\";exp_continue
expect \"*assword:\" { send \"$password\n\"}}
\"*assword:\" { send \"$password\n\"}} 
  interact
  "
done



