# docker-build
Utility repository for publishing docker images that we depend on.

These images build and publish automatically by GH actions. To
build locally, use a command like:

```
docker buildx build --file dockerfiles/some.Dockerfile .
```

This will print a SHA image id, which you can run with:

```
sudo docker run --rm -it --entrypoint /bin/bash <<IMAGE>>
```
