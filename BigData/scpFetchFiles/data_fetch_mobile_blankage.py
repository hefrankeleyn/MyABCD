#!/user/bin/python
# -*- coding: utf-8 -*-
###################
#
#  拉取 mobile_blankage 业务的 python脚本，每小时运行一次
#  python data_fetch_mobile_blankage.py 2019040114
#  日志输出目录： /data0/log_files/active_examine_logs/mobile_blankage
#  Author: Li Fei
#  Date: 2019-03-15
##############################################

import os,json,re,shutil,datetime,sys,logging
from dateutil.relativedelta import relativedelta
logging.basicConfig(level=logging.DEBUG,format=' %(asctime)s - %(levelname)s - %(message)s')


# 根据文件名，从远程目录拉取文件
def scp_file_to_onepost_byfilename(username,ip,local_fold,log_src_dir,filename):
    scp_command_str=r'scp %s@%s:%s/%s %s' % (username,ip,log_src_dir,filename,local_fold)
    logging.info(scp_command_str)
    os.system(scp_command_str)

# 对拉取到本地的文件进行重命名
def renameDateLogAndwriteNode(local_fold):
   #loop flod files
   # 20190319-07.40.32.log.old
   # 
   dateLogRegex=re.compile(r'(\d{8})-\S+\.log.old')
   logRegex=re.compile(r'\.log.old')
   for filename in os.listdir(local_fold):
       dateLogMo=dateLogRegex.search(filename)
       if dateLogMo:
           dateStr=dateLogMo.group(1)
           change_suffix='_DONE.log'
           renameDateLog=logRegex.sub(change_suffix,filename)
           shutil.move(local_fold+'/'+filename,local_fold+'/'+renameDateLog)

# 如果目录不存在，创建目录
def createDirIfNotExists(folds_name):
    if not (os.path.exists(folds_name) and os.path.isdir(folds_name)):
        os.makedirs(folds_name)
        logging.info('create folds %s success!' % (folds_name))
    else:
        logging.info('%s exists' % (folds_name))

# 获取当前要拉取数据的时间 通过命令行传递过来的参数
def getYearMonthDay():
    if len(sys.argv)==2:
        year_month_day = str(sys.argv[1])
    else:
        raise Exception('Please enter a argument of date(e.g. 20190315).')
    return year_month_day

# 获取当前时间
def getYearMonthDayHour():
    if len(sys.argv)==2:
        year_month_day_hour = str(sys.argv[1])
    else:
        raise Exception('Please enter a argument of date(e.g. 20190315).')
    return year_month_day_hour

# 将拉取的多个文件数据合并到一个文件里面
def mergeFile(business_name,runtime,shell_fold):
    ## 将采集的多个目录数据合并到一个目录下
    bash_command = "bash %s/business_onedata_merge.sh %s %s" % (shell_fold,business_name,runtime)
    logging.info(bash_command)
    os.system(bash_command)
# ip地址
# 172.17.1.36-38
ips=['172.17.1.36', '172.17.1.37', '172.17.1.38']
# 用户名
username='aiwm'
password='aiwm@CUWO'
# 业务名称
business_name='mobile_blankage'
# 脚本路局
shell_fold='/home/aimcpro/womail_script/data_fetchs'
'''源目录'''
# /opt/aimcpro/aimcpro/log/YYYY/mm/dd/HH/
log_src_dir='/opt/aiwm/mobile_blankage_logs'
'''本地目录根目录'''
main_fold='/data0/active_examine/%s' % (business_name)

try:
    #year_month_day=getYearMonthDay()
    # 修改为每小时运行一次
    year_month_day_hour=getYearMonthDayHour()
    year_month_day=datetime.datetime.strptime(year_month_day_hour,'%Y%m%d%H').strftime('%Y%m%d')
    logging.info('远程目录：%s' % log_src_dir)
    # 遍历ip地址
    for ip in ips:
        # 本地目录如果不存在，创建本地目录
        child_fold='%s%s' % (business_name,ip.split('.')[3])
        local_fold = '%s/%s/%s' % (main_fold,child_fold,year_month_day)
        createDirIfNotExists(local_fold)
        # 远程地址的文件名  20190319-07.40.32.log.old
        filename_like=r'%s-*.log.old' % (year_month_day)
        scp_file_to_onepost_byfilename(username,ip,local_fold,log_src_dir,filename_like)
        # 对本地文件进行重命名
        renameDateLogAndwriteNode(local_fold)
    # 将拉取的数据合并到一个文件下：
    mergeFile(business_name,year_month_day,shell_fold)
except Exception as e:
    logging.debug(e)

