# Releasing

- Checkout a new branch from `main`, e.g. `release-0.2.0`
- Update the bundle yaml files as per instructions in [./config/examples/kube-prometheus/bundle-README.md](./config/examples/kube-prometheus/bundle-README.md)
- Create a new PR with the change
- After merging, create a release in Github at https://github.com/Kuadrant/gateway-api-state-metrics/releases/new from `main`, specifying a release tag e.g. `0.2.0`
  - Title can be the release nubmer. Description can include any important changes