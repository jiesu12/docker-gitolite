FROM jiesu/alpine-arm:latest

RUN apk --no-cache add gitolite openssh

RUN ssh-keygen -q -N '' -f /etc/ssh/ssh_host_rsa_key -t rsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_dsa_key -t dsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_ed25519_key -t ed25519

RUN sed -i s/#PubkeyAuthentication.*/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config \
&& sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config

RUN addgroup -g 2000 jie && adduser -D -G jie -u 2000 -s /bin/sh jie

# Without this will cause sshd error: User git not allowed because account is locked
RUN passwd -u git && passwd -u jie

# shadow would disallow `passwd -u git`, so install it after.
# need shadow to update user git's gid and uid in start.sh
RUN apk --no-cache add shadow

VOLUME /repositories

COPY gitconfig /home/jie/.gitconfig
RUN chown jie:jie /home/jie/.gitconfig

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

EXPOSE 22

