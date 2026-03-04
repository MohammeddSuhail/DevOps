## Kubernetes High-Level Overview

**Pod:**
- The smallest deployable unit in Kubernetes. Runs one or more containers.
- Created using a manifest file.

**Deployment:**
- Manages Pods for you - handles auto-healing, scaling, and rolling updates.
- Ensures the desired number of Pods are always running.

**Service:**
- Provides a stable network endpoint for accessing Pods.
- Solves the problem of changing Pod IPs (Pods are ephemeral).
- Enables Service Discovery, Load Balancing, and Application Exposure (internal or external).

**Resource Relationship:**
```
Service
  ↓
Deployment
  ↓
ReplicaSet
  ↓
Pods
```

### How a Request Flows in Kubernetes

1. A client sends a request to the **Service** (using its stable IP or DNS name).
2. The **Service** uses its selector to find matching **Pods** (usually managed by a Deployment).
3. The Service load-balances the request across the healthy Pods.
4. The Pods themselves are created and managed by a **ReplicaSet**, which is controlled by a **Deployment**.
5. If Pods are replaced or scaled, the Service automatically discovers new Pods with matching labels—no manual changes needed.

In summary: Service → (load balances to) Pods ← managed by ReplicaSet ← managed by Deployment.
