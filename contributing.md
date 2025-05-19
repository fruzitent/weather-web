# contributing

## Build

### With Bun

Requirements:

- [Bun](https://bun.sh/docs/installation) runtime

```shell
bun run openapi-ts
bun run build
```

### With Docker

Requirements:

- [buildx](https://github.com/docker/buildx) plugin
- [containerd](https://docs.docker.com/build/building/multi-platform)-enabled image store

```shell
just build-docker
```
