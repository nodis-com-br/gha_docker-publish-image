#!/usr/bin/env sh

export PIP_INDEX_URL="https://${NODIS_PYPI_USER}:${NODIS_PYPI_PASSWORD}@${NODIS_PYPI_HOST}/simple"
export PIP_EXTRA_INDEX_URL="https://pypi.org/simple/"

echo ${NODIS_REGISTRY_PASSWORD} | docker login ${NODIS_REGISTRY_HOST} -u ${NODIS_REGISTRY_USER} --password-stdin

if [[ ${GITHUB_REF} == "ref/head/master" && ${NODIS_SERVICE_TYPE} == "deployment" ]]; then

    docker pull ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION}
    docker tag ${NODIS_IMAGE_NAME}:${NODIS_BASE_VERSION} ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}
    docker push ${NODIS_IMAGE_NAME}:${NODIS_DEPLOY_ENV}

else

    docker build . -t ${NODIS_IMAGE_NAME} --build-arg PIP_INDEX_URL --build-arg PIP_EXTRA_INDEX_URL

    for TAG in ${NODIS_IMAGE_TAGS}; do

        docker tag ${NODIS_IMAGE_NAME} ${NODIS_IMAGE_NAME}:${TAG}
        docker push ${NODIS_IMAGE_NAME}:${TAG}

    done

fi