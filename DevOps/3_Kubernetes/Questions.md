# Kubernetes Interview Notes: Part 1

### **1. Docker vs. Kubernetes**
* **Docker:** A containerization platform used to package, distribute, and run applications in isolated containers on a single host.
* **Kubernetes (K8s):** A container **orchestration** platform. It manages clusters of virtual or physical machines.
* **Key Advantage:** While containers are ephemeral (they can crash or die), Kubernetes provides **auto-healing**, **auto-scaling**, and **load balancing** to ensure high availability.
* Docker is a container platform where as Kubernetes is a container orchestration environment that offers capabilities like Auto healing, Auto Scaling, Clustering and Enterprise level support like Load balancing.

### **2. Kubernetes Architecture Components**

The cluster is split into two main sections:
* **Control Plane (Master Node):**
    * **API Server:** The entry point for all REST commands.
    * **Etcd:** The "source of truth" key-value store for cluster data.
    * **Scheduler:** Decides which worker node a Pod should run on.
    * **Controller Manager:** Maintains the desired state (e.g., ensuring the right number of Pods are running).
    * **Cloud Control Manager:** Connects the cluster to cloud-specific APIs (AWS, Azure, GCP).
* **Data Plane (Worker Node):**
    * **Kubelet:** The agent that manages the Pod lifecycle on the node.
    * **Kube-Proxy:** Handles networking and IP table updates.
    * **Container Runtime:** The engine that runs the containers (e.g., Containerd, CRI-O).

### **3. Kubernetes vs. Docker Swarm**
* **Docker Swarm:** Much easier to set up and great for small, simple applications. However, it lacks advanced scaling and networking flexibility.
* **Kubernetes:** The industry standard for enterprise/mid-scale. It has a massive ecosystem and allows for extreme customization through **CRDs (Custom Resource Definitions)**.

### **4. Pods vs. Containers**
* A **Pod** is the smallest unit of deployment in K8s. 
* It acts as a wrapper for one or more containers. 
* Containers inside a Pod share the same network namespace (IP) and storage volumes.

### **5. Namespaces**
* **Logical Isolation:** Used to divide cluster resources between multiple users or projects.
* **Analogy:** Physical isolation would be buying 10 different clusters; logical isolation is using one cluster but separating it into "Project A" and "Project B" namespaces to save costs and simplify management.
* In Kubernetes namespace is a logical isolation of resources, network policies, rbac and everything. For example, there are two projects using same k8s cluster. One project can use ns1 and other project can use ns2 without any overlap and authentication problems.

### **6. Role of Kube-Proxy**
* It is the networking brain on each worker node.
* It configures **IP tables** (or IPVS) so that when a request hits a specific IP and Port, the Linux kernel knows exactly which Pod to route that traffic to.
* Kube-proxy works by maintaining a set of network rules on each node in the cluster, which are updated dynamically as services are added or removed. When a client sends a request to a service, the request is intercepted by kube-proxy on the node where it was received. Kube-proxy then looks up the destination endpoint for the service and routes the request accordingly. Kube-proxy is an essential component of a Kubernetes cluster, as it ensures that services can communicate with each other.

### **7. Service Types**

| Service Type | Scope | Use Case |
| :--- | :--- | :--- |
| **ClusterIP** | Internal | Default type; used for communication *inside* the cluster. |
| **NodePort** | External (Org-wide) | Exposes the service on a static port on each Node's IP. |
| **LoadBalancer** | External (Public) | Provisions a cloud provider's load balancer to give the app a public IP. |

### **8. What is the difference between NodePort and LoadBaIancer type service ?**
* When a service is created a NodePort type, The kube-proxy updates the IP Tables with Node IP address and port that is chosen in the service configuration to access the pods.
* Where as if you create a Service as type LoadBaIancer, the cloud control manager creates a external load balancer IP using the underlying cloud provider logic in the C-CM. Users can access services using the external IP

### **9. Role of Kubelet**
* It is the "captain" of the worker node.
* It continuously watches the API Server for Pod specifications assigned to its node and ensures the containers are running and healthy. If a container dies, Kubelet reports it and helps restart it.
* Kubelet manages the containers that are scheduled to run on that node. It ensures that the containers are running and healthy, and that the resources they need are available. Kubelet communicates with the Kubernetes API server to get information about the containers that should be running on the node, and then starts and stops the containers as needed to maintain the desired state. It also monitors the containers to ensure that they are running correctly, and restarts them if necessary.

### **10. Day-to-Day DevOps Activities (K8s)**
* **Maintenance:** Upgrading worker node versions and patching security vulnerabilities.
* **Deployment:** Managing YAML manifests and Helm charts to deploy applications.
* **Troubleshooting:** Helping developers debug Pod crashes, service discovery issues, or networking bottlenecks.
* **Monitoring:** Setting up alerts for resource usage (CPU/Memory) to ensure cluster stability.