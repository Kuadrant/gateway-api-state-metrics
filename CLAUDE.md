# CLAUDE.md

Kube State Metrics CustomResourceState configs for Gateway API resources.

## Key docs

- [README.md](README.md) - project overview, dashboards, contributing
- [METRICS.md](METRICS.md) - full metrics reference (all prefixed `gatewayapi_`)
- [RELEASE.md](RELEASE.md) - release process
- [config/examples/kube-prometheus/bundle-README.md](config/examples/kube-prometheus/bundle-README.md) - bundle regeneration steps

## Build & test

```shell
make test                  # e2e tests (./tests/e2e.sh)
make generate-bundles      # regenerate bundle yamls
make compare-bundles       # generate + assert no diff (CI uses this)
make generate-dashboards   # rebuild Grafana dashboard JSON from jsonnet
```

## Release process

1. Branch from `main` (e.g. `release-0.8.1`)
2. Regenerate bundles (`make generate-bundles`) and commit
3. PR, merge, then create a GitHub release from `main` with tag (e.g. `0.8.1`)

## Conventions

- Commits require DCO sign-off (`git commit -s`)
- Go module tracks `k8s.io/kube-state-metrics/v2`
- Dashboards are jsonnet in `src/dashboards/`, compiled to `config/examples/dashboards/`
