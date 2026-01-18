# Azure Monitoring Strategy: 6-Layer Framework
**Source:** Abhishek Veeramalla (Azure Zero to Hero)
**Updated:** January 2026
**Focus:** Building a resilient, end-to-end observability stack for Azure Kubernetes Service (AKS) and Cloud-Native Apps.

---

## 🏗️ The 6 Levels of Monitoring

### Level 1: Network Traffic & Infrastructure
* **Focus:** Monitoring the "path to the app" (Firewalls, WAF, NSGs, VPNs).
* **Primary Tool:** **Azure Network Watcher**.
* **Modern Update:** Use **eBPF-based metrics** within AKS for deep packet visibility without sidecar overhead.
* **Key Action:** Monitor **IP Flow Verfication** and **NSG Flow Logs** to detect blocked legitimate traffic.

### Level 2: Infrastructure Nodes (VMSS)
* **Focus:** Health of the Virtual Machine Scale Sets (VMSS) powering your cluster.
* **Primary Tool:** **Managed Prometheus** + **Azure Managed Grafana**.
* **Metrics:** CPU Saturation, Memory Pressure, and Disk I/O.
* **Modern Update:** Shift from "Alert on 80% CPU" to "Alert on Node Not Ready" status to account for auto-scaling.

### Level 3: AKS Control Plane (Managed)
* **Focus:** Ensuring the Azure-managed components (API Server, etcd, Scheduler) are responsive.
* **Primary Tool:** **Azure Monitor (Container Insights)**.
* **Key Action:** Enable **Diagnostic Settings** to send API Server audit logs to a Log Analytics Workspace to debug 429 (Too Many Requests) errors.

### Level 4: Workloads & Pods (Data Plane)
* **Focus:** The health of individual containers, deployments, and replica sets.
* **Primary Tool:** **Prometheus** (using Kube-State-Metrics).
* **Modern Update:** Implement **Vertical Pod Autoscaler (VPA)** in "Recommender" mode to use monitoring data to right-size container requests automatically.

### Level 5: Application Performance Monitoring (APM)
* **Focus:** Code-level traces, dependency mapping, and response times.
* **Primary Tool:** **Application Insights**.
* **Key Action:** Focus on the **Four Golden Signals**:
    1. **Latency:** Time it takes to service a request.
    2. **Traffic:** Demand placed on the system.
    3. **Errors:** The rate of requests that fail.
    4. **Saturation:** How "full" your service is.

### Level 6: Supporting Azure Services
* **Focus:** PaaS services like Azure SQL, Blob Storage, and Key Vault.
* **Primary Tool:** **Azure Monitor Metrics**.
* **Modern Update:** Use **Azure Resource Graph** to create cross-resource dashboards that show how a storage outage affects an application's health.

---

## 🚀 2026 Optimization Checklist

- [ ] **AI-Ops Integration:** Utilize **Azure Copilot for Operations** to summarize Log Analytics spikes into plain-English root cause analyses.
- [ ] **FinOps Alignment:** Link Azure Monitor alerts to **Azure Cost Management** to detect "Cost Anomalies" caused by resource leaks or infinite loops.
- [ ] **Chaos Testing:** Use **Azure Chaos Studio** to simulate a Level 1 (Network) failure and verify if the Level 5 (APM) alerts trigger within the SLA.
- [ ] **Standardization:** Ensure all logs are in **OpenTelemetry (OTel)** format to avoid vendor lock-in and ensure compatibility with Application Insights.
