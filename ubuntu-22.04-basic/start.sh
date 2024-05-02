#!/bin/bash

# Support compose secrets:
#   * ORG_FILE
#   * TOKEN_FILE

if [ -n "${ORG_FILE}" ]; then
    if [ -r "${ORG_FILE}" ]; then
        ORG=$(cat "${ORG_FILE}")
    fi
fi

GH_ORG=${ORG:-unset}

if [ -n "${TOKEN_FILE}" ]; then
    if [ -r "${TOKEN_FILE}" ]; then
        TOKEN=$(cat "${TOKEN_FILE}")
    fi
fi

GH_PAT=${TOKEN:-unset}

if [ "${GH_ORG}" = "unset" ]; then
    echo "ERROR: organization not set"
    exit 1
fi

REG_URI="https://api.github.com/orgs/${GH_ORG}/actions/runners/registration-token"
REG_TOKEN=$(curl -X POST -H "Authorization: token ${GH_PAT}" -H "Accept: application/vnd.github-json" ${REG_URI} | jq .token --raw-output)

cd /home/docker/actions-runner
./config.sh --unattended --url https://github.com/${GH_ORG} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner ..."
    ./config.sh remove --token ${REG_TOKEN}
}



trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM



./run.sh & wait $!
