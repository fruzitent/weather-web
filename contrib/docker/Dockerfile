# syntax=docker.io/docker/dockerfile:1.15.1-labs@sha256:94edd5b349df43675bd6f542e2b9a24e7177432dec45fe3066bfcf2ab14c4355
# @help: https://docs.docker.com/reference/dockerfile

FROM scratch AS source-deps

COPY --link ["./bun.lock", "./bun.lock"]
COPY --link ["./package.json", "./package.json"]

FROM scratch AS source-code

COPY --link ["./src/", "./src/"]
COPY --link ["./static/", "./static/"]
COPY --link ["./.npmrc", "./.npmrc"]
COPY --link ["./openapi-ts.config.ts", "./openapi-ts.config.ts"]
COPY --link ["./svelte.config.js", "./svelte.config.js"]
COPY --link ["./tsconfig.json", "./tsconfig.json"]
COPY --link ["./vite.config.ts", "./vite.config.ts"]

FROM --platform=$BUILDPLATFORM docker.io/oven/bun:1.2.13-alpine@sha256:3476c857e7c05a7950b3a8a684ffbc82f5cbeffe1b523ea1a92bdefc4539dc57 AS deps

COPY --from=source-deps --link ["/", "/usr/local/src/weather-web/"]

RUN --mount=type=cache,target=/root/.bun bun install --cwd "/usr/local/src/weather-web/"

FROM deps AS builder

COPY --from=source-code --link ["/", "/usr/local/src/weather-web/"]

RUN --mount=type=cache,target=/root/.bun <<EOF
  bun run --cwd "/usr/local/src/weather-web/" openapi-ts
  bun run --cwd "/usr/local/src/weather-web/" build
EOF

FROM docker.io/oven/bun:1.2.13-alpine@sha256:3476c857e7c05a7950b3a8a684ffbc82f5cbeffe1b523ea1a92bdefc4539dc57 AS runner

COPY --from=builder --link ["/usr/local/src/weather-web/build/", "/srv/"]

ENTRYPOINT ["bun"]
CMD ["/srv/index.js"]

HEALTHCHECK --interval=10s --retries=3 --start-period=10s --timeout=5s CMD [ "wget", "--spider", "--tries=1", "http://localhost:3000/-/healthy" ]

ARG CREATED
ARG REVISION
ARG VERSION

LABEL org.opencontainers.image.authors="fruzitent <fruzit@fruzit.pp.ua>"
LABEL org.opencontainers.image.created="${CREATED}"
LABEL org.opencontainers.image.description="Weather WEB application that allows users to subscribe to weather updates for their city"
LABEL org.opencontainers.image.documentation="https://git.fruzit.pp.ua/weather/api/wiki"
LABEL org.opencontainers.image.licenses="MIT License"
LABEL org.opencontainers.image.ref.name="weather/web"
LABEL org.opencontainers.image.revision="${REVISION}"
LABEL org.opencontainers.image.source="https://git.fruzit.pp.ua/weather/api"
LABEL org.opencontainers.image.title="web"
LABEL org.opencontainers.image.url="https://git.fruzit.pp.ua/weather/api"
LABEL org.opencontainers.image.vendor="fruzitent"
LABEL org.opencontainers.image.version="${VERSION}"

# TODO: https://github.com/gornostay25/svelte-adapter-bun/issues/52
STOPSIGNAL SIGKILL
