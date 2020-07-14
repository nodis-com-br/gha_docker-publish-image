FROM docker.io/docker

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]