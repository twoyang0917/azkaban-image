#!/bin/sh

AZKABAN_HOME=/opt/azkaban-web-server

for file in $AZKABAN_HOME/lib/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $AZKABAN_HOME/extlib/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $AZKABAN_HOME/plugins/*/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

cd $AZKABAN_HOME && java -server $AZKABAN_OPT \
    -Dlog4j.configuration=file:$AZKABAN_HOME/conf/log4j.properties \
    -Dlog4j.log.dir=$AZKABAN_HOME/logs \
    -Dcom.sun.management.jmxremote \
    -Djava.io.tmpdir=/tmp \
    -Dexecutorport= \
    -Dserverpath=$AZKABAN_HOME \
    -cp $CLASSPATH \
    azkaban.webapp.AzkabanWebServer \
    -conf $AZKABAN_HOME/conf
