## Start
```
docker run -d -p 2222:22 -v /path/to/repos:/repositories -e UID=1000 -e GID=1000 -e GIT_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" --name gitolite jiesu/gitolite-arm
```

## Test clone
```
git clone ssh://git@localhost:2222/gitolite-admin.git
```

