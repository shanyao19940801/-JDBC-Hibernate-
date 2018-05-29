#!/bin/bash
tomcat_home='/home/tomcat/apache-tomcat-8.5.8'
tomcatpath=${tomcat_home}'/bin'
SHUTDOWN=$tomcat_home/bin/shutdown.sh
STARTTOMCAT=$tomcat_home/bin/startup.sh


echo 'operate restart tomcat: '$tomcatpath
pid=$(ps -ef | grep $tomcatpath | grep '/bin/java' | grep -v grep | awk '{print $2}')
echo 'exist pid:'$pid

if [ -n "$pid" ]
then 
{
	echo =====kill tomcat begin=====
	echo $pid
	kill -9 $pid
	echo =====kill tomcat end=======
	
	sleep 2
	echo ======startup.sh========
	$STARTTOMCAT
}
else
echo =========startup.sh==============
{
	echo $STARTTOMCAT
	$STARTTOMCAT
}
fi



注意：
1、编写脚本里的tomcat的路径是你自己的tomcat的路径


赋权语句

chmod 777 ./tomcat.sh 
然后运行就可以了 


#原文地址
==https://blog.csdn.net/sjzylc/article/details/45030265

