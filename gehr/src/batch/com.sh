
export PATH=/usr/WebSphere/AppServer/java/jre/sh:$PATH
#export PATH

export CLASSPATH=$CLASSPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch:/usr/WebSphere/AppServer/lib:/usr/WebSphere/AppServer/lib/servlet.jar:/cbo/servlet/jCO.jar:/usr/WebSphere/AppServer/lib/ujc.jar:/cbo/specin/servlet:/usr/WebSphere/AppServer/classes/oracle:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap
export LIBPATH=$LIBPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap;

#. /home/qasadm/.profile


#export NLS_LANG=American_America.WE8DEC;

cd /usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch


export CLASSPATH=$CLASSPATH:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch:/usr/WebSphere/AppServer/lib:/usr/WebSphere/AppServer/lib/servlet.jar:/usr/WebSphere/AppServer/lib/ujc.jar:/usr/WebSphere/AppServer/classes/oracle:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes:/usr/Application/ehr/ehr.ear/ehrWeb.war/WEB-INF/classes/batch/sap/log4j-1.2.9.jar


javac $1.java
