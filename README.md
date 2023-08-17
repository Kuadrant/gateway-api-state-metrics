# Gateway API State Metrics

[Kube State Metrics](https://github.com/kubernetes/kube-state-metrics) `CustomResourceState` configurations for [Gateway API](https://gateway-api.sigs.k8s.io/) resources.

The contents of this repository are intended to be used with kube-state-metrics.
To use the CustomResourceState, see the [configuration information](https://github.com/kubernetes/kube-state-metrics/blob/main/docs/customresourcestate-metrics.md#configuration) for how to
configure an existing or separate kube-state-metrics instance with a custom
resource configuration.

The CustomResourceState is available at [./custom-resource-state.yaml](./custom-resource-state.yaml)

For easier consumption via kustomize, a [./kustomization.yaml](./kustomization.yaml)
is available that generates a ConfigMap named `custom-resource-state` with the
CustomResourceState data in a key called `custom-resource-state.yaml`.

An example of how to use this with kube-promethues in shown in [./kustomization_kube-prometheus-example.yaml](./kustomization_kube-prometheus-example.yaml)
The kustomization config does the following:

- mounts the ConfigMap as a volume in the kube-state-metrics Deployment
- adds the `--custom-resource-state-config-file` arg to the container, referencing the file in the ConfigMap
- patches the `kube-state-metrics` ClusterRole with permissions for `customresourcedefinitions`
and the various Gateway API resources in the `gateway.networking.k8s.io` apiGroup
- changes the kube-state-metrics image to a version that supports CustomResourceState and has various issues fixed.

An example Grafana dashboard is available at [./dashboard.json](./dashboard.json).
You can import it and modify it as needed.
The dashboard is divided into 3 rows, for GatewayClasses, Gateways and HTTPRoutes.

<img src="dashboard_gatewayclass_row.png" alt="dashboard_gatewayclass_row" width="800"/>

<img src="dashboard_gateway_row.png" alt="dashboard_gateway_row" width="800"/>

<img src="dashboard_httproute_row.png" alt="dashboard_httproute_row" width="800"/>


## Metrics

All metrics have GVK labels to allow more specific matching and filtering.
For example:

```
{
  customresource_group="gateway.networking.k8s.io"
  customresource_kind="Gateway",
  customresource_version="v1beta1"
}
```

In addition, all metrics have a `name` and `namespace` label, where applicable:

```
{
  namespace="<NAMESPACE>",
  name="<NAME>"
}
```

All metrics are prefixed with `gatewayapi_`.
For example, `gatewayapi_gateway_status`.

### Gateway metrics

#### gatewayapi_gateway_info

Information about a Gateway, Gauge
```
gatewayapi_gateway_info{namespace="<NAMESPACE>",name="<GATEWAY>",gatewayclass="<GATEWAYCLASS_NAME>"} 1
```

#### gatewayapi_gateway_labels

Kubernetes labels converted to Prometheus labels, Gauge
```
gatewayapi_gateway_labels{namespace="<NAMESPACE>",name="<GATEWAY>",GATEWAY_LABEL_NAME="<GATEWAY_LABEL_VALUE>"} 1
```

#### gatewayapi_gateway_created

Unix creation timestamp in seconds, Gauge
```
gatewayapi_gateway_created{namespace="<NAMESPACE>",name="<GATEWAY>"} 1690879977
```

#### gatewayapi_gateway_deleted

Unix deletion timestamp in seconds, Gauge
```
gatewayapi_gateway_deleted{namespace="<NAMESPACE>",name="<GATEWAY>"} 1690879977
```

#### gatewayapi_gateway_listener_info

Per [Listener](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io%2fv1beta1.Listener) information, Gauge

```
gatewayapi_gateway_listener_info{namespace="<NAMESPACE>",name="<GATEWAY>",listener_name="<LISTENER_NAME>",port="<PORT>",protocol="<PROTOCOL>",hostname="<HOSTNAME>","tls_mode"="<Passthrough|Terminate>"} 1
```

#### gatewayapi_gateway_status

[Status Conditions](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayStatus) of Gateway, Gauge, 1 or 0 (1 means this condition type currently applies to this gateway)

```
gatewayapi_gateway_status{namespace="<NAMESPACE>",name="<GATEWAY>",type="<Accepted|Scheduled|Ready|Other>"} 1
```

#### gatewayapi_gateway_status_listener_attached_routes

Number of [attached routes](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ListenerStatus) for an individual listener, Gauge
```
gatewayapi_gateway_status_listener_attached_routes{namespace="<NAMESPACE>",name="<GATEWAY>",listener_name="<LISTENER_NAME>"} 5
```

#### gatewayapi_gateway_status_address_info

[Address](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayStatusAddress) types and values, Gauge

```
gatewayapi_gateway_status_address_info{namespace="<NAMESPACE>",name="<GATEWAY>",type="<IPAddress|Hostname|DOMAIN_PREFIXED_STRING_IDENTIFIER>",value="<ADDRESS>"} 1
```

### GatewayClass metrics

#### gatewayapi_gatewayclass_info

Information about a Gateway, Gauge
```
gatewayapi_gatewayclass_info{name="<GATEWAYCLASS_NAME>"} 1
```

#### gatewayapi_gatewayclass_labels

Kubernetes labels converted to Prometheus labels, Gauge
```
gatewayapi_gatewayclass_labels{name="<GATEWAYCLASS_NAME>",GATEWAYCLASS_LABEL_NAME="<GATEWAYCLASS_LABEL_VALUE>"} 1
```

#### gatewayapi_gatewayclass_created

Unix creation timestamp in seconds, Gauge
```
gatewayapi_gatewayclass_created{name="<GATEWAYCLASS_NAME>"} 1690879977
```

#### gatewayapi_gatewayclass_deleted

Unix deletion timestamp in seconds, Gauge
```
gatewayapi_gatewayclass_deleted{name="<GATEWAYCLASS_NAME>"} 1690879977
```

#### gatewayapi_gatewayclass_status

[Status Conditions](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayClassStatus) of GatewayClass, Gauge, 1 or 0 (1 means this condition type currently applies to this gateway)

```
gatewayapi_gatewayclass_status{name="<GATEWAYCLASS_NAME>",type="<Accepted>"} 1
```

### HTTPRoute metrics

**NOTE** There is no `_info` label for HTTPRoute as no additional information is available to show outside of what's already in below metrics.

#### gatewayapi_httproute_labels

Kubernetes labels converted to Prometheus labels, Gauge
```
gatewayapi_httproute_labels{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",HTTPROUTE_LABEL_NAME="<HTTPROUTE_LABEL_VALUE>"} 1
```

#### gatewayapi_httproute_created

Unix creation timestamp in seconds, Gauge
```
gatewayapi_httproute_created{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>"} 1690879977
```

#### gatewayapi_httproute_deleted

Unix deletion timestamp in seconds, Gauge
```
gatewayapi_httproute_deleted{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>"} 1690879977
```

#### gatewayapi_httproute_hostname_info

[Hostnames](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.Hostname) to match against the HTTP Host header, Gauge

```
gatewayapi_httproute_hostname_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",hostname="<HOSTNAME>"}
```

#### gatewayapi_httproute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```
gatewayapi_httproute_parent_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

#### gatewayapi_httproute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```
gatewayapi_httproute_status_parent_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

## Contributing

Contributions are welcome in the form of bugs, feature requests & pull requests.
Before submitting a new issue, please use the search function to see if there
is already a similar report or pull request.
Roadmap items will be represented as Issues.
