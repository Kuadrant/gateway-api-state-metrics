# Example Enterprise

The resources in this directory are meant as an example set of Gateways and various
other Gateway resources (e.g. HTTPRoute) that make up an example enterprise
company.

The enterprise builds and sells support & consultancy services for a popular
software stack. It consists of the following departments and people:

- Internal engineering team (1000 staff) that maintains
  - the core stack
  - platforms/architectures build system
  - UX/UI
  - Docs & Content
- Payments & billing integration system
  - dev team (50)
- HR/Finance team (100)
- Support team (1000 staff worldwide)
- Consultancy team (1500 staff worldwide)
- Sales & branding team (500 worldwide)
  - includes devs for front facing site & materials
- Internal IT team (50)

There are 3 Gateways with various services attached.

1. An external Gateway with various services for customers:

- main website www.example.com
- CDN cdn.example.com
- Terms of Service server tos.example.com
- Analytics system analytics.example.com
- Ticketing (jira) (external & internal use) jira.example.com
- VPN vpn.example.com
- support site support.example.com
- docs/content site (developer portal) docs.example.com
- customer auth auth.example.com
- accounts system (customer portal) accounts.example.com
- payments system payments.example.com

2. An internal Gateway with services primarily for employees and running the company

- LDAP ldap.internal.example.com
- Internal authN auth.internal.example.com
- Various databases mysql.internal.example.com, postgres.internal.example.com, mongodb.internal.example.com
- Subscriptions system subscriptions.internal.example.com
- Mail server (ext/int) mail.internal.example.com
- Messaging (rocket chat) chat.internal.example.com
- Payroll payroll.internal.example.com
- Credential management (vault) vault.internal.example.com
- Consultancy docs/tools (int/vpn) consultancytools.internal.example.com
- Sales & branding docs/images/tools (int/vpn) salestools.internal.example.com
- HR/workforce site hr.internal.example.com
- Intranet/info intranet.internal.example.com
- IT Internal Observability dashboards.internal.example.com
- IT Internal Observability metrics.internal.example.com
- IT Internal Observability logs.internal.example.com

3. A 2nd internal Gateway with services required to build and maintain the core product

- Maven repo (nexus) nexus.dev.example.com
- Message bus (kafka - CI, Artifacts repo, Ticketing, Analytics, Subscriptions, Source server) messaging.dev.example.com
- CI (jenkins) ci.dev.example.com
- CI Signing server signing.dev.example.com
- CD Server argo.dev.example.com
- Test Environments (kube) environments.dev.example.com
- Artifacts repo registry.dev.example.com
- Source server (gitlab) git.dev.example.com
- file server files.dev.example.com

## Bringing up an local cluster with these resources

```bash
kind create cluster
kubectl create -f ../../gateway-api/crd/standard/
kubectl create -f ./all.yaml
kubectl replace --subresource=status -f ./all.yaml
kubectl apply --server-side -f ../kube-prometheus/bundle_crd.yaml
kubectl apply -f ../kube-prometheus/bundle.yaml
kubectl -n monitoring wait --timeout=5m deployment/grafana --for=condition=Available
kubectl -n monitoring port-forward service/grafana 3000:3000 > /dev/null &
kubectl -n monitoring rollout status --watch --timeout=5m statefulset/prometheus-k8s
kubectl -n monitoring port-forward service/prometheus-k8s 9090:9090 > /dev/null &
```

Access grafana at http://localhost:3000 and prometheus at http://localhost:9090
