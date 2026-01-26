# Docker Volumes

## Problem Statement

It is a very common requirement to persist the data in a Docker container beyond the lifetime of the container. However, the file system
of a Docker container is deleted/removed when the container dies. 

## Solution

There are 2 different ways how docker solves this problem.

1. Volumes
2. Bind Mount (Directory on a host as a Mount)


---

### Volumes 

Volumes aims to solve the same problem by providing a way to store data on the host file system, separate from the container's file system, 
so that the data can persist even if the container is deleted and recreated.

![image](https://user-images.githubusercontent.com/43399466/218018334-286d8949-d155-4d55-80bc-24827b02f9b1.png)


Volumes can be created and managed using the docker volume command. You can create a new volume using the following command:

```
docker volume create <volume_name>
```

```
List:
docker volume ls

Remove:
docker volume rm <volume_name>

Delete ALL Unused Volumes (Prune)
docker volume prune

Inspect: More info on volume:
 docker inspect <volume_name>
```

Once a volume is created, you can mount it to a container using the -v or --mount option when running a docker run command. 
Since you cannot attach a volume to a container that is already running, you must define the mount at the moment you start it.

For example: Start an container with the volume attahched to it

```
docker run -d --name my_app -v suhail_vol1:/data my-django-app:v1
```

```
example: docker run -d --name my_app -v suhail_vol1:/data my-django-app:v1
```

This command will mount the volume <volume_name> to the /data directory in the container. Any data written to the /data directory
inside the container will be persisted in the volume on the host file system.

🤝 Sharing Volumes Between Containers:
One of the biggest advantages of Volumes is that they can be mounted by multiple containers at the same time. This allows different apps to share the same data in real-time.


---

### Bind Mount (Directory on a host as a Mount)

Bind mounts also aims to solve the same problem but in a complete different way.

Using this way, user can mount a directory from the host file system into a container. Bind mounts have the same behavior as volumes, but
are specified using a host path instead of a volume name. 

For example, 

```
docker run -it -v <host_path>:<container_path> <image_name> /bin/bash
```


---

## 🔄 Key Differences: Volumes vs. Bind Mounts


### 🍃 Volumes
Volumes are managed, created, and deleted via the **Docker API**. They are much more powerful than bind mounts because they are decoupled from the host's direct directory structure.

* **Logical Separation:** Volumes are managed and backed up "separately" from the host's user files. You don't need to track physical paths; you simply reference the Volume Name.
* **Cloud & Remote Storage:** Unlike bind mounts, volumes can use **Volume Drivers**. This allows you to store data directly on **AWS S3, Azure File Share, or NFS** instead of the local hard drive.
* **Portability:** Because they aren't tied to a specific host path, they can be moved or shared between different containers and hosts easily.
* **Performance & Security:** Volumes are stored in a protected system area, making them faster and safer for databases than standard host folders.

### 🔗 Bind Mounts
Bind Mounts are a direct, "dumb" link to a specific directory on your host file system.

* **Path Dependent:** They rely on the host having a specific folder path (e.g., `C:\Users\App\data`). If the path changes, the container fails.
* **No Cloud Support:** Bind mounts are restricted to the **local physical disk** of the host machine. They cannot natively talk to S3 or cloud buckets.
* **Simplicity:** Best for **development** where you want your container to see your source code changes in real-time.

---

### 💡 In a Nutshell
**Bind Mounts** are for simple local tasks, like mounting your source code into a container while you are coding.

**Volumes** are for production. They give you "superpowers" like storing data in the **cloud (S3/Azure)**, easier backups, and better security by hiding data away from the host's standard file system.