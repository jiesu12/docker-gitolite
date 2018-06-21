#!/bin/ash

if [ ! -f /done ]
then
  echo ${GIT_PUB_KEY} > /tmp/git.pub
  su - git -c "gitolite setup -pk \"/tmp/git.pub\""
  touch /done
fi

/usr/sbin/sshd -D