#!/bin/bash

set -e

echo "Creating kind cluster"
kind create cluster

echo "Setting up monitoring stack"
kubectl create -f ./config/gateway-api/crd/standard/
kubectl create -f ./config/examples/enterprise/all.yaml
kubectl replace --subresource=status -f ./config/examples/enterprise/all.yaml
kubectl apply --server-side -f ./config/examples/kube-prometheus/bundle_crd.yaml
kubectl apply -f ./config/examples/kube-prometheus/bundle.yaml

echo "Installing grafana-operator"
helm upgrade -i grafana-operator oci://ghcr.io/grafana-operator/helm-charts/grafana-operator --version v5.4.1

kubectl apply -f - <<EOF
apiVersion: grafana.integreatly.org/v1beta1
kind: Grafana
metadata:
  name: grafana
  labels:
    dashboards: "grafana"
spec:
  config:
    log:
      mode: "console"
    auth:
      disable_login_form: "false"
    security:
      admin_user: admin
      admin_password: admin
---
apiVersion: grafana.integreatly.org/v1beta1
kind: GrafanaDatasource
metadata:
  name: prometheus
spec:
  instanceSelector:
    matchLabels:
      dashboards: "grafana"
  datasource:
    name: prometheus
    type: prometheus
    access: proxy
    url: http://prometheus-k8s.monitoring:9090
    isDefault: true
    editable: false
EOF

until kubectl get deployment/grafana-deployment
do
    echo waiting for deployment/grafana-deployment to exist
    sleep 5
done

echo waiting for deployment/grafana-deployment to be Available
kubectl wait --timeout=5m deployment/grafana-deployment --for=condition=Available
kubectl port-forward service/grafana-service 3000:3000 > /dev/null &

echo -e "\n\nOpen Grafana at http://localhost:3000 to see dashboards. (user/pass admin/admin)\n\n"

make apply-latest-dashboard-crs

echo -e "\nStarting to watch for jsonnet changes in src/dasbhoards\n\n"

fswatch -r src/dashboards/ | xargs -n 1 -I {} make apply-latest-dashboard-crs
