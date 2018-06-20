## Build and Start
```
docker run -d -p 2222:22 -v /home/jie/tmp/repos:/repos --name gitolite jsu/gitolite
```

## Test clone
```
git clone ssh://git@localhost:2222/gitolite-admin.git
```

## Raspberry pi
change the base image to `arm32v7/ubuntu:18.04`, then build.
