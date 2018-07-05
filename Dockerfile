FROM alpine:3.5

RUN apk update \
&& apk add gitolite openssh

RUN ssh-keygen -q -N '' -f /etc/ssh/ssh_host_rsa_key -t rsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_dsa_key -t dsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_ecdsa_key -t ecdsa \
&& ssh-keygen -q -N '' -f /etc/ssh/ssh_host_ed25519_key -t ed25519

RUN sed -i s/#PubkeyAuthentication.*/PubkeyAuthentication\ yes/ /etc/ssh/sshd_config \
&& sed -i s/#PasswordAuthentication.*/PasswordAuthentication\ no/ /etc/ssh/sshd_config

# Without this will cause sshd error: User git not allowed because account is locked
RUN passwd -u git

# shadow would disallow `passwd -u git`, so install it after.
# need shadow to update user git's gid and uid in start.sh
RUN apk add shadow \
&& rm -rf /var/cache/apk/*

VOLUME /repos

COPY start.sh /
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

EXPOSE 22
