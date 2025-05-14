_default:
    @just --list

build:
    bun run build

dockerfile := quote(join(justfile_directory(), "contrib", "docker", "Dockerfile"))

build-docker CREATED=shell("date --utc +%Y-%m-%dT%H:%M:%SZ") REVISION=shell("git rev-parse HEAD") VERSION=shell("git describe --abbrev=0 --always --dirty --tags"):
    docker buildx build . \
        --build-arg "CREATED={{ CREATED }}" \
        --build-arg "REVISION={{ REVISION }}" \
        --build-arg "VERSION={{ VERSION }}" \
        --file {{ dockerfile }} \
        --platform "linux/amd64,linux/arm64" \
        --tag "git.fruzit.pp.ua/weather/web:{{ VERSION }}" \
        --tag "git.fruzit.pp.ua/weather/web:latest" \
        ;
