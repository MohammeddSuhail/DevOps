# Kubernetes Learning Notes: Day 33 - Pods & First App Deployment

## Core Concepts: Why Pods?
In Docker, the smallest unit is a **Container**. In Kubernetes (K8s), the smallest unit is a **Pod**.

* **The Wrapper:** A Pod is a wrapper around one or more containers. Kubernetes doesn't manage containers directly; it manages Pods.
* **Declarative vs. Imperative:** Instead of running a command like `docker run`, you write a **YAML file** (Declarative) that describes the desired state. K8s constantly works to ensure the "Actual State" matches this "Desired State."
* **Shared Resources:** If a Pod has multiple containers:
    * **Networking:** They share the same IP and can talk via `localhost`.
    * **Storage:** They can share the same mounted volumes.

---

## kubectl
`kubectl` is the Command Line Interface (CLI) for Kubernetes, functioning similarly to the `docker` CLI.
* **Purpose:** It interacts with the Kubernetes API server to create, manage, and delete resources.
* **Cheat Sheet:** Keep this handy: [Kubectl Quick Reference](https://kubernetes.io/docs/reference/kubectl/quick-reference/)

---

## Tools for Practice (Not for Production)
Local alternatives allow you to learn without the cost of cloud providers like AWS (EKS) or Google (GKE).

| Tool | Description |
| :--- | :--- |
| **Minikube** | Creates a VM (or container) on your laptop to run a single-node cluster. |
| **Kind** | "Kubernetes in Docker" — runs K8s nodes as Docker containers. Very fast and popular for testing. |
| **K3s / MicroK8s** | Highly lightweight versions, great for resource-constrained environments or IoT. |

---

## Practical Workflow: Deploying a Pod
I used **Minikube to provision a local cluster**, on which I **deployed a Pod** following standard Kubernetes practices.

### 1. Create a Cluster
```bash
# This creates a single-node cluster using Docker as the underlying driver
minikube start --memory=4096 --driver=docker
```

### 2. Verify the Node
```
kubectl get nodes
```
Output:
```
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   6m15s   v1.35.0
```

### 3. The Manifest File
Commonly called a Manifest, Pod Spec, or Pod Definition file.

Example (pod.yml):
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

### 4. Deploy the Pod
'apply' is preferred over 'create' for better management of updates
```
kubectl apply -f pod.yml
```

### 5. Verify the Pod
```
kubectl get pods -o wide
```

Output:
```
NAME    READY   STATUS    RESTARTS   AGE   IP            NODE       NOMINATED NODE
nginx   1/1     Running   0          32s   10.244.0.3    minikube   <none>
```

### 6. Debugging & Testing
- kubectl describe pod <name>: Check the Events at the bottom for errors (e.g., ImagePullBackOff).
    ```
    kubectl describe pod <pod_name>
    ex: 
    kubectl describe pod nginx
    ```

- kubectl logs <name>: Check application output/logs.
    ```
    kubectl logs pod <pod_name>
    ex: 
    kubectl logs pod nginx
    10.244.0.1 - - [03/Feb/2026:16:48:14 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.88.1" "-"
    ```

- minikube ssh: Enter the node to test the internal IP.
    ```
    <node_name> ssh
    ex:
    minikube ssh
    # Inside the node:
    curl 10.244.0.3
    ```

### 7. Deleting a pod
```
kubectl delete pod <pad_name>
```
```
kubectl delete pod nginx
```