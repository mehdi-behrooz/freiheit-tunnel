# syntax=docker/dockerfile:1
# checkov:skip=CKV_DOCKER_3: at least in server mode needs to be run as root in order to listen to different ports
# checkov:skip=CKV_DOCKER_7: gost has no other stable release yet excpet "latest"

FROM gogost/gost

RUN apk update \
    && apk add bash gettext-envsubst

COPY ./conf /conf
COPY --chmod=755 ./entrypoint.sh /

ENV LOG_LEVEL=info
ENV MODE=server
ENV USERNAME=admin
ENV PASSWORD=

# for server:
ENV LISTEN_ON=8443

# for client:
ENV SERVER_HOST=example.com
ENV SERVER_PORT=8443
ENV MAP=":80>:80;:443>:443"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/gost", "-C", "/etc/gost.yaml"]

HEALTHCHECK --interval=15m \
    --start-period=5m \
    --start-interval=10s \
    CMD [[ $MODE = server ]] && nc -z localhost $LISTEN_ON || [[ $MODE = client ]] && pgrep /bin/gost || exit 1
