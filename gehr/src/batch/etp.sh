
export PATH=/usr/WebSphere/AppServer/java/jre/sh:$PATH
#export PATH

export CLASSPATH=$CLASSPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap:/usr/WebSphere/AppServer/lib:/usr/WebSphere/AppServer/lib/servlet.jar:/usr/WebSphere/AppServer/lib/ujc.jar:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/classes12.zip:/usr/WebSphere/AppServer/classes/oracle:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/log4j-1.2.9.jar:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/ojdbc14.jar
export LIBPATH=$LIBPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap;

#. /home/qasadm/.profile


#export NLS_LANG=American_America.WE8DEC;

cd /usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch

DATE=`date '+%Y%m%d'`

export CLASSPATH=$CLASSPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch:/usr/WebSphere/AppServer/lib:/usr/WebSphere/AppServer/lib/servlet.jar:/usr/WebSphere/AppServer/lib/ujc.jar:/usr/WebSphere/AppServer/classes/oracle:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/log4j-1.2.9.jar:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/ojdbc14.jar

java $1 > EHR_BATCH$DATE.log
