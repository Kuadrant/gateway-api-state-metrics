```bash
kubectl apply -f ./config/kuadrant/crd/
kubectl patch clusterrole kube-state-metrics --type=json -p "$(cat ./config/kuadrant/clusterrole-patch.yaml)"
kubectl apply -f ./config/kuadrant/kuadrant.yaml
kubectl replace --subresource=status -f ./config/kuadrant/kuadrant.yaml
kubectl delete pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics
```


## 1. Apply the Kuadrant Resource Definitions (CRD)

Apply the custom resource definitions (CRDs) required for Kuadrant

```bash
kubectl apply -f ./config/kuadrant/crd/
```

## 2. Patch the ClusterRole

Patching an existing ClusterRole allows you to add specific permissions to it
```bash
kubectl patch clusterrole kube-state-metrics --type=json -p "$(cat ./config/kuadrant/clusterrole-patch.yaml)"
```

## 3. Deploy Kuadrant Components

Deploy Kuadrant components to your cluster
```bash
kubectl apply -f ./config/kuadrant/kuadrant.yaml
```
## 4. Update Kuadrant Resources

Update the Kuadrant resources to reflect the desired status
```bash
kubectl replace --subresource=status -f ./config/kuadrant/kuadrant.yaml
```

## 5. Restart Pods

Restart pods in the "monitoring" namespace matching the specified label selector
```bash
kubectl delete pods -n monitoring -l app.kubernetes.io/name=kube-state-metrics
```