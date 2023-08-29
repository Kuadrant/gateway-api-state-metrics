# Releasing

- Checkout `main`
- Update the ref in examples/kube-prometheus/kustomization.yaml to the new release number.
  - e.g. `github.com/kuadrant/gateway-api-state-metrics?ref=0.1.0` for release `0.1.0`
- Add and commit the change
- Tag the commit with the release number e.g. `git tag 0.1.0`
- Push the commit and tag with `git push origin main && git push origin 0.1.0`
- Create a release in Github at https://github.com/Kuadrant/gateway-api-state-metrics/releases/new, using the tag
  - Title can be the release nubmer. Description can include any important changes