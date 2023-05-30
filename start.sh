#!/bin/sh

NAME=fly-guard
/app/tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
/app/tailscale up --ssh --authkey=${TAILSCALE_AUTHKEY} --hostname=${NAME}
/app/tailscale cert ${NAME}.${TAILSCALE_DNS}

/opt/adguardhome/AdGuardHome --no-check-update -c /opt/adguardhome/conf/AdGuardHome.yaml -h 0.0.0.0 -w /opt/adguardhome/work