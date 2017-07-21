#!/usr/bin/env bash
echo "command is $1"
cmd=$1
stoptimeout=100

server_root=`pwd`
if test -e ${server_root}/env ; then
	source ${server_root}/env
fi

#
# check bundle name
#
if [ -n "${BUNDLE_NAME}" ]; then
	CUR_BUNDLE_NAME=${BUNDLE_NAME}-kepler.jar
else
	echo "please set up BUNDLE_NAME in env"
	exit
fi

if [ ! -f "$CUR_BUNDLE_NAME" ]; then
	echo "cannot find file $CUR_BUNDLE_NAME , please check BUNDLE_NAME in env is right!"
	exit
fi

#
#start
if [[ ${cmd} == *"start"* ]] ;then
	echo "running $1"

	#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=9527 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
	#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.snmp.interface=0.0.0.0 -Dcom.sun.management.snmp.port=12345 -Dcom.sun.management.snmp.acl=false"
	#export JAVA_OPTS="$JAVA_OPTS -server -Xms1024m -Xmx1024m -Xmn448m -Xss256K -XX:MaxPermSize=128m -XX:ReservedCodeCacheSize=64m"
	#export JAVA_OPTS="$JAVA_OPTS -XX:+UseParallelGC -XX:+UseParallelOldGC -XX:ParallelGCThreads=2"
	#export JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
	export JAVA_OPTS="$JAVA_OPTS -Dlog4j.configuration=file:log4j.properties -Dcom.kepler.admin.transfer.impl.transfertask.enabled=true"
	export JAVA_OPTS="$JAVA_OPTS -Dcom.kepler.admin.status.impl.statustask.enabled=true"
	export JAVA_OPTS="$JAVA_OPTS -Dcom.kepler.trace.collector.TraceTransferService.SerialID.serial=snappy"

	#
	# gen sid
	#
	if ! [ -s sid ]; then
		echo "rm sid"
		rm sid
	fi

	if test ! -e sid ; then
		echo "gen sid using md5sum"
		echo $HOSTNAME`pwd` | md5sum | awk '{print $1}' > sid;
	fi

	if ! [ -s sid ]; then
		echo "gen sid using md5"
		echo $HOSTNAME`pwd` | md5 | awk '{print $1}' > sid;
	fi

	#
	# wget log4j
	#
	arr=${JAVA_OPTS}
	for key in ${arr}
	do
		x="$(echo ${key} | awk -F '=' '{ print $1 "=" $2}')"
		for i in ${x};
		do
			if [[ ${i} == *"Ddisconf"* ]] ;then
				if [[ ${i} == *"Ddisconf.conf_server"* ]] ;then
					disconf_server=`echo $i | awk -F '=' '{print $2}'`
				fi
				if [[ ${i} == *"Ddisconf.app"* ]] ;then
					disconf_app=`echo $i | awk -F '=' '{print $2}'`
				fi
				if [[ ${i} == *"Ddisconf.version"* ]] ;then
					disconf_version=`echo $i | awk -F '=' '{print $2}'`
				fi
				if [[ ${i} == *"Ddisconf.env"* ]] ;then
					disconf_env=`echo $i | awk -F '=' '{print $2}'`
				fi
			fi
		done
	done

	if [ ${disconf_server}  ] && [ ${disconf_app}  ] && [ ${disconf_version}  ] && [ ${disconf_env} ]; then
		cur_url=http://"$disconf_server"/api/config/file\?app="$disconf_app"\&env="$disconf_env"\&version="$disconf_version"\&type=0\&key=log4j.properties
		echo ${cur_url}
		wget ${cur_url} -O log4j.properties.new
		if test -s "log4j.properties.new" ; then
		 mv log4j.properties.new log4j.properties
		fi
	fi

	log_name=`date "+%Y%m%d%H%M%S"`

	mkdir -p logs
	echo "java ${JAVA_OPTS} ${SELF_OPTS} -jar -Dcom.kepler.host.impl.serverhost.sid=`cat sid` -Dodin.monitor=$BUNDLE_NAME $CUR_BUNDLE_NAME ${ARGUMENT}>> logs/log_"${log_name}".log &"
	nohup java ${JAVA_OPTS} ${SELF_OPTS} -jar -Dcom.kepler.host.impl.serverhost.sid=`cat sid` -Dodin.monitor=${BUNDLE_NAME} ${CUR_BUNDLE_NAME} ${ARGUMENT} >> logs/log_"${log_name}".log &
	sleep 2s
fi

#
#stop
if [[ ${cmd} == *"stop"* ]] ;then
	echo "running $1"
	sid_value=`cat sid`

	if [ -n "$sid_value" ] ; then
		PIDS=`ps -ef | grep ${sid_value} | grep -v ' grep' | awk '{print $2}'`
		for f in `echo ${PIDS[@]}`; do
			echo "Find process and pid=["$f"]"
			kill -15 $f

			for((timefly=0;timefly<999;timefly=timefly+2))
			do
			   CUR_PID=`ps -ef | grep ${sid_value} | grep $f | grep -v ' grep' | awk '{print $2}'`
			   if [ ${CUR_PID} ]; then
			   		sleep 2
			   		echo "wait $f to be stopped...."
			   else
			   		echo "$f stop"
			   		echo "Kill pid=["$f"] done"
			   		break
			   fi

				#如果经过了很长时间，kill -9
				if [ ${timefly} -gt ${stoptimeout} ]; then
					kill -9 ${f}
					echo '强行终止进程' ${BUNDLE_NAME}
					break
				fi
			done
		done
	fi
fi

#reloadn
if [[ ${cmd} == *"reload"* ]] ;then
	echo "running $1"
fi

#check_health
if [[ ${cmd} == *"check_health"* ]] ;then
	echo "running $1"
	sid_value=`cat sid`

	if [ -n "$sid_value" ] ; then
		PIDS=`ps -ef | grep ${sid_value} | grep -v ' grep' | awk '{print $2}'`
		for f in `echo ${PIDS[@]}`; do
			echo "process is health and pid=["$f"]"
		done
	fi
fi
