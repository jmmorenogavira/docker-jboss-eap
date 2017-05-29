FROM jboss/base-jdk:7
MAINTAINER Jose Manuel Moreno Gavira <josem.moreno.gavira@gmail.com>

USER	root

# locales
RUN		yum -y update
ENV		LANG en_US.utf8

# jboss eap 5.2 (jboss files)
ENV		JBOSS_EAP_HOME /opt/jboss/eap-5.2
COPY	files/jboss-eap-5.2.tar.gz-part-* /opt/jboss/
RUN		cat /opt/jboss/jboss-eap-5.2.tar.gz-part-* > /opt/jboss/jboss-eap-5.2.tar.gz
RUN		tar -zxvf /opt/jboss/jboss-eap-5.2.tar.gz -C /opt/jboss/
RUN		mv /opt/jboss/jboss-eap-5.2 /opt/jboss/eap-5.2
RUN		rm -rf /opt/jboss/jboss-eap-5.2.tar.gz*
RUN		ln -s /opt/jboss/jboss-eap* ${JBOSS_EAP_HOME}


# jboss snapshot (jboss server configuration)
COPY	files/myconf.tar.gz-part-* ${JBOSS_EAP_HOME}/jboss-as/server/
RUN		cat ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz-part-* > ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz
RUN		tar -zxvf ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz -C ${JBOSS_EAP_HOME}/jboss-as/server/
RUN		rm -rf ${JBOSS_EAP_HOME}/jboss-as/server/myconf.tar.gz*

# shell scripts
COPY	files/jboss-eap	/usr/local/bin/
RUN		chmod +x /usr/local/bin/jboss-eap

# launch JBoss using default profile
#ENTRYPOINT	["/usr/local/bin/jboss-eap", "default"]
