#!/bin/bash
set -ex

export HELM_PLUGIN_PUSH_VERSION=v0.8.1
helm plugin install https://github.com/chartmuseum/helm-push.git --version ${HELM_PLUGIN_PUSH_VERSION}

export INPUT_CHARTS_FOLDER=${INPUT_CHARTS_FOLDER:-.}

if [ -z "${INPUT_CHART_NAME}" ]; then
  echo "chart_name is not set"
  exit 1
fi

if [ -z "${INPUT_REPOSITORY_URL}" ]; then
  echo "repository_url is not set"
  exit 1
fi

if [ -z "${INPUT_REPOSITORY_USER}" ]; then
  echo "repository_user is not set"
  exit 1
fi

if [ -z "${INPUT_REPOSITORY_PASSWORD}" ]; then
  echo "repository_password is not set"
  exit 1
fi

if [ -z "${INPUT_CHART_VERSION}" ]; then
  echo "chart_version is not set"
  exit 1
fi

if [ -z "${INPUT_APP_VERSION}" ]; then
  echo "app_version is not set"
  exit 1
fi

cd "${INPUT_CHARTS_FOLDER}/${INPUT_CHART_NAME}"

helm inspect chart .
helm package --app-version "${INPUT_APP_VERSION}" --version "${INPUT_CHART_VERSION}" .
helm push "${INPUT_CHART_NAME}"-* "${INPUT_REPOSITORY_URL}" --username "${INPUT_REPOSITORY_USER}" --password "${INPUT_REPOSITORY_PASSWORD}" --force
