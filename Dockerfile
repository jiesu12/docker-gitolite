FROM ubuntu:latest

RUN apt-get update && apt-get -y install openssh-server && apt-get -y install perl

RUN useradd -ms /bin/bash git
USER git
WORKDIR /home/git

ADD gitolite /home/git/gitolite
RUN mkdir /home/git/bin
RUN /home/git/gitolite/install -ln /home/git/bin
ENV PATH="/home/git/bin:${PATH}"

RUN mkdir /home/git/.ssh
RUN chmod go-rwx /home/git/.ssh

COPY id_rsa.pub /tmp/cs.pub
RUN gitolite setup -pk /tmp/cs.pub

VOLUME /home/git/repositories/repos

EXPOSE 22
