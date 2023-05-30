# fly-guard
Adguard home instance hosted on fly.io

Create two secrets and one volume before deploying:
- `flyctl secrets set TAILSCALE_AUTHKEY="tskey-<key>"`
- `flyctl secrets set TAILSCALE_DNS="adguard-home.ts.net"`
- `flyctl volume create adguard -r <region> --s <size, minimum 1>`

`star.sh` script generates certificates located under `/var/lib/tailscale/certs/<hostname>.<TAILSCALE_DNS>`.