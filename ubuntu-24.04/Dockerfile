FROM ubuntu:24.04
LABEL org.opencontainers.image.source=https://github.com/CodingCraftsman/github-runners
LABEL org.opencontainers.image.description="Generic runner based on Ubuntu 24.04"
LABEL org.opencontainers.image.licenses=MIT

# Customizations
ARG GH_RUNNER_ARCH="x64"
ARG GH_RUNNER_VERSION="2.316.0"
ARG HOST_DOCKER_GROUP_ID

# Prevent installdependencies.sh from prompting the user and blocking the image creation.
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update -qy \
    && apt upgrade -qy \
    && useradd -m runner

RUN apt install -qy --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    jq \
    less \
    libffi-dev \
    libssl-dev \
    nano \
    python3 \
    python3-dev \
    python3-pip \
    python3-venv \
    unzip \
    zip

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

COPY docker.list /etc/apt/sources.list.d/docker.list

RUN chmod a+r /etc/apt/keyrings/docker.gpg \
    && apt update -qy \
    && apt install -qy docker-ce \
    && addgroup --gid ${HOST_DOCKER_GROUP_ID} hostdocker \
    && usermod -a -G hostdocker runner

RUN cd /home/runner \
    && mkdir -v actions-runner \
    && cd actions-runner/ \
    && curl -O -L https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${GH_RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-${GH_RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz

RUN chown -R runner /home/runner \
    && /home/runner/actions-runner/bin/installdependencies.sh

COPY start.sh start.sh
RUN chmod +x start.sh

# config and run scripts for actions cannot be run as root; use a non-privileged user account.
USER runner

ENTRYPOINT ["./start.sh"]
