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
* Instead, they use **Labels and Selectors**.
* **How it works:** You give Pods a label (e.g., `app: payment`). The Service is configured with a selector (e.g., `app: payment`). The Service will automatically "discover" and send traffic to any Pod that has that specific label, even if the Pod is brand new.

#### **3. Exposing the Application**
Services define how your application is accessed. There are three primary types:

* **ClusterIP (Default):**
    * **Scope:** Only accessible **inside** the Kubernetes cluster.
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
**Video Source:** [EVERYTHING ABOUT KUBERNETES SERVICES](https://www.youtube.com/watch?v=xY6Ic7Igzck)