#!/bin/ash

if [ ! -f /done ]
then
  usermod -u ${UID} git
  groupmod -g ${GID} git
  chown -R ${UID}:${GID} /repos
  chown -R ${UID}:${GID} /var/lib/git
  echo ${GIT_PUB_KEY} > /tmp/git.pub
  su - git -c "gitolite setup -pk \"/tmp/git.pub\""
  ln -s /repos /var/lib/git/repositories/repos
  touch /done
fi

/usr/sbin/sshd -D

