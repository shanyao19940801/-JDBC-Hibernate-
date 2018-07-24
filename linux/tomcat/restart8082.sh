#!/bin/bash
tomcat_home='/home/tomcat/apache-tomcat-8082'
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