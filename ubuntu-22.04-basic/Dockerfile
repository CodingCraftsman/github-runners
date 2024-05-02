FROM ubuntu:22.04
LABEL org.opencontainers.image.source=https://github.com/CodingCraftsman/github-runners
LABEL org.opencontainers.image.description="Basic runner based on Ubuntu 22.04"
LABEL org.opencontainers.image.licenses=MIT

# Customizations
ARG GH_RUNNER_ARCH="x64"
ARG GH_RUNNER_VERSION="2.316.0"

# Prevent installdependencies.sh from prompting the user and blocking the image creation.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -qy \
    && apt upgrade -qy \
    && useradd -m docker

RUN apt install -qy --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    jq \
    less \
    libffi-dev \
    libssl-dev \
    nano \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv

RUN cd /home/docker \
    && mkdir -v actions-runner \
    && cd actions-runner/ \
    && curl -O -L https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${GH_RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-${GH_RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz

RUN chown -R docker /home/docker \
    && /home/docker/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

# config and run scripts for actions cannot be run as root; use a non-privileged user account.
USER docker

ENTRYPOINT ["./start.sh"]
