#!/bin/sh

if [ ! -f /done ]
then
  usermod -u ${UID} git
  groupmod -g ${GID} git
  chown -R ${UID}:${GID} /repositories
  chown -R ${UID}:${GID} /var/lib/git

  # setup jie user to be the git admin
  su - jie -c "mkdir /home/jie/.ssh"
  su - jie -c 'ssh-keygen -t rsa -N "" -f /home/jie/.ssh/id_rsa'
  su - jie -c 'chmod -R go-rwx /home/jie/.ssh'
  cp /home/jie/.ssh/id_rsa.pub /tmp/git.pub
  chmod go+r /tmp/git.pub
  su - git -c "gitolite setup -pk /tmp/git.pub"

  # start sshd so that we can clone and push during the setup
  /usr/sbin/sshd -D &

  # clone admin repo
  su - jie -c 'GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone ssh://git@localhost/gitolite-admin.git /home/jie//gitolite-admin'
  # restore admin config and keys if the old one exists
  if [ -d /repositories/gitolite-admin.git ]
  then
    git clone /repositories/gitolite-admin.git /home/jie/gitolite-admin-backup
    rm -rf /home/jie/gitolite-admin-backup/.git
    chmod -R go+rw /home/jie/gitolite-admin-backup
    su - jie -c 'cp /home/jie/gitolite-admin/keydir/git.pub /home/jie'
    su - jie -c 'cp -r /home/jie/gitolite-admin-backup/* /home/jie/gitolite-admin'
    su - jie -c 'mv /home/jie/git.pub /home/jie/gitolite-admin/keydir'
  fi

  # add host's key as admin if it has been added before
  if ! grep -q '## added by docker service' /home/jie/gitolite-admin/conf/gitolite.conf
  then
    echo ${GIT_PUB_KEY} >> /home/jie/gitolite-admin/keydir/admin.pub
    chown jie:jie /home/jie/gitolite-admin/keydir/admin.pub
    su - jie -c 'echo "## added by docker service" >> /home/jie/gitolite-admin/conf/gitolite.conf'
    su - jie -c 'echo "repo @all" >> /home/jie/gitolite-admin/conf/gitolite.conf'
    su - jie -c 'echo "    RW+     =   admin" >> /home/jie/gitolite-admin/conf/gitolite.conf'
    su - jie -c 'echo "    C       =   admin" >> /home/jie/gitolite-admin/conf/gitolite.conf'
  fi

  # commit the changes for admin repo
  su - jie -c 'cd /home/jie/gitolite-admin && git add . && git commit -m "restore backup" && GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git push'
  
  # remove the repositories on git home directory, use a symlink instead
  rm -rf /repositores/gitolite-admin.git
  su - git -c "cp -r /var/lib/git/repositories/gitolite-admin.git /repositories"
  rm -rf /var/lib/git/repositories
  su - git -c "ln -s /repositories /var/lib/git/repositories"
  touch /done
  pkill sshd
  sleep 5
  echo "Gitolite server has been setup."
fi

/usr/sbin/sshd -D

