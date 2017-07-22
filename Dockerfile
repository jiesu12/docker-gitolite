FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y openssh

RUN useradd -ms /bin/bash git
USER git
WORKDIR /home/git

COPY gitolite /home/git/
RUN mkdir /home/git/bin
/home/git/gitolite/install -ln /home/git/bin
ENV PATH="/home/git/bin:${PATH}"

RUN mkdir /home/git/.ssh
RUN chmod go-rwx /home/git/.ssh

COPY id_rsa.pub /tmp/cs.pub
gitolite setup -pk /tmp/cs.pub

VOLUME /home/git/repositories/repos

EXPOSE 22
