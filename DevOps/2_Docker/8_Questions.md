# Docker Interview Questions & Answers Summary

## Core Interview Questions

### 1. What is Docker / a Container?
Docker is an open-source containerization platform used to manage the entire lifecycle of containers. When answering, focus on the practical application: writing Dockerfiles, building images, and running containers to ensure environment consistency.

### 2. Containers vs. Virtual Machines (VMs)
* **VMs:** Include a full guest operating system, making them heavy, slow to boot, and resource-intensive. They run on a hypervisor.
* **Containers:** Lightweight because they share the host OS kernel. They only contain the application, its dependencies, and minimal system libraries. 
* **Note:** Never say containers have "no OS"; they simply lack a full OS kernel and use minimal system dependencies.

### 3. Docker Lifecycle
The standard workflow involves:
* Writing a **Dockerfile** (the blueprint).
* Building a **Docker Image** (the executable package).
* Running a **Docker Container** (the active instance).
* Pushing the image to a **Registry** (e.g., Docker Hub, AWS ECR).

### 4. Docker Components
* **Docker Client:** The CLI tool used by the developer to trigger commands.
* **Docker Daemon (Host):** The background service (heart of Docker) that manages images, containers, networks, and volumes.
* **Docker Registry:** A centralized repository for storing and distributing images.

### 5. COPY vs. ADD
* **COPY:** Strictly for copying local files/directories from the host to the container.
* **ADD:** More powerful; it can pull files from remote URLs and automatically extract compressed files (like .tar or .zip) into the destination.

### 6. CMD vs. ENTRYPOINT
* **CMD:** Provides default arguments for a container. These are easily overridden by providing a different command at runtime.
* **ENTRYPOINT:** Defines the main executable of the container. It is harder to override and ensures the container always runs a specific application.
* **Best Practice:** Use ENTRYPOINT for the executable and CMD for the default flags/arguments.

### 7. Networking Types
* **Bridge (Default):** Creates a private internal network on the host so containers can communicate.
* **Host:** Removes isolation; the container uses the host's networking stack directly.
* **Overlay:** Enables communication between containers running on different Docker hosts (Swarm/K8s).
* **MacVLAN:** Assigns a MAC address to a container, making it appear as a physical device on the network.

### 8. Network Isolation
To secure sensitive services (like a payments DB), you should create a **Custom Bridge Network**. By default, containers on different custom networks cannot communicate, providing a layer of security through isolation.

### 9. Multi-Stage Builds
This is a technique to optimize Dockerfiles. You use one large image to compile/build the application code and then copy only the resulting binary into a much smaller, production-ready image. This can reduce image sizes by up to 90%.

### 10. Distroless Images
These are minimal images that contain only your application and its runtime dependencies. They do not contain shells (bash/sh) or package managers (apt/yum). This reduces the "attack surface," making the container significantly more secure.

---

## Real-Time Challenges & Security

### 11. Real-World Challenges
* **Single Point of Failure:** Because Docker relies on a single Daemon, if that process crashes, all managed containers are affected.
* **Root Vulnerability:** The Docker Daemon traditionally runs with root privileges. If a container is compromised, there is a risk of the attacker gaining host-level access.
* **Resource Contention:** Without proper limits, one container can consume all host CPU or RAM, "starving" other containers on the same host.

### 12. Steps to Secure Containers
* Use **Distroless Images** to minimize vulnerabilities.
* Implement **Network Segregation** via custom bridge networks.
* Use scanning tools (like **Snyk** or **Trivy**) to check images for vulnerabilities before deployment.
* Run containers as **Non-Root Users** whenever possible.

---

## Additional Recommended Questions

* **How do you persist data?** Explain the difference between Volumes (managed by Docker) and Bind Mounts (dependent on host file structure).
* **What is a "Dangling Image"?** An image that has no relationship to any tagged image and consumes unnecessary disk space.
* **How do you reduce layers?** Explain how combining multiple `RUN` commands using `&&` and `\` reduces the number of intermediate layers in an image.
* **What is Docker Compose?** A tool used to define and run multi-container applications using a YAML file.
* **How do you limit resources?** Use flags like `--memory` and `--cpus` during `docker run` to prevent a single container from crashing the host.