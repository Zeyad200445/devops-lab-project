FROM jenkins/jenkins:lts
USER root
# Install Docker CLI AND Maven
# بنسطب Maven عشان يبقى جاهز جوه جينكينز علطول
RUN apt-get update && \
    apt-get install -y docker.io maven
# Add jenkins user to root group
RUN usermod -aG root jenkins
USER jenkins