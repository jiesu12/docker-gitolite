## Start
```
docker run -d -p 2222:22 -v /path/to/repos:/repositories -e UID=1000 -e GID=1000 -e GIT_PUB_KEY="$(cat ~/.ssh/id_rsa.pub)" --name gitolite jiesu/gitolite-arm
```

## Test clone
```
git clone ssh://git@localhost:2222/gitolite-admin.git
```

## Troubleshoot
### FATAL: split conf set, gl-conf not present for 'repos/necfield' fatal: Could not read from remote repository.
To fix this, make sure gitolite-admin/conf/gitolite.conf doesn't contain entry to a specific repo. It would create an empty repo automatically, which will cause this error when pushing the same repo.

The best way to avoid this is to not specify any specific repo in gitolite.conf, like this:
```
repo repos/test
  RW+ = user
```
Instead, specify directory, such as:
```
repo repos/l0/..*
  RW+ = user
```

