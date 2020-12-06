#!/bin/bash
########
# Function: batch ssh free secret login
########
#
#Author: LiFei
#Date: 2019-03-14
#########################


IP_PASSWORD=pmail-ip-password.txt

# if expect exists

rpm -qa | grep expect >> /dev/null

if [ $? -eq 0 ];then
   echo "expect already install"
else
   yum install expect -y
fi


# bash ssh Certification
# echo "10.199.95.150:password" | cut -f1 -d ":"
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
