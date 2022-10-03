FROM daggerok/jboss-eap-7.2:7.2.5-alpine
MAINTAINER crivano@jfrj.jus.br

#--- ADD ORACLE AND MYSQL DRIVERS
ADD --chown=jboss ./modules.tar.gz ${JBOSS_HOME}/

#--- SET TIMEZONE
ENV TZ=America/Sao_Paulo
ENV LANG pt_BR.UTF-8
ENV LANGUAGE pt_BR.UTF-8
ENV LC_ALL pt_BR.UTF-8

RUN sudo apk --update --no-cache add busybox-extras tzdata
#RUN sudo yum -y install telnet

#--- SET TIMEZONE
RUN sudo sh -c "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone"

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
RUN echo "downloading siga.war, sigaex.war, siga-le.war, sigasr.war, sigagc.war, sigatp.war and sigawf.war" && curl -s https://api.github.com/repos/projeto-siga/siga/releases/latest \
  | grep browser_download_url \
  | grep .war \
  | cut -d '"' -f 4 \
  | xargs wget -q

#--- DEPLOY DO ARQUIVO .WAR ---
RUN mv siga.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigaex.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigawf.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigasr.war ${JBOSS_HOME}/standalone/deployments/
RUN mv sigagc.war ${JBOSS_HOME}/standalone/deployments/
#-- RUN mv sigatp.war ${JBOSS_HOME}/standalone/deployments/
RUN mv siga-le.war ${JBOSS_HOME}/standalone/deployments/

#--- ou copie diretamente do diretório siga-docker para fins de debug
# COPY --chown=jboss ./*.war ${JBOSS_HOME}/standalone/deployments/

#--- COPIANDO standalone.xml ---
COPY --chown=jboss ./standalone.xml ${JBOSS_HOME}/standalone/configuration/standalone.xml

#--- COPIANDO wait-for-it.sh ---
RUN mkdir  bin
COPY ./wait-for-it.sh bin/wait-for-it.sh
RUN sudo chmod +x bin/wait-for-it.sh

EXPOSE 8080
