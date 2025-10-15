FROM ghcr.io/actions/actions-runner:latest

# Minimal dependencies for Kaniko + Git
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl git tar gzip \
    && rm -rf /var/lib/apt/lists/*

# Kaniko executor
ARG KANIKO_VER=latest
ADD https://github.com/GoogleContainerTools/kaniko/releases/${KANIKO_VER}/download/executor-linux-amd64 /usr/local/bin/executor
RUN chmod +x /usr/local/bin/executor

# Non-root runtime aligns with ARC defaults
USER 1000
