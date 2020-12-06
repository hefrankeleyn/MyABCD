#!/bin/bash
source ~/.bash_profile
#########################
#
# author: Li Fei
# description: crontab except run sh
#########################

passwordfilename_config=/data0/womail_script/sh_logic/free_password/passwordfilename_config.txt

day=`date +"%Y%m%d"`
month_day=${day:0:6}
echo "begin ${day} ..."
if [ -f ${passwordfilename_config} ]
then
    for file_path in `cat ${passwordfilename_config}`
    do
        if [ -f ${file_path} ]
        then
            # 取文件名，去掉后缀
            procName=`echo $file_path | rev | cut -d / -f 1 | rev | cut -d . -f 1`
            loadFile=${procName}_${day}.txt
            root_fold=/data0/log/set_free_password/${procName}/${month_day}
            # 如果目录不存在创建目录
            if [ ! -d ${root_fold} ]; then
              mkdir -p ${root_fold}
            fi
            log_path=${root_fold}/${loadFile}
            echo "-----------------$day --------------------" >> ${log_path} 2>&1
            bash /data0/womail_script/sh_logic/free_password/run_ssh_free_login_by_response_need_parameter.sh  ${file_path}  1>>${log_path} 2>&1
        else
            echo "${file_path} not found."
        fi
    done
else
    echo "${passwordfilename_config} not found."
fi

echo "end ${day} ..."


