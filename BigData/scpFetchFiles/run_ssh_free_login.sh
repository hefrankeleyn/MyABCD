#!/bin/bash
########
# Function: batch ssh free secret login
########
#
#Author: LiFei
#Date: 2019-09-24
# description: 有些免密会失效，定时设置免密
#########################


IP_PASSWORD=/data0/womail_script/fetch_data/user_ip_password.txt

for IP in $(cat $IP_PASSWORD)
do
  ip=$(echo "$IP" | cut -f1 -d ":")
  password=$(echo "$IP" | cut -f2 -d ":")

  # begin expect
  expect -c "
 spawn ssh-copy-id $ip
    expect {
          \"yes/no\" { send \"yes\r\";exp_continue}
          \"password\" { send \"$password\r\"}}
  interact
  "
done

