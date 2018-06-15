FROM ubuntu:latest

RUN apt-get update \
&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& apt-get -y install openssh-server gitolite3

# sshd won't start without this folder
RUN mkdir /var/run/sshd
# Disable unwanted authentications
RUN sed -i -E -e 's/^#?(\w+Authentication)\s.*/\1 no/' -e 's/^(PubkeyAuthentication) no/\1 yes/' /etc/ssh/sshd_config
# Disable sftp subsystem
RUN sed -i -E 's/^Subsystem\ssftp\s/#&/' /etc/ssh/sshd_config

# Setup git user
RUN useradd -ms /bin/bash git
RUN chown -R git:git ~git

# Setup gitolite
COPY gitolite-admin /tmp/gitolite-admin
RUN su - git -c "gitolite setup -pk \"/tmp/gitolite-admin/keydir/jie.pub\""

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]