
# Kubernetes Deployment & ReplicaSet Notes

## Why Use Deployments?

While you can directly create Pods, doing so is not recommended for production environments. **Standalone Pods lack important features such as auto-healing, automated scaling, and seamless updates**. If a standalone Pod fails or is deleted, it will not be recreated automatically, leading to downtime and manual intervention.

To address these limitations, Kubernetes provides higher-level objects like **Deployments**. A Deployment acts as a wrapper that manages ReplicaSets and Pods for you, enabling:

- **Auto-healing:** Failed or deleted Pods are automatically replaced.
- **Scaling:** Easily increase or decrease the number of Pods.
- **Zero-downtime updates:** Roll out new versions without service interruption.
- **Declarative management:** Define your desired state in YAML, and Kubernetes ensures it matches reality.

In summary, Deployments provide robust, production-grade management for your applications, making them the standard way to run workloads in Kubernetes.

## 1. The Core Hierarchy

Kubernetes manages containers through layers of abstraction. You should never manage individual Pods in production; instead, you use a Deployment.

* **Deployment:** Used because it is the recommended way to manage applications in production—enabling declarative updates, automated rollouts, auto-healing, and scaling. High-level object for declarative updates (**Auto-healing**, **Scaling**, **Rollouts**). **Creates and manages ReplicaSets.**
* **ReplicaSet (K8s Controller):** The intermediate layer that ensures the specified number of pod replicas are running at all times. **Created and managed by a Deployment. Creates and manages Pods.**
* **Pod:** The smallest unit; contains the container(s). **Created and managed by a ReplicaSet.**

**Workflow:**

```
Deployment
  ↓
ReplicaSet
  ↓
Pods
```

---

## 2. Pod vs. Deployment
| Feature | Pod (Standalone) | Deployment |
| :--- | :--- | :--- |
| **Auto-Healing** | No (If deleted, it stays deleted) | **Yes (If deleted, it is recreated)** |
| **Scaling** | Manual only | **Automated (Change `replicas` in YAML)** |
| **Updates** | Manual replacement | **Zero-downtime rolling updates** |
| **Best Practice** | Use for testing/single tasks | **Standard for production apps** |

---

## 3. The Kubernetes Controller Concept
A **Controller** (like a ReplicaSet) is a loop that continuously compares the **Desired State** (what you wrote in the YAML) with the **Actual State** (what is currently running in the cluster).
* If **Actual < Desired**: It creates more pods.
* If **Actual > Desired**: It deletes extra pods.

---

## 4. Deployment YAML Breakdown: Example


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3          # Desired State: number of pods
  selector:
    matchLabels:       # Tells Deployment which pods it "owns"
      app: nginx
  template:            # Blueprint for the Pods to be created
    metadata:
      labels:
        app: nginx     # Must match the selector above
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```


---
### Example: Creating and Managing a Deployment

```sh
# Apply the deployment manifest
kubectl apply -f 1_deployment.yml
# Output:
deployment.apps/nginx-deployment created
```

```sh
# Check deployments
kubectl get deploy
# Output:
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           7s
```

```sh
# Check ReplicaSets
kubectl get rs
# Output:
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-77bc6bd484   3         3         3       37s
```

```sh
# Check Pods
kubectl get pod
# Output:
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-77bc6bd484-4bcxt   1/1     Running   0          14s
nginx-deployment-77bc6bd484-9n7sw   1/1     Running   0          14s
nginx-deployment-77bc6bd484-gckbh   1/1     Running   0          14s
```


> **Auto-healing in action:**
> If you delete a pod (or it goes down for any reason), the ReplicaSet will automatically create a new pod to maintain the desired state.

```sh
# Delete a pod
kubectl delete pod nginx-deployment-77bc6bd484-4bcxt
```

```sh
# Watch pods as they are recreated
kubectl get pods -w
# Output (example):
NAME                                READY   STATUS        RESTARTS   AGE
nginx-deployment-77bc6bd484-4bcxt   1/1     Running       0          73s
nginx-deployment-77bc6bd484-9n7sw   1/1     Running       0          73s
nginx-deployment-77bc6bd484-gckbh   1/1     Running       0          73s
nginx-deployment-77bc6bd484-4bcxt   1/1     Terminating   0          99s
nginx-deployment-77bc6bd484-bw25l   0/1     Pending       0          0s
nginx-deployment-77bc6bd484-bw25l   0/1     ContainerCreating   0    0s
nginx-deployment-77bc6bd484-bw25l   1/1     Running             0    1s
```

---


---
### Deleting a Deployment

When you delete a deployment, it will also delete the associated ReplicaSet and pods.

```sh
# By manifest file
kubectl delete -f 1_deployment.yml
# Or by name
kubectl delete deployment nginx-deployment
```

