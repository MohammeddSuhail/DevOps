# Docker Networking Reference

Networking allows containers to communicate with each other and with the host system. Containers run isolated by default and require defined network drivers to exchange data.

## Standard Drivers
When you run `docker network ls`, you will see the three default networks created by Docker:

* **bridge:** The default network for containers.
* **host:** Uses the host's networking stack directly.
* **none:** Disables all networking for the container.

---

## 1. Bridge Networking

### a. Default Bridge
The default network mode in Docker. It creates a private network between the host and containers, allowing
containers to communicate with each other and with the host system.
Allowing containers to communicate with the host and each other since they reside in the same subnet. However, it lacks automatic service discovery, meaning containers can only reach each other via IP addresses rather than container names.

![image](https://user-images.githubusercontent.com/43399466/217745543-f40e5614-ac34-4b78-85a9-91b24512388d.png)


### b. User-Defined Bridge
If you want to secure your containers and isolate them from the default bridge network you can also create your own bridge network(**User-Defined Bridge**).

```
docker network create -d bridge my_bridge
```

Now, if you list the docker networks, you will see a new network.

```
docker network ls

NETWORK ID          NAME                DRIVER
xxxxxxxxxxxx        bridge              bridge
xxxxxxxxxxxx        my_bridge           bridge
xxxxxxxxxxxx        none                null
xxxxxxxxxxxx        host                host
```

This new network can be attached to the containers, when you run these containers.

```
docker run -d --name <container_name> --network <network_name> <image_name>
or
docker run -d --name <container_name> --net=<network_name> <image_name>

ex: docker run -d --net=my_bridge --name db <image_name>
```

This way, you can run multiple containers on a single host platform where one container is attached to the default network and 
the other is attached to the my_bridge network.

These containers are completely isolated with their private networks and cannot talk to each other.

![image](https://user-images.githubusercontent.com/43399466/217748680-8beefd0a-8181-4752-a098-a905ebed5d2a.png)

However, you can at any point of time, attach the first container to my_bridge network and enable communication

```
docker network connect my_bridge web
```

![image](https://user-images.githubusercontent.com/43399466/217748726-7bb347d0-3736-4f89-bdff-31d240b15150.png)


---

## 2. Host Networking

This mode allows containers to share the host system's network stack, providing direct access to the host system's network.

To attach a host network to a Docker container, you can use the --network="host" option when running a docker run command. When you use this option, the container has access to the host's network stack, and shares the host's network namespace. This means that the container will use the same IP address and network configuration as the host.

Here's an example of how to run a Docker container with the host network:

```
docker run --network="host" <image_name> <command>
```

Keep in mind that when you use the host network, the container is less isolated from the host system, and has access to all of the host's network resources. This can be a security risk, so use the host network with caution.

Additionally, not all Docker image and command combinations are compatible with the host network, so it's important to check the image documentation or run the image with the --network="bridge" option (the default network mode) first to see if there are any compatibility issues.


---

### 3. Overlay Networking
This driver connects multiple Docker daemons (hosts) together. It is the backbone of **Docker Swarm**.

* **Function:** It allows a container on **Server A** to talk to a container on **Server B** as if they were on the same local switch, regardless of the physical infrastructure.
* **Encryption:** Supports built-in AES encryption for secure control plane and data plane traffic between hosts.
* **Prerequisite:** Requires the Docker engine to be in Swarm mode or connected to a key-value store.


---

### 4. Macvlan Networking
Assigns a unique MAC address to a container, making it appear as a **physical device** on your network rather than a virtualized entity.

* **Use Case:** Ideal for legacy applications that need to be monitored by network hardware or require specific IP assignments from your actual router/DHCP server.
* **Performance:** Very high. It bypasses the Docker host's bridge stack and NAT, routing traffic directly to the container's interface.
* **Note:** The host and container cannot communicate directly over a Macvlan interface without specific routing configuration on the host.