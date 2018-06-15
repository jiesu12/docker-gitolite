## Build and Start
```
docker build -t jsu/gitolite .
docker run -d -p 2222:22 --name gitolite jsu/gitolite
```

## Test clone
```
git clone ssh://git@localhost:2222/testing.git
git clone ssh://git@localhost:2222/gitolite-admin.git
```