package metrics

import (
	"bufio"
	"bytes"
	"flag"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
	"testing"
	"time"

	ksmFramework "k8s.io/kube-state-metrics/v2/tests/e2e/framework"
)

var framework *ksmFramework.Framework

func TestMain(m *testing.M) {
	ksmHTTPMetricsURL := flag.String(
		"ksm-http-metrics-url",
		"",
		"url to access the kube-state-metrics service",
	)
	ksmTelemetryURL := flag.String(
		"ksm-telemetry-url",
		"",
		"url to access the kube-state-metrics telemetry endpoint",
	)
	flag.Parse()

	var (
		err      error
		exitCode int
	)

	if framework, err = ksmFramework.New(*ksmHTTPMetricsURL, *ksmTelemetryURL); err != nil {
		log.Fatalf("failed to setup framework: %v\n", err)
	}

	exitCode = m.Run()

	os.Exit(exitCode)
}

func TestGatewayMetricsAvailable(t *testing.T) {
	buf := &bytes.Buffer{}

	err := framework.KsmClient.Metrics(buf)
	if err != nil {
		t.Fatalf("failed to get metrics from kube-state-metrics: %v", err)
	}

	// Ideally we could use framework.ParseMetrics here,
	// however it gives an error like this:
	// Failed to get or decode telemetry metrics text format parsing error in line 1231: unknown metric type "info"
	// The underlying parsing library doesn't seem to allow OpenMetrics format
	// and works with just Prometheus format
	// Related issues where I found some info on this:
	// - https://github.com/prometheus/pushgateway/issues/400
	// - https://github.com/prometheus/pushgateway/issues/479
	// - https://discuss.elastic.co/t/using-kube-state-metrics-custom-resource-state-metrics-breaks-metricbeat/341249

	re := regexp.MustCompile(`^(gatewayapi_.*){(.*)}\s+(.*)`)
	scanner := bufio.NewScanner(buf)
	gatewayapiMetrics := map[string][][]string{}
	for scanner.Scan() {
		// fmt.Printf("checking metric text=%s\n", scanner.Text())
		params := re.FindStringSubmatch(scanner.Text())
		// fmt.Printf("params=%v\n", params)
		if len(params) < 4 {
			continue
		}
		if gatewayapiMetrics[params[1]] == nil {
			gatewayapiMetrics[params[1]] = [][]string{}
		}
		fmt.Printf("Adding matched metric params=%v\n", params)
		gatewayapiMetrics[params[1]] = append(gatewayapiMetrics[params[1]], params)
	}
	testGatewayClasses(t, gatewayapiMetrics)
	testGateways(t, gatewayapiMetrics)
	testHTTPRoutes(t, gatewayapiMetrics)
}

func testGatewayClasses(t *testing.T, metrics map[string][][]string) {
	//gatewayapi_gatewayclass_info
	gatewayClassInfo := metrics["gatewayapi_gatewayclass_info"]
	gatewayClass1Info := gatewayClassInfo[0]
	expectEqual(t, gatewayClass1Info[3], "1", "gatewayapi_gatewayclass_info__1 value")
	gatewayClass1InfoLabels := parseLabels(string(gatewayClass1Info[2]))
	expectEqual(t, gatewayClass1InfoLabels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gatewayclass_info__1 customresource_group")
	expectEqual(t, gatewayClass1InfoLabels["customresource_kind"], "GatewayClass", "gatewayapi_gatewayclass_info__1 customresource_kind")
	expectEqual(t, gatewayClass1InfoLabels["customresource_version"], "v1beta1", "gatewayapi_gatewayclass_info__1 customresource_version")
	expectEqual(t, gatewayClass1InfoLabels["name"], "testgatewayclass1", "gatewayapi_gatewayclass_info__1 name")
	expectEqual(t, gatewayClass1InfoLabels["controller_name"], "example.com/gateway-controller", "gatewayapi_gatewayclass_info__1 controller_name")

	//gatewayapi_gatewayclass_status
	gatewayClassStatus := metrics["gatewayapi_gatewayclass_status"]
	gatewayClass1Status1 := gatewayClassStatus[0]
	expectEqual(t, gatewayClass1Status1[3], "1", "gatewayapi_gatewayclass_status__1 value")
	gatewayClass1Status1Labels := parseLabels(string(gatewayClass1Status1[2]))
	expectEqual(t, gatewayClass1Status1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gatewayclass_status__1 customresource_group")
	expectEqual(t, gatewayClass1Status1Labels["customresource_kind"], "GatewayClass", "gatewayapi_gatewayclass_status__1 customresource_kind")
	expectEqual(t, gatewayClass1Status1Labels["customresource_version"], "v1beta1", "gatewayapi_gatewayclass_status__1 customresource_version")
	expectEqual(t, gatewayClass1Status1Labels["name"], "testgatewayclass1", "gatewayapi_gatewayclass_status__1 name")
	expectEqual(t, gatewayClass1Status1Labels["type"], "Accepted", "gatewayapi_gatewayclass_status__1 type")
}

func testGateways(t *testing.T, metrics map[string][][]string) {
	// gatewayapi_gateway_info
	gatewayInfo := metrics["gatewayapi_gateway_info"]
	gateway1Info := gatewayInfo[0]
	expectEqual(t, gateway1Info[3], "1", "gatewayapi_gateway_info__1 value")
	gateway1InfoLabels := parseLabels(string(gateway1Info[2]))
	expectEqual(t, gateway1InfoLabels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_info__1 customresource_group")
	expectEqual(t, gateway1InfoLabels["customresource_kind"], "Gateway", "gatewayapi_gateway_info__1 customresource_kind")
	expectEqual(t, gateway1InfoLabels["customresource_version"], "v1beta1", "gatewayapi_gateway_info__1 customresource_version")
	expectEqual(t, gateway1InfoLabels["name"], "testgateway1", "gatewayapi_gateway_info__1 name")
	expectEqual(t, gateway1InfoLabels["namespace"], "default", "gatewayapi_gateway_info__1 namespace")
	expectEqual(t, gateway1InfoLabels["gatewayclass_name"], "testgatewayclass1", "gatewayapi_gateway_info__1 gatewayclass_name")

	// gatewayapi_gateway_created
	gatewayCreated := metrics["gatewayapi_gateway_created"]
	gateway1Created := gatewayCreated[0]
	expectValidTimestampInPast(t, gateway1Created[3], "gatewayapi_gateway_created__1 value")
	gateway1CreatedLabels := parseLabels(string(gateway1Created[2]))
	expectEqual(t, gateway1CreatedLabels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_created__1 customresource_group")
	expectEqual(t, gateway1CreatedLabels["customresource_kind"], "Gateway", "gatewayapi_gateway_created__1 customresource_kind")
	expectEqual(t, gateway1CreatedLabels["customresource_version"], "v1beta1", "gatewayapi_gateway_created__1 customresource_version")
	expectEqual(t, gateway1CreatedLabels["name"], "testgateway1", "gatewayapi_gateway_created__1 name")
	expectEqual(t, gateway1CreatedLabels["namespace"], "default", "gatewayapi_gateway_created__1 namespace")

	//gatewayapi_gateway_listener_info
	gatewayListenerInfo := metrics["gatewayapi_gateway_listener_info"]
	gateway1ListenerInfo := gatewayListenerInfo[0]
	expectEqual(t, gateway1ListenerInfo[3], "1", "gatewayapi_gateway_listener_info__1 value")
	gateway1ListenerInfoLabels := parseLabels(string(gateway1ListenerInfo[2]))
	expectEqual(t, gateway1ListenerInfoLabels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_listener_info__1 customresource_group")
	expectEqual(t, gateway1ListenerInfoLabels["customresource_kind"], "Gateway", "gatewayapi_gateway_listener_info__1 customresource_kind")
	expectEqual(t, gateway1ListenerInfoLabels["customresource_version"], "v1beta1", "gatewayapi_gateway_listener_info__1 customresource_version")
	expectEqual(t, gateway1ListenerInfoLabels["name"], "testgateway1", "gatewayapi_gateway_listener_info__1 name")
	expectEqual(t, gateway1ListenerInfoLabels["namespace"], "default", "gatewayapi_gateway_listener_info__1 namespace")
	expectEqual(t, gateway1ListenerInfoLabels["listener_name"], "http", "gatewayapi_gateway_listener_info__1 listener name")
	expectEqual(t, gateway1ListenerInfoLabels["port"], "80", "gatewayapi_gateway_listener_info__1 port")
	expectEqual(t, gateway1ListenerInfoLabels["protocol"], "HTTP", "gatewayapi_gateway_listener_info__1 protocol")

	//gatewayapi_gateway_status
	gatewayStatus := metrics["gatewayapi_gateway_status"]
	gateway1Status1 := gatewayStatus[0]
	expectEqual(t, gateway1Status1[3], "1", "gatewayapi_gateway_status__1 value")
	gateway1Status1Labels := parseLabels(string(gateway1Status1[2]))
	expectEqual(t, gateway1Status1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_status__1 customresource_group")
	expectEqual(t, gateway1Status1Labels["customresource_kind"], "Gateway", "gatewayapi_gateway_status__1 customresource_kind")
	expectEqual(t, gateway1Status1Labels["customresource_version"], "v1beta1", "gatewayapi_gateway_status__1 customresource_version")
	expectEqual(t, gateway1Status1Labels["name"], "testgateway1", "gatewayapi_gateway_status__1 name")
	expectEqual(t, gateway1Status1Labels["namespace"], "default", "gatewayapi_gateway_status__1 namespace")
	expectEqual(t, gateway1Status1Labels["type"], "Accepted", "gatewayapi_gateway_status__1 type")
	gateway1Status2 := gatewayStatus[1]
	expectEqual(t, gateway1Status2[3], "1", "gatewayapi_gateway_status__2 value")
	gateway1Status2Labels := parseLabels(string(gateway1Status2[2]))
	expectEqual(t, gateway1Status2Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_status__2 customresource_group")
	expectEqual(t, gateway1Status2Labels["customresource_kind"], "Gateway", "gatewayapi_gateway_status__2 customresource_kind")
	expectEqual(t, gateway1Status2Labels["customresource_version"], "v1beta1", "gatewayapi_gateway_status__2 customresource_version")
	expectEqual(t, gateway1Status2Labels["name"], "testgateway1", "gatewayapi_gateway_status__2 name")
	expectEqual(t, gateway1Status2Labels["namespace"], "default", "gatewayapi_gateway_status__2 namespace")
	expectEqual(t, gateway1Status2Labels["type"], "Programmed", "gatewayapi_gateway_status__2 type")

	//gatewayapi_gateway_status_listener_attached_routes
	gatewayStatusListenerAttachedRoutes := metrics["gatewayapi_gateway_status_listener_attached_routes"]
	gateway1StatusListenerAttachedRoutes1 := gatewayStatusListenerAttachedRoutes[0]
	expectEqual(t, gateway1StatusListenerAttachedRoutes1[3], "2", "gatewayapi_gateway_status_listener_attached_routes__1 value")
	gateway1StatusListenerAttachedRoutes1Labels := parseLabels(string(gateway1StatusListenerAttachedRoutes1[2]))
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_status_listener_attached_routes__1 customresource_group")
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["customresource_kind"], "Gateway", "gatewayapi_gateway_status_listener_attached_routes__1 customresource_kind")
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["customresource_version"], "v1beta1", "gatewayapi_gateway_status_listener_attached_routes__1 customresource_version")
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["name"], "testgateway1", "gatewayapi_gateway_status_listener_attached_routes__1 name")
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["namespace"], "default", "gatewayapi_gateway_status_listener_attached_routes__1 namespace")
	expectEqual(t, gateway1StatusListenerAttachedRoutes1Labels["listener_name"], "http", "gatewayapi_gateway_status_listener_attached_routes__1 listener_name")

	//gatewayapi_gateway_status_address_info
	gatewayStatusAddressInfo := metrics["gatewayapi_gateway_status_address_info"]
	gateway1StatusAddressInfo1 := gatewayStatusAddressInfo[0]
	expectEqual(t, gateway1StatusAddressInfo1[3], "1", "gatewayapi_gateway_status_address_info__1 value")
	gateway1StatusAddressInfo1Labels := parseLabels(string(gateway1StatusAddressInfo1[2]))
	expectEqual(t, gateway1StatusAddressInfo1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_status_address_info__1 customresource_group")
	expectEqual(t, gateway1StatusAddressInfo1Labels["customresource_kind"], "Gateway", "gatewayapi_gateway_status_address_info__1 customresource_kind")
	expectEqual(t, gateway1StatusAddressInfo1Labels["customresource_version"], "v1beta1", "gatewayapi_gateway_status_address_info__1 customresource_version")
	expectEqual(t, gateway1StatusAddressInfo1Labels["name"], "testgateway1", "gatewayapi_gateway_status_address_info__1 name")
	expectEqual(t, gateway1StatusAddressInfo1Labels["namespace"], "default", "gatewayapi_gateway_status_address_info__1 namespace")
	expectEqual(t, gateway1StatusAddressInfo1Labels["type"], "Hostname", "gatewayapi_gateway_status_address_info__1 type")
	expectEqual(t, gateway1StatusAddressInfo1Labels["value"], "localhost", "gatewayapi_gateway_status_address_info__1 value")
	gateway1StatusAddressInfo2 := gatewayStatusAddressInfo[1]
	expectEqual(t, gateway1StatusAddressInfo2[3], "1", "gatewayapi_gateway_status_address_info__2 value")
	gateway1StatusAddressInfo2Labels := parseLabels(string(gateway1StatusAddressInfo2[2]))
	expectEqual(t, gateway1StatusAddressInfo2Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_gateway_status_address_info__2 customresource_group")
	expectEqual(t, gateway1StatusAddressInfo2Labels["customresource_kind"], "Gateway", "gatewayapi_gateway_status_address_info__2 customresource_kind")
	expectEqual(t, gateway1StatusAddressInfo2Labels["customresource_version"], "v1beta1", "gatewayapi_gateway_status_address_info__2 customresource_version")
	expectEqual(t, gateway1StatusAddressInfo2Labels["name"], "testgateway1", "gatewayapi_gateway_status_address_info__2 name")
	expectEqual(t, gateway1StatusAddressInfo2Labels["namespace"], "default", "gatewayapi_gateway_status_address_info__2 namespace")
	expectEqual(t, gateway1StatusAddressInfo2Labels["type"], "IPAddress", "gatewayapi_gateway_status_address_info__2 type")
	expectEqual(t, gateway1StatusAddressInfo2Labels["value"], "127.0.0.1", "gatewayapi_gateway_status_address_info__2 value")
}

func testHTTPRoutes(t *testing.T, metrics map[string][][]string) {
	// gatewayapi_httproute_created
	httprouteCreated := metrics["gatewayapi_httproute_created"]
	httproute1Created := httprouteCreated[0]
	expectValidTimestampInPast(t, httproute1Created[3], "gatewayapi_httproute_created__1 value")
	httproute1CreatedLabels := parseLabels(string(httproute1Created[2]))
	expectEqual(t, httproute1CreatedLabels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_created__1 customresource_group")
	expectEqual(t, httproute1CreatedLabels["customresource_kind"], "HTTPRoute", "gatewayapi_httproute_created__1 customresource_kind")
	expectEqual(t, httproute1CreatedLabels["customresource_version"], "v1beta1", "gatewayapi_httproute_created__1 customresource_version")
	expectEqual(t, httproute1CreatedLabels["name"], "testroute1", "gatewayapi_httproute_created__1 name")
	expectEqual(t, httproute1CreatedLabels["namespace"], "default", "gatewayapi_httproute_created__1 namespace")

	//gatewayapi_httproute_hostname_info
	httprouteHostnameInfo := metrics["gatewayapi_httproute_hostname_info"]
	httproute1HostnameInfo1 := httprouteHostnameInfo[0]
	expectEqual(t, httproute1HostnameInfo1[3], "1", "gatewayapi_httproute_hostname_info__1 value")
	httproute1HostnameInfo1Labels := parseLabels(string(httproute1HostnameInfo1[2]))
	expectEqual(t, httproute1HostnameInfo1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_hostname_info__1 customresource_group")
	expectEqual(t, httproute1HostnameInfo1Labels["customresource_kind"], "HTTPRoute", "gatewayapi_httproute_hostname_info__1 customresource_kind")
	expectEqual(t, httproute1HostnameInfo1Labels["customresource_version"], "v1beta1", "gatewayapi_httproute_hostname_info__1 customresource_version")
	expectEqual(t, httproute1HostnameInfo1Labels["name"], "testroute1", "gatewayapi_httproute_hostname_info__1 name")
	expectEqual(t, httproute1HostnameInfo1Labels["namespace"], "default", "gatewayapi_httproute_hostname_info__1 namespace")
	expectEqual(t, httproute1HostnameInfo1Labels["hostname"], "test1.example.com", "gatewayapi_httproute_hostname_info__1 hostname")

	//gatewayapi_httproute_parent_info
	httprouteParentInfo := metrics["gatewayapi_httproute_parent_info"]
	httproute1ParentInfo1 := httprouteParentInfo[0]
	expectEqual(t, httproute1ParentInfo1[3], "1", "gatewayapi_httproute_parent_info__1 value")
	httproute1ParentInfo1Labels := parseLabels(string(httproute1ParentInfo1[2]))
	expectEqual(t, httproute1ParentInfo1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_parent_info__1 customresource_group")
	expectEqual(t, httproute1ParentInfo1Labels["customresource_kind"], "HTTPRoute", "gatewayapi_httproute_parent_info__1 customresource_kind")
	expectEqual(t, httproute1ParentInfo1Labels["customresource_version"], "v1beta1", "gatewayapi_httproute_parent_info__1 customresource_version")
	expectEqual(t, httproute1ParentInfo1Labels["name"], "testroute1", "gatewayapi_httproute_parent_info__1 name")
	expectEqual(t, httproute1ParentInfo1Labels["namespace"], "default", "gatewayapi_httproute_parent_info__1 namespace")
	expectEqual(t, httproute1ParentInfo1Labels["parent_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_parent_info__1 parent_group")
	expectEqual(t, httproute1ParentInfo1Labels["parent_kind"], "Gateway", "gatewayapi_httproute_parent_info__1 parent_kind")
	expectEqual(t, httproute1ParentInfo1Labels["parent_namespace"], "default", "gatewayapi_httproute_parent_info__1 parent_namespace")
	expectEqual(t, httproute1ParentInfo1Labels["parent_name"], "testgateway1", "gatewayapi_httproute_parent_info__1 parent_name")

	//gatewayapi_httproute_status_parent_info
	httprouteParentStatusInfo := metrics["gatewayapi_httproute_status_parent_info"]
	httproute1ParentStatusInfo1 := httprouteParentStatusInfo[0]
	expectEqual(t, httproute1ParentStatusInfo1[3], "1", "gatewayapi_httproute_status_parent_info__1 value")
	httproute1ParentStatusInfo1Labels := parseLabels(string(httproute1ParentStatusInfo1[2]))
	expectEqual(t, httproute1ParentStatusInfo1Labels["customresource_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_status_parent_info__1 customresource_group")
	expectEqual(t, httproute1ParentStatusInfo1Labels["customresource_kind"], "HTTPRoute", "gatewayapi_httproute_status_parent_info__1 customresource_kind")
	expectEqual(t, httproute1ParentStatusInfo1Labels["customresource_version"], "v1beta1", "gatewayapi_httproute_status_parent_info__1 customresource_version")
	expectEqual(t, httproute1ParentStatusInfo1Labels["name"], "testroute1", "gatewayapi_httproute_status_parent_info__1 name")
	expectEqual(t, httproute1ParentStatusInfo1Labels["namespace"], "default", "gatewayapi_httproute_status_parent_info__1 namespace")
	expectEqual(t, httproute1ParentStatusInfo1Labels["parent_group"], "gateway.networking.k8s.io", "gatewayapi_httproute_status_parent_info__1 parent_group")
	expectEqual(t, httproute1ParentStatusInfo1Labels["parent_kind"], "Gateway", "gatewayapi_httproute_status_parent_info__1 parent_kind")
	expectEqual(t, httproute1ParentStatusInfo1Labels["parent_namespace"], "default", "gatewayapi_httproute_status_parent_info__1 parent_namespace")
	expectEqual(t, httproute1ParentStatusInfo1Labels["parent_name"], "testgateway1", "gatewayapi_httproute_status_parent_info__1 parent_name")
}

func parseLabels(labelsRaw string) map[string]string {
	// simple label parsing assuming no special chars/escaping
	// fmt.Printf("labelsRaw=%s\n", labelsRaw)
	labels := map[string]string{}
	labelParts := strings.Split(labelsRaw, ",")
	// fmt.Printf("labelParts=%v\n", labelParts)
	for _, labelPart := range labelParts {
		labelNameVal := strings.Split(labelPart, "=")
		// fmt.Printf("labelNameVal=%v\n", labelNameVal)
		labels[labelNameVal[0]] = labelNameVal[1][1 : len(labelNameVal[1])-1]
	}
	return labels
}

func expectEqual(t *testing.T, actual string, expected string, msg string) {
	if actual != expected {
		t.Fatalf("(%s) Expected %s to equal %s", msg, actual, expected)
	}
}

func expectValidTimestampInPast(t *testing.T, timestamp string, msg string) {
	flt, err := strconv.ParseFloat(timestamp, 64)
	if err != nil {
		t.Fatalf("(%s) Failed parsing timestamp %s", msg, timestamp)
	}
	if flt < 1 || flt > float64(time.Now().Unix()) {
		t.Fatalf("(%s) Expected a valid timestamp in the past, but got value of %s", msg, timestamp)
	}
}
