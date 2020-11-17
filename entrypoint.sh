#!/usr/bin/env sh
set -e

#cat ${GITHUB_ENV}
#echo ${GITHUB_ENV}
source /github/file_commands/set_env*

echo "##################################################################"

env | sort

DOCKER_BUILD_ARGUMENTS="--build-arg PIP_INDEX_URL=https://${NODIS_PYPI_USER}:${NODIS_PYPI_PASSWORD}@${NODIS_PYPI_HOST}/simple"

[[ -z ${DOCKER_HUB_USER} ]] || echo ${DOCKER_HUB_PASSWORD} | docker login docker.io -u ${DOCKER_HUB_USER} --password-stdin
[[ -z ${NODIS_REGISTRY_USER} ]] || echo ${NODIS_REGISTRY_PASSWORD} | docker login ${NODIS_REGISTRY_HOST} -u ${NODIS_REGISTRY_USER} --password-stdin

if [[ ${GITHUB_REF} == "ref/head/master" && ${DEPLOY_RC_TO_PROD:-""} == "true" ]]; then

    docker pull ${DOCKER_IMAGE_NAME}:${NODIS_PROJECT_VERSION}
    docker tag ${DOCKER_IMAGE_NAME}:${NODIS_PROJECT_VERSION} ${DOCKER_IMAGE_NAME}:${NODIS_DEPLOY_ENV}
    docker push ${DOCKER_IMAGE_NAME}:${NODIS_DEPLOY_ENV}

else

    docker build . -t ${DOCKER_IMAGE_NAME} ${DOCKER_BUILD_ARGUMENTS}
    for TAG in ${DOCKER_IMAGE_TAGS}; do
        docker tag ${DOCKER_IMAGE_NAME} ${DOCKER_IMAGE_NAME}:${TAG}
        docker push ${DOCKER_IMAGE_NAME}:${TAG}
    done

fi