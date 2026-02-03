/**
 * @title Prometheus HTTP Endpoint for a single switch
 * @description This script exposes a /status endpoint that returns Prometheus metrics.
 */

// Configuration
const metric_prefix = "shelly_";
const url = "metrics";
const monitored_switches = ["switch:0"];
const TYPE_GAUGE = "gauge";
const TYPE_COUNTER = "counter";

// Device info
const info = Shelly.getDeviceInfo();

// Helper function to format labels
function promLabel(label, value) {
  return label + '="' + value + '"';
}

// Default labels for all metrics
const defaultLabels = [
  promLabel("placement", "homelab"),
  promLabel("id", info.id)
];

// Generate a Prometheus metric string
function printPrometheusMetric(name, type, description, value) {
  let labels = defaultLabels.join(",");
  return (
    "# HELP " + metric_prefix + name + " " + description + "\n" +
    "# TYPE " + metric_prefix + name + " " + type + "\n" +
    metric_prefix + name + "{" + labels + "} " + value + "\n"
  );
}

// HTTP handler
function httpServerHandler(request, response) {
  response.body = generateMetricsForSystem();
  for (let i = 0; i < monitored_switches.length; i++) {
    response.body += generateMetricsForSwitch(monitored_switches[i]);
  }
  response.code = 200;
  response.headers = [['Content-Type', 'text/plain; version=0.0.4']];
  response.send();
}

// Generate system metrics
function generateMetricsForSystem() {
  const sys = Shelly.getComponentStatus("sys");
  let metrics = "";
  metrics += printPrometheusMetric("uptime_seconds", TYPE_COUNTER, "Uptime in seconds", sys.uptime) + "\n";
  metrics += printPrometheusMetric("ram_size_bytes", TYPE_GAUGE, "Internal board RAM size in bytes", sys.ram_size) + "\n";
  metrics += printPrometheusMetric("ram_free_bytes", TYPE_GAUGE, "Internal board free RAM size in bytes", sys.ram_free) + "\n";
  return metrics;
}

// Generate switch metrics
function generateMetricsForSwitch(string_id) {
  const sw = Shelly.getComponentStatus(string_id);
  let metrics = "";
  metrics += printPrometheusMetric("switch_power_watts", TYPE_GAUGE, "Instant power consumption in watts", sw.apower) + "\n";
  metrics += printPrometheusMetric("switch_voltage_volts", TYPE_GAUGE, "Instant voltage in volts", sw.voltage) + "\n";
  metrics += printPrometheusMetric("switch_current_amperes", TYPE_GAUGE, "Instant current in amperes", sw.current) + "\n";
  metrics += printPrometheusMetric("switch_temperature_celsius", TYPE_GAUGE, "Temperature of the plug in celsius", sw.temperature.tC) + "\n";
  metrics += printPrometheusMetric("switch_power_total", TYPE_COUNTER, "Accumulated energy consumed in watt-hours", sw.aenergy.total) + "\n";
  metrics += printPrometheusMetric("switch_output", TYPE_GAUGE, "Is switch (1) on or (0) off", sw.output ? 1 : 0) + "\n";
  return metrics;
}

// Register the HTTP endpoint
HTTPServer.registerEndpoint(url, httpServerHandler);