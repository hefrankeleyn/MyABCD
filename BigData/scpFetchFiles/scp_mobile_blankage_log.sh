#!/bin/bash
########
# 拉取avl数据
#
# author: Li Fei
# date: 2019-06-13
# 
# eg:
# nohup bash scp_avl_toLocal.sh 201807 1>nohup.out 2>&1 &
#############

month=$1

# 远程目录地址
source_dir="/opt/aiwm/mobile_blankage_logs/${month}-*.log.old"
# 本地目录地址
destination_fold="/data0/active_examine/mobile_blankage/${month}/"
# 远程ip地址
remote_user_ip="billadmin1@172.16.15.56"
remote_password="7?64oOm+>hh_"
local_password="aimcpro@CUWO"

# 如果目录不存在，创建目录
if [ ! -d ${destination_fold} ]; then
  mkdir -p ${destination_fold}
fi

echo `date`" ,begin fetch avl file..."
commond_scp="${remote_user_ip}:${source_dir} ${destination_fold}"
echo "${commond_scp}"

expect -c "
 spawn scp $commond_scp
    expect {
          \"assword\" { send \"$remote_password\r\"}}
  interact
"


echo `date`" ,end fetch avl file!"



