#!/bin/ash

if [ ! -f /done ]
then
  echo ${GIT_PUB_KEY} > /tmp/git.pub
  su - git -c "gitolite setup -pk \"/tmp/git.pub\""
  ln -s /repos /var/lib/git/repositories/repos
  touch /done
fi

chown -R git:git /repos

/usr/sbin/sshd -D

