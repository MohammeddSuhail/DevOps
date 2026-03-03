# Kubernetes Services: Discovery, Load Balancing & Networking

### **What is a Kubernetes Service?**
A Service is a Kubernetes resource that provides a stable networking endpoint for a set of Pods. Since Pods are **ephemeral** (they die and are recreated with new IP addresses), you cannot rely on their individual IPs for communication.

---

### **Core Problem: The "Why"**
* **Auto-healing & Ephemeral IPs:** When a Pod goes down, the Deployment/ReplicaSet creates a new one. This new Pod has a **different IP address**.
* **Connectivity Issue:** If users or other services try to connect via the specific Pod IP, their connection will fail as soon as that Pod is replaced.
* **The Solution:** A Service acts as a permanent entry point (with a fixed Name/IP) that sits in front of the Pods and routes traffic to them, regardless of how many times the Pods are recreated.

---

### **3 Main Functions of a Service**

#### **1. Load Balancing**
* The Service receives requests and distributes them across all available Pod replicas.
* This ensures that no single Pod is overwhelmed by traffic.
* **Internal Detail:** Under the hood, a component called **Kube-Proxy** handles this traffic forwarding and load balancing logic.

#### **2. Service Discovery (Labels & Selectors)**
* Services do **not** track Pods by their IP addresses.
* Instead, they use **Labels and Selectors** (see section above for details).
* **How it works:** You give Pods one or more labels (e.g., `app: payment`, `env: prod`). The Service is configured with a selector (e.g., `app: payment`). The Service will automatically "discover" and send traffic to any Pod that has matching labels, even if the Pod is brand new.
* This decouples the Service from Pod names or IPs—traffic always flows to the right set of Pods as long as the labels match the selector.

##### Labels & Selectors: Simple Explanation

* **Labels** are key-value tags on Pods (e.g., `app: my-app`).
* **Selectors** are rules in Services that find Pods with specific labels.
* The Service uses its selector to match Pods by their labels—this is how it discovers which Pods to send traffic to.
* If a Pod has no matching label, the Service ignores it. If a Service has no selector, it can't find any Pods.

Example:
* Pod: `labels: { app: my-app, env: prod }`
* Service: `selector: { app: my-app }` → matches the Pod above.

Check:
* See Pod labels: `kubectl get pods --show-labels`
* See Service selector: `kubectl describe svc <service-name>`
* See which Pods a Service targets: `kubectl get endpoints <service-name>`

**Note:** Labels & Selectors must be same

#### **3. Exposing the Application**
Services define how your application is accessed. There are three primary types:

* **ClusterIP (Default):**
    * **Scope:** Only accessible **inside** the Kubernetes cluster. (have to get in the cluster, then only you can access the pods and it's services)
    * **Use Case:** Internal communication between different parts of your app (e.g., a frontend talking to a backend).
    * **Access:** Only people/processes with access to the cluster network can reach it.

* **NodePort:**
    * **Scope:** Accessible within your **Organization/VPC** network.
    * **How it works:** It opens a specific port on every Worker Node's IP address.
    * **Access:** Anyone who can access the IP of the Worker Nodes (e.g., via AWS EC2 IP or a corporate VPN) can reach the service.

* **LoadBalancer:**
    * **Scope:** Accessible to the **External World (Internet)**.
    * **How it works:** When used on a cloud provider (like AWS EKS or Azure AKS), Kubernetes asks the cloud provider to create a native Load Balancer (like an AWS ELB).
    * **Technicality:** The **Cloud Controller Manager (CCM)** is the Kubernetes component responsible for talking to the cloud provider to provision this public IP.
    * **Note:** This type usually doesn't work out-of-the-box on local setups like Minicube.

---

### **Architecture Hierarchy**
The logical flow of traffic and resource management:
**Service** $\rightarrow$ **Deployment** $\rightarrow$ **ReplicaSet** $\rightarrow$ **Pods**

---

### **Summary Table**

| Service Type | Reachability | Typical User |
| :--- | :--- | :--- |
| **ClusterIP** | Internal Cluster Network | Other internal Pods / Developers |
| **NodePort** | Internal Org/VPC Network | Internal testers / Developers |
| **LoadBalancer** | Public Internet | End Customers (e.g., amazon.com) |

---

## 4. Service Example

#### The Deployment
Defines 2 replicas of the Python app. Kubernetes ensures these two pods are always running.
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-python-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: sample-python-app
  template:
    metadata:
      labels:
        app: sample-python-app
    spec:
      containers:
      - name: python-app
        image: abhishekf5/python-sample-app-demo:v1
        ports:
        - containerPort: 8000
```

command:
```
kubectl apply -f deployment.yaml
```

#### Verify Pods
Note the individual Pod IPs (e.g., 172.17.0.5). These are "ephemeral," meaning they change if a pod crashes or is replaced.

kubectl get pods -o wide
```
NAME                                 READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE   READINESS GATES
sample-python-app-85699f57dc-fwwfx   1/1     Running   0          44s   172.17.0.5    minikube   <none>           <none>
sample-python-app-85699f57dc-w71mr   1/1     Running   0          44s   172.17.0.6    minikube   <none>           <none>
```
**Problem: Ip changes**


#### A. The Service (NodePort)
The Service acts as a stable "Front Door," solving the issue of shifting Pod IPs and making the app accessible from your browser.

service.yaml:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-django-sample-app
spec:
  type: NodePort
  selector:
    app: sample-python-app
  ports:
    - port: 80          # Port accessible inside the cluster
      targetPort: 8000  # Port your Python app is listening on
      nodePort: 30007   # Port accessible from your browser (Minikube IP:30007)
```

command:
```
kubectl apply -f service.yaml
```

Verify Service:
command:
```
kubectl get svc
```

```
NAME                       TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
kubernetes                 ClusterIP   10.96.0.1        <none>        443/TCP          4h11m
python-django-sample-app   NodePort    10.101.63.207    <none>        80:30007/TCP     22s
```
on output:
- kubernetes (The System Service): This is a ClusterIP service that is automatically created by Kubernetes.
- python-django-sample-app (Your Service): This is the NodePort service you just created manually using your service.yaml file.


What this solved:
- The "Ephemeral IP" Problem: Before, if a pod died, its IP changed and you lost access. Now, the Cluster-IP (10.101.63.207) is permanent; even if pods restart, this IP never changes.

- The "Isolation" Problem: Pod IPs are internal only. The NodePort (30007) creates a bridge, allowing you to hit the app from your actual laptop using the Minikube IP.

- Automatic Load Balancing: The Service automatically splits traffic between your 2 replicas.


Can now access using cluster ip than the pod ip, useful as pod may go down and a new will have diff ip.

**Current Access Command:**
```
curl -L http://192.168.64.10:30007
```

### B. LoadBalancer Service
The `NodePort` works for **local testing** (meaning internal access within your own private network or Minikube), but for production-grade internet access, you need a `LoadBalancer`. This instructs your Cloud Provider (AWS, GCP, Azure) to provision a real, external load balancer with a public IP.

**Update `service.yaml`:**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: python-django-sample-app
spec:
  type: LoadBalancer  # Changed from NodePort
  selector:
    app: sample-python-app
  ports:
    - port: 80
      targetPort: 8000
```

---

### Conclusion: What This Example Demonstrates

This service example shows how Kubernetes Services provide:

1. **Service Discovery:**
  * The Service uses **labels & selectors** to automatically find and route traffic to the correct Pods, even as Pods are replaced or scaled.

2. **Load Balancing:**
  * Traffic is distributed across all healthy Pod replicas, so no single Pod is overloaded.

3. **Application Exposure:**
  * The app can be exposed **internally** (using ClusterIP), **within your network** (using NodePort), or **to the internet** (using LoadBalancer), depending on the Service type you choose.
---