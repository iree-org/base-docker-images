# base-docker-images

Utility repository for publishing docker images that we depend on.

These images build and publish automatically using GitHub Actions.

## Available images

Image name | Description | Source Dockerfile
---------- | ----------- | -----------------
`iree-org/amdgpu_ubuntu_jammy_x86_64` | Ubuntu with AMDGPU deps | [Source](./dockerfiles/amdgpu_ubuntu_jammy_x86_64.Dockerfile)
`iree-org/amdgpu_ubuntu_jammy_ghr_x86_64` | Ubuntu with AMDGPU deps (GitHub runner) | [Source](./dockerfiles/amdgpu_ubuntu_jammy_ghr_x86_64.Dockerfile)
`iree-org/cpubuilder_ubuntu_jammy` | CPU builder with IREE build deps | [Source](./dockerfiles/cpubuilder_ubuntu_jammy.Dockerfile)
`iree-org/cpubuilder_ubuntu_jammy_ghr` | CPU builder with IREE build deps (GitHub runner) | [Source](./dockerfiles/cpubuilder_ubuntu_jammy_ghr.Dockerfile)
`iree-org/manylinux_x86_64` | Portable Linux release builder for Python packaging | [Source](./dockerfiles/manylinux_x86_64.Dockerfile)
`iree-org/manylinux_ghr_x86_64` | Portable Linux release builder for Python packaging (GitHub runner) | [Source](./dockerfiles/manylinux_ghr_x86_64.Dockerfile)

## Using published images

Images are published to the GitHub Container registry which uses the
`https://ghcr.io` package namespace. See
[GitHub's documentation](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
for full details.

The full list of packages can be browsed at
https://github.com/orgs/iree-org/packages?repo_name=base-docker-images. Images
can be referenced using tags or hashes:

* `ghcr.io/iree-org/manylinux_x86_64:main`
* `ghcr.io/iree-org/manylinux_x86_64@sha256:facedb71df670016e74e646d71e869e6fff70d4cdbaa6634d4d0a10d6e174399`
  (for example)

## Building locally

To build locally, use a command like:

```bash
sudo docker buildx build --file dockerfiles/some.Dockerfile .
```

This will print a SHA image id, which you can run with:

```bash
sudo docker run --rm -it --entrypoint /bin/bash <<IMAGE>>
```

You can also
[tag an image](https://docs.docker.com/get-started/docker-concepts/building-images/build-tag-and-publish-an-image/)
to avoid needing to copy the SHA each time:

```bash
sudo docker buildx build --file dockerfiles/cpubuilder_ubuntu_jammy.Dockerfile . --tag cpubuilder:latest
sudo docker run --rm --mount type=bind,source="$(realpath ~/iree)",target=/iree -it --entrypoint bash cpubuilder:latest
```

## Multi-arch and multi-platform builds

We publish images for multiple architectures, e.g. amd64 and arm64. See
the documentation for multi-arch and multi-platform builds here:

* https://www.docker.com/blog/multi-arch-build-and-images-the-simple-way/
* https://docs.docker.com/build/building/multi-platform/
* https://docs.docker.com/build/ci/github-actions/multi-platform/

To build and use a multi-architecture image, pass `--platform`:

```bash
sudo docker buildx build --file dockerfiles/cpubuilder_ubuntu_jammy.Dockerfile --platform=linux/arm64,linux/amd64 . --tag cpubuilder:latest
```

* To run a multiplatform image on your host architecture, no changes are needed:

    ```bash
    sudo docker run --rm -it --entrypoint bash cpubuilder:latest

    root:/$ uname -m
    x86_64
    ```

* To run a multiplatform image on a different architecture, pass `--platform`:

    ```bash
    sudo docker run --rm -it --entrypoint bash --platform=linux/arm64 cpubuilder:latest

    root:/$ uname -m
    aarch64
    ```
