FROM daggerok/jboss-eap-7.2:7.2.5-alpine
MAINTAINER crivano@jfrj.jus.br

#--- ADD ORACLE AND MYSQL DRIVERS
ADD --chown=jboss ./modules.tar.gz ${JBOSS_HOME}/

#--- SET TIMEZONE
#--- RUN sh -c "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone"

RUN sudo apk --update --no-cache add busybox-extras
#RUN sudo yum -y install telnet

#--- DOWNLOAD LATEST VERSION FROM GITHUB
RUN echo "downloading ckeditor.war" && curl -s https://api.github.com/repos/projeto-siga/siga-docker/releases/latest | grep browser_download_url | grep .war | cut -d '"' -f 4 | xargs wget -q

#--- DEPLOY DO ARQUIVO .WAR ---
RUN mv ckeditor.war ${JBOSS_HOME}/standalone/deployments/

#--- DOWNLOAD LATEST VERSION FROM GITHUB
RUN echo "downloading blucservice.war" && curl -s https://api.github.com/repos/assijus/blucservice/releases/latest \
  | grep browser_download_url \
  | grep blucservice.war \
  | cut -d '"' -f 4 \
  | xargs wget -q

#--- DEPLOY DO ARQUIVO .WAR ---
RUN mv blucservice.war ${JBOSS_HOME}/standalone/deployments/

#--- APT-GET GRAPHVIZ
RUN sudo apk add --update --no-cache graphviz ttf-freefont
#RUN sudo yum -y install graphviz

#--- DOWNLOAD LATEST VERSION FROM GITHUB
RUN echo "downloading vizservice.war" && curl -s https://api.github.com/repos/projeto-siga/vizservice/releases/latest \
  | grep browser_download_url \
  | grep vizservice.war \
  | cut -d '"' -f 4 \
  | xargs wget -q

#--- DEPLOY DO ARQUIVO .WAR ---
RUN mv vizservice.war ${JBOSS_HOME}/standalone/deployments/

#--- DOWNLOAD LATEST VERSION FROM GITHUB
RUN echo "downloading siga.war, sigaex.war and sigawf.war" && curl -s https://api.github.com/repos/projeto-siga/siga/releases/29414996 \
  | grep browser_download_url \
  | grep .war \
  | cut -d '"' -f 4 \
  | xargs wget -q

#--- DEPLOY DO ARQUIVO .WAR ---
RUN mv siga.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigaex.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigawf.war ${JBOSS_HOME}/standalone/deployments/

# COPY --chown=jboss ./*.war ${JBOSS_HOME}/standalone/deployments/

COPY --chown=jboss ./standalone.xml ${JBOSS_HOME}/standalone/configuration/standalone.xml

EXPOSE 8080
