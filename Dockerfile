FROM ubuntu:latest

RUN mkdir -p /opt/pranav
RUN mkdir /opt/tomcat/
ADD Test.txt /opt/pranav
WORKDIR /opt
ENV TOMCAT_VERSION 8.5.50

#Installing required packages
RUN apt-get update && apt-get -y install software-properties-common locales git build-essential curl wget

#Installing openjdk11 from official repo
RUN wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz && \
    tar zxvf openjdk-11+28_linux-x64_bin.tar.gz

#Installing Tomcat version 8.5.50 from official repo
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

ADD jenkins.war /opt/tomcat/apache-tomcat-8.5.50/webapps

#Defining installed directory location as ENV variable inside container
ENV CATALINA_HOME /opt/tomcat/apache-tomcat-${TOMCAT_VERSION}
ENV JAVA_HOME=/opt/jdk-11
ENV PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin
EXPOSE 8080

#CMD ["tail", "-f", "/opt/pranav/Test.txt"]
CMD ["sh", "-c", "/opt/tomcat/apache-tomcat-8.5.50/bin/catalina.sh run"]