ARG NONROOT_USER=ubuntu
ARG NONROOT_GROUP=ubuntu
ARG NONROOT_UID=1000
ARG NONROOT_GID=1000

# 25.6.1
ARG NODEJS_VERSION=latest
# 3.14.3
ARG PYTHON_VERSION=latest

FROM ubuntu:26.04

RUN \
  --mount=source=scripts.d/000-base-dependencies.sh,target=/scripts.d/000-base-dependencies.sh,ro \
  --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  mv /etc/apt/apt.conf.d/docker-clean /tmp/docker-clean && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
  /scripts.d/000-base-dependencies.sh && \
  mv /tmp/docker-clean /etc/apt/apt.conf.d/docker-clean && rm -f /etc/apt/apt.conf.d/keep-cache
ARG NONROOT_USER
ARG NONROOT_GROUP
ARG NONROOT_UID
ARG NONROOT_GID
RUN \
  --mount=source=scripts.d/001-create-user.sh,target=/scripts.d/001-create-user.sh,ro \
  /scripts.d/001-create-user.sh

USER ${NONROOT_USER}
WORKDIR /home/${NONROOT_USER}

ARG NODEJS_VERSION
RUN \
  --mount=source=scripts.d/050-pnpm.sh,target=/scripts.d/050-pnpm.sh,ro \
  /scripts.d/050-pnpm.sh
ARG PYTHON_VERSION
RUN \
  --mount=source=scripts.d/051-uv.sh,target=/scripts.d/051-uv.sh,ro \
  /scripts.d/051-uv.sh
RUN \
  --mount=source=scripts.d/052-bun.sh,target=/scripts.d/052-bun.sh,ro \
  /scripts.d/052-bun.sh

USER ${NONROOT_USER}
WORKDIR /home/${NONROOT_USER}
