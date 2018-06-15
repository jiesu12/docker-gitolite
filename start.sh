#!/bin/sh

set -- /usr/sbin/sshd -D

# unlike most of the google search results, keys are supposed to be under this folder
mkdir -p /etc/ssh/keys
# Setup SSH HostKeys
for algorithm in rsa dsa ecdsa ed25519
do
  keyfile=/etc/ssh/keys/ssh_host_${algorithm}_key
  [ -f $keyfile ] || ssh-keygen -q -N '' -f $keyfile -t $algorithm
  grep -q "HostKey $keyfile" /etc/ssh/keys/sshd_config || echo "HostKey $keyfile" >> /etc/ssh/sshd_config
done
chmod -R go-r /etc/ssh/keys
# Disable unwanted authentications
sed -i -E -e 's/^#?(\w+Authentication)\s.*/\1 no/' -e 's/^(PubkeyAuthentication) no/\1 yes/' /etc/ssh/sshd_config
# Disable sftp subsystem
sed -i -E 's/^Subsystem\ssftp\s/#&/' /etc/ssh/sshd_config

chown -R git:git ~git
# run gitolite setup as git user
su - git -c "gitolite setup -pk \"/tmp/gitolite-admin/keydir/jie.pub\""

# sshd won't start without this
mkdir -p /var/run/sshd

exec "$@"