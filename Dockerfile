FROM ubuntu:latest

RUN apt-get update \
&& echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
&& apt-get -y install openssh-server gitolite3

RUN useradd -ms /bin/bash git

COPY gitolite-admin /tmp/gitolite-admin

COPY start.sh /
ENTRYPOINT ["/start.sh"]

EXPOSE 22

CMD ["sshd"]