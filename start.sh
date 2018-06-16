#!/bin/bash

if [ ! -f /home/git/done ]
then
  /usr/sbin/sshd -D &
  su - git -c "GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git clone ssh://git@localhost/gitolite-admin.git"
  su - git -c "cp -r /tmp/gitolite-admin/* /home/git/gitolite-admin/"
  su - git -c "git config --global user.email 'git@locahost' && git config --global user.name 'Git admin'"
  su - git -c "cd /home/git/gitolite-admin && git add . && git commit -m update && git push"
  rm -rf /home/git/repositories/repos/*
  rm -rf /home/git/gitolite-admin
  touch /home/git/done
  pkill sshd
  sleep 5
fi

/usr/sbin/sshd -D