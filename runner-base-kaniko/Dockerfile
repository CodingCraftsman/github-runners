# Stage 1: pull the official Kaniko executor
FROM gcr.io/kaniko-project/executor:v1.24.0 AS kaniko

# Stage 2: GitHub Actions runner base
FROM ghcr.io/actions/actions-runner:latest

# Minimal dependencies for Kaniko + Git
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bzip2 \
        ca-certificates \
        curl \
        file \
        gawk \
        git \
        gzip \
        jq \
        lzma \
        make \
        tar \
        unzip \
        wget \
        xz-utils \
        zip \
        zstd \
    \
    && rm -rf /var/lib/apt/lists/*

# Copy Kaniko executor from the official image
# Executor is located at /kaniko/executor inside the Kaniko image
COPY --from=kaniko /kaniko/executor /usr/local/bin/executor
RUN chmod +x /usr/local/bin/executor && /usr/local/bin/executor --help >/dev/null || true

# Non-root runtime aligns with ARC defaults
USER 1001
