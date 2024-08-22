# base-docker-images

Utility repository for publishing docker images that we depend on.

These images build and publish automatically using GitHub Actions.

## Available images

Images with `ghr` in their name are configured as GitHub Actions Runners.

Image name | Description
---------- | -----------
`iree-org/amdgpu_ubuntu_jammy_x86_64`<br>`iree-org/amdgpu_ubuntu_jammy_ghr_x86_64` | Ubuntu with AMDGPU deps
`iree-org/cpubuilder_ubuntu_jammy_ghr_x86_64` | CPU builder with IREE build deps
`iree-org/manylinux_x86_64`<br>`iree-org/manylinux_ghr_x86_64` | Portable Linux release builder for Python packaging

## Using published images

Images are published to the GitHub Container registry which uses the
`https://ghcr.io` package namespace. See
[GitHub's documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
for full details.

For typical usage, reference each image using syntax like
`ghcr.io/iree-org/manylinux_x86_64:main`.

## Building locally

To build locally, use a command like:

```
sudo docker buildx build --file dockerfiles/some.Dockerfile .
```

This will print a SHA image id, which you can run with:

```
sudo docker run --rm -it --entrypoint /bin/bash <<IMAGE>>
```
