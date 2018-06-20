FROM ubuntu:18.04

RUN apt-get update \
&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& apt-get -y install openssh-server gitolite3

# sshd won't start without this folder
RUN mkdir /var/run/sshd
# Disable unwanted authentications
RUN sed -i -E -e 's/^#?(\w+Authentication)\s.*/\1 no/' -e 's/^(PubkeyAuthentication) no/\1 yes/' /etc/ssh/sshd_config
# Fix the perl warning during git clone - Setting locale failed
RUN sed -i -E 's/AcceptEnv LANG LC/#AcceptEnv LANG LC/g' /etc/ssh/sshd_config
# Disable sftp subsystem
RUN sed -i -E 's/^Subsystem\ssftp\s/#&/' /etc/ssh/sshd_config

# Setup git user
RUN useradd -ms /bin/bash git
RUN mkdir -p /home/git/.ssh
RUN ssh-keygen -f /home/git/.ssh/id_rsa -t rsa -N ''
RUN chown -R git:git ~git
RUN chmod -R go-rwx /home/git/.ssh

# Setup gitolite
COPY gitolite-admin /tmp/gitolite-admin
RUN cp /home/git/.ssh/id_rsa.pub /tmp/git.pub
RUN chmod go+r /tmp/git.pub
RUN su - git -c "gitolite setup -pk \"/tmp/git.pub\""

VOLUME /repos

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

EXPOSE 22
