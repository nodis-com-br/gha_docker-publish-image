#!/usr/bin/env sh

export PIP_INDEX_URL="https://${NODIS_PYPI_USER}:${NODIS_PYPI_PASSWORD}@${NODIS_PYPI_HOST}/simple"
export PIP_EXTRA_INDEX_URL="https://pypi.org/simple/"

echo ${NODIS_REGISTRY_PASSWORD} | docker login ${NODIS_REGISTRY_HOST} -u ${NODIS_REGISTRY_USER} --password-stdin

if [[ ${GITHUB_REF} == "ref/head/master" && ${NODIS_SERVICE_TYPE} != "cronjob" ]]; then

    docker pull ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION}
    docker tag ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION} ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}
    docker push ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}

else

    docker build . -t ${NODIS_IMAGE_NAME} --build-arg PIP_INDEX_URL --build-arg PIP_EXTRA_INDEX_URL

    docker tag ${NODIS_IMAGE_NAME} ${NODIS_IMAGE_NAME}:${NODIS_FULL_VERSION}
    docker tag ${NODIS_IMAGE_NAME} ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}
    docker tag ${NODIS_IMAGE_NAME} ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION}
    docker tag ${NODIS_IMAGE_NAME} ${NODIS_IMAGE_NAME}:${NODIS_CUSTOM_TAG}

    docker push ${NODIS_IMAGE_NAME}:${NODIS_FULL_VERSION}
    docker push ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}
    docker push ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION}
    docker push ${NODIS_IMAGE_NAME}:${NODIS_CUSTOM_TAG}

fi