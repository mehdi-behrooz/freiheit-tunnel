# syntax=docker/dockerfile:1

FROM gogost/gost

RUN apk update
RUN apk add gettext         # for: envsubst

# TODO: for debug purposes; remove them later
RUN apk add moreutils       # for: sponge
RUN apk add bash            # for: /bin/bash
RUN apk add bind-tools      # for: dig
RUN apk add nmap            # for: nmap
RUN apk add curl            # for: curl
RUN apk add vim             # for: vim
RUN apk add python3         # for: python

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

# TODO: add health check