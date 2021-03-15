FROM rust:1.50.0-alpine3.12 as builder

WORKDIR /usr/src

RUN rustup target add x86_64-unknown-linux-musl

RUN apk update
RUN apk add yarn git musl-dev --no-cache

RUN git clone https://github.com/radicle-dev/radicle-bins.git
WORKDIR /usr/src/radicle-bins/seed/ui
RUN yarn && yarn build


WORKDIR /usr/src/radicle-bins

RUN cargo build --release


FROM alpine:3.13.2

ARG peer_listen="0.0.0.0:12345"
ENV peer_listen=${peer_listen}

ARG http_listen="0.0.0.0:80"
ENV http_listen=${http_listen}

ARG name="seedling"
ENV name=${name}

ENV USER=radicle
ENV UID=10001

RUN adduser --disabled-password --gecos "" --home "/home/${USER}" --shell "/sbin/nologin" --uid "${UID}" "${USER}"

COPY --from=builder /usr/src/radicle-bins/target/release/radicle-seed-node /usr/bin/radicle-seed-node
COPY --from=builder /usr/src/radicle-bins/target/release/radicle-keyutil /usr/bin/radicle-keyutil
COPY --from=builder /usr/src/radicle-bins/seed/ui/public /var/www
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER ${USER}:${USER}

EXPOSE 12345 80

ENTRYPOINT [ "/entrypoint.sh" ]