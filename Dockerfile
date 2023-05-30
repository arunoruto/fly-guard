ARG TSVERSION=1.42.0
ARG TSFILE=tailscale_${TSVERSION}_amd64.tgz

FROM alpine:latest as builder
WORKDIR /app
COPY . ./
# This is where one could build the application code as well.

FROM alpine:latest as tailscale
ARG TSFILE
WORKDIR /app
# ENV TSFILE=tailscale_1.42.0_amd64.tgz
RUN wget https://pkgs.tailscale.com/stable/${TSFILE} && \
  tar xzf ${TSFILE} --strip-components=1


# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
# https://github.com/AdguardTeam/AdGuardHome/blob/master/docker/Dockerfile
FROM adguard/adguardhome:latest
RUN apk update && apk add tini ca-certificates iptables ip6tables && rm -rf /var/cache/apk/*

# Copy binary to production image
COPY --from=builder /app/start.sh /app/start.sh
COPY --from=tailscale /app/tailscaled /app/tailscaled
COPY --from=tailscale /app/tailscale /app/tailscale
RUN mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale

HEALTHCHECK \
	--interval=30s \
	--timeout=10s \
	--retries=3 \
	CMD [ "/opt/adguardhome/scripts/healthcheck.sh" ]

# Run on container startup.
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD ["/bin/sh", "/app/start.sh"]