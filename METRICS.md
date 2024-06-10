# Metrics

## Gateway metrics

### gatewayapi_gateway_info

Information about a Gateway, Gauge

```promql
gatewayapi_gateway_info{namespace="<NAMESPACE>",name="<GATEWAY>",gatewayclass="<GATEWAYCLASS_NAME>"} 1
```

### gatewayapi_gateway_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_gateway_labels{namespace="<NAMESPACE>",name="<GATEWAY>",GATEWAY_LABEL_NAME="<GATEWAY_LABEL_VALUE>"} 1
```

### gatewayapi_gateway_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_gateway_created{namespace="<NAMESPACE>",name="<GATEWAY>"} 1690879977
```

### gatewayapi_gateway_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_gateway_deleted{namespace="<NAMESPACE>",name="<GATEWAY>"} 1690879977
```

### gatewayapi_gateway_listener_info

Per [Listener](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io%2fv1beta1.Listener) information, Gauge

```promql
gatewayapi_gateway_listener_info{namespace="<NAMESPACE>",name="<GATEWAY>",listener_name="<LISTENER_NAME>",port="<PORT>",protocol="<PROTOCOL>",hostname="<HOSTNAME>","tls_mode"="<Passthrough|Terminate>","allowed_routes_namespaces_from"="<Same|All|Selector>"} 1
```

### gatewayapi_gateway_status

[Status Conditions](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayStatus) of Gateway, Gauge, 1 or 0 (1 means this condition type currently applies to this gateway)

```promql
gatewayapi_gateway_status{namespace="<NAMESPACE>",name="<GATEWAY>",type="<Accepted|Scheduled|Ready|Other>"} 1
```

### gatewayapi_gateway_status_listener_attached_routes

Number of [attached routes](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ListenerStatus) for an individual listener, Gauge

```promql
gatewayapi_gateway_status_listener_attached_routes{namespace="<NAMESPACE>",name="<GATEWAY>",listener_name="<LISTENER_NAME>"} 5
```

### gatewayapi_gateway_status_address_info

[Address](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayStatusAddress) types and values, Gauge

```promql
gatewayapi_gateway_status_address_info{namespace="<NAMESPACE>",name="<GATEWAY>",type="<IPAddress|Hostname|DOMAIN_PREFIXED_STRING_IDENTIFIER>",value="<ADDRESS>"} 1
```

## GatewayClass metrics

### gatewayapi_gatewayclass_info

Information about a Gateway, Gauge

```promql
gatewayapi_gatewayclass_info{name="<GATEWAYCLASS_NAME>"} 1
```

### gatewayapi_gatewayclass_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_gatewayclass_labels{name="<GATEWAYCLASS_NAME>",GATEWAYCLASS_LABEL_NAME="<GATEWAYCLASS_LABEL_VALUE>"} 1
```

### gatewayapi_gatewayclass_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_gatewayclass_created{name="<GATEWAYCLASS_NAME>"} 1690879977
```

### gatewayapi_gatewayclass_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_gatewayclass_deleted{name="<GATEWAYCLASS_NAME>"} 1690879977
```

### gatewayapi_gatewayclass_status

[Status Conditions](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.GatewayClassStatus) of GatewayClass, Gauge, 1 or 0 (1 means this condition type currently applies to this gateway)

```promql
gatewayapi_gatewayclass_status{name="<GATEWAYCLASS_NAME>",type="<Accepted>"} 1
```

### gatewayapi_gatewayclass_status_supported_features

```promql
gatewayapi_gatewayclass_status_supported_features{name="<GATEWAYCLASS_NAME>",features="<FeatureX>"}
```

## HTTPRoute metrics

**NOTE** There is no `_info` label for HTTPRoute as no additional information is available to show outside of what's already in below metrics.

### gatewayapi_httproute_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_httproute_labels{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",HTTPROUTE_LABEL_NAME="<HTTPROUTE_LABEL_VALUE>"} 1
```

### gatewayapi_httproute_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_httproute_created{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_httproute_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_httproute_deleted{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_httproute_hostname_info

[Hostnames](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.Hostname) to match against the HTTP Host header, Gauge

```promql
gatewayapi_httproute_hostname_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",hostname="<HOSTNAME>"}
```

### gatewayapi_httproute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```promql
gatewayapi_httproute_parent_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

### gatewayapi_httproute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```promql
gatewayapi_httproute_status_parent_info{name="<HTTPROUTE_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

## GRPCRoute metrics

### gatewayapi_grpcroute_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_grpcroute_labels{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>",grpcroute_LABEL_NAME="<grpcroute_LABEL_VALUE>"} 1
```

### gatewayapi_grpcroute_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_grpcroute_created{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_grpcroute_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_grpcroute_deleted{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_grpcroute_hostname_info

[Hostnames](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.Hostname) to match against the HTTP Host header, Gauge

```promql
gatewayapi_grpcroute_hostname_info{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>",hostname="<HOSTNAME>"}
```

### gatewayapi_grpcroute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```promql
gatewayapi_grpcroute_parent_info{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

### gatewayapi_grpcroute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```promql
gatewayapi_grpcroute_status_parent_info{name="<GRPCRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

## TCPRoute metrics

### gatewayapi_tcproute_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_tcproute_labels{name="<TCPRoute_NAME>",namespace="<NAMESPACE>",tcproute_LABEL_NAME="<tcproute_LABEL_VALUE>"} 1
```

### gatewayapi_tcproute_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_tcproute_created{name="<TCPRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_tcproute_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_tcproute_deleted{name="<TCPRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_tcproute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```promql
gatewayapi_tcproute_parent_info{name="<TCPRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

### gatewayapi_tcproute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```promql
gatewayapi_tcproute_status_parent_info{name="<TCPRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

## TLSRoute metrics

### gatewayapi_tlsroute_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_tlsroute_labels{name="<TLSRoute_NAME>",namespace="<NAMESPACE>",tlsroute_LABEL_NAME="<tlsroute_LABEL_VALUE>"} 1
```

### gatewayapi_tlsroute_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_tlsroute_created{name="<TLSRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_tlsroute_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_tlsroute_deleted{name="<TLSRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_tlsroute_hostname_info

[Hostnames](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.Hostname) to match against the HTTP Host header, Gauge

```promql
gatewayapi_tlsroute_hostname_info{name="<TLSRoute_NAME>",namespace="<NAMESPACE>",hostname="<HOSTNAME>"}
```

### gatewayapi_tlsroute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```promql
gatewayapi_tlsroute_parent_info{name="<TLSRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

### gatewayapi_tlsroute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```promql
gatewayapi_tlsroute_status_parent_info{name="<TLSRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

## UDPRoute metrics

### gatewayapi_udproute_labels

Kubernetes labels converted to Prometheus labels, Gauge

```promql
gatewayapi_udproute_labels{name="<UDPRoute_NAME>",namespace="<NAMESPACE>",udproute_LABEL_NAME="<udproute_LABEL_VALUE>"} 1
```

### gatewayapi_udproute_created

Unix creation timestamp in seconds, Gauge

```promql
gatewayapi_udproute_created{name="<UDPRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_udproute_deleted

Unix deletion timestamp in seconds, Gauge

```promql
gatewayapi_udproute_deleted{name="<UDPRoute_NAME>",namespace="<NAMESPACE>"} 1690879977
```

### gatewayapi_udproute_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route wants to be attached to, Gauge

```promql
gatewayapi_udproute_parent_info{name="<UDPRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```

### gatewayapi_udproute_status_parent_info

[Parent References](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference) that the route *is* attached to based on the status, Gauge

```promql
gatewayapi_udproute_status_parent_info{name="<UDPRoute_NAME>",namespace="<NAMESPACE>",parent_group="<PARENT_GROUP>",parent_kind="<PARENT_KIND>",parent_name="<PARENT_NAME>",parent_namespace="<PARENT_NAMESPACE>"}
```
