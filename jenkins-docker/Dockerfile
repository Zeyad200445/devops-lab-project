FROM jenkins/jenkins:lts
USER root
# Install Docker CLI so Jenkins can run "docker build"
RUN apt-get update && \
    apt-get install -y docker.io
# Add jenkins user to root group (risky in prod, necessary for local socket access)
RUN usermod -aG root jenkins
USER jenkins