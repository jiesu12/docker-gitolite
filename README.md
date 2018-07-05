## Start
First time run this to setup the admin account:
```
docker run -d -p 2222:22 -v /path/to/repos:/repos -e UID=1000 -e GID=1000 -e GIT_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" --name gitolite jiesu/gitolite-arm
```
After that, can run without GIT_PUB_KEY:
```
docker run -d -p 2222:22 -v /path/to/repos:/repos --name gitolite jiesu/gitolite
```

## Test clone
```
git clone ssh://git@localhost:2222/gitolite-admin.git
```

## Raspberry pi
change the base image to `armhf/alpine:3.5`, then build.
