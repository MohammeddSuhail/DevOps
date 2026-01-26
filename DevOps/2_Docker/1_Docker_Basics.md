## Docker


### What is Docker ?

Docker is a containerization platform that provides easy way to containerize your applications, which means, using Docker you can build container images, run the images to create containers and also push these containers to container regestries such as DockerHub, Quay.io and so on.

In simple words, you can understand as `containerization is a concept or technology` and `Docker Implements Containerization`.


### Docker Architecture ?

![image](https://user-images.githubusercontent.com/43399466/217507877-212d3a60-143a-4a1d-ab79-4bb615cb4622.png)

The above picture, clearly indicates that Docker Deamon is brain of Docker. If Docker Deamon is killed, stops working for some reasons, Docker is brain dead :p (sarcasm intended).

### Docker LifeCycle 

We can use the above Image as reference to understand the lifecycle of Docker.

There are three important things,

The Dockerfile (The Recipe)
1. docker build -> builds docker images from Dockerfile  > (Cooking the Dish)
2. docker run   -> runs container from docker images     > (Serving the Meal)
3. docker push  -> push the container image to public/private regestries to share the docker images.  > (The Grocery Store)

![Screenshot 2023-02-08 at 4 32 13 PM](https://user-images.githubusercontent.com/43399466/217511949-81f897b2-70ee-41d1-b229-38d0572c54c7.png)



### Why push the Image instead of the Dockerfile?

* **Consistency:** A Dockerfile is just instructions. If a background dependency updates tomorrow, building the Dockerfile twice might produce two different results. The **Image** is a frozen snapshot—it never changes.
* **Speed:** Building an image takes time (compiling code, installing packages). Pushing the **Image** allows others to skip the "cooking" and just "eat" (run) the result instantly.
* **Zero Dependencies:** A Dockerfile needs your local source code to work. An **Image** already has the code, libraries, and tools "baked in" so it can run anywhere without extra files.
* **Production Safety:** You don't want your production servers to act as compilers. They should just download the finished product and start it immediately.

| Share the... | Analogy | Result |
| :--- | :--- | :--- |
| **Dockerfile** | The Recipe | They have to buy ingredients and cook it themselves. |
| **Image** | The Frozen Meal | They just heat it up and it tastes exactly like yours. |


## Essential Commands
| Command | Purpose |
| :--- | :--- |
| `docker build -t my-app .` | **Build** an image named "my-app" from the current folder. ex: docker build .|
| `docker run -p 8080:80 my-app` | **Run** the app, mapping your PC's port 8080 to container port 80. |
| `docker ps` | **List** all currently running containers. |
| `docker images` | **List** all images stored on your machine. |
| `docker stop <id>` | **Stop** a specific running container. |
| `docker rm <id>` | **Delete** a stopped container. |
| `docker rmi <id>` | **Delete** an image. |
| `docker exec -it <id> bash` | **Enter** a running container to type commands inside it. |

## Dockerfile "Language" Key
| Instruction | Purpose | Example |
| :--- | :--- | :--- |
| **FROM** | The starting point (Base OS or Language) | `FROM ubuntu:22.04` or `FROM python:3.9-slim` or `FROM debian:slim`|
| **WORKDIR** | Sets the "home directory" inside container | `WORKDIR /app` |
| **SHELL** | Changes the default shell for `RUN` commands | `SHELL ["/bin/bash", "-c"]` |
| **COPY** | Moves files from PC into container | `COPY . /app` |
| **RUN** | Runs commands **during build** (installing) | `RUN apt-get update && apt-get install -y python3` |
| **ENV** | Sets environment variables (keys/configs) | `ENV DB_PASSWORD=secret` |
| **EXPOSE** | Documents which port the app uses | `EXPOSE 8080` |
| **ENTRYPOINT** | The **permanent** command (Executable) | `ENTRYPOINT ["python3"]` |
| **CMD** | The **default argument** (Overridable) | `CMD ["manage.py", "runserver"]` |

### Pro Tip: The ENTRYPOINT + CMD Combo
If your Dockerfile has:
`ENTRYPOINT ["python"]`
`CMD ["app.py"]`

1. Running `docker run my-image` executes: **python app.py**
2. Running `docker run my-image test.py` executes: **python test.py** *(The user easily overrides the CMD, but the ENTRYPOINT "python" stays fixed).*


---

### Understanding the terminology (Inspired from Docker Docs)


#### Docker daemon

The Docker daemon (dockerd) listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes. A daemon can also communicate with other daemons to manage Docker services.


#### Docker client

The Docker client (docker) is the primary way that many Docker users interact with Docker. When you use commands such as docker run, the client sends these commands to dockerd, which carries them out. The docker command uses the Docker API. The Docker client can communicate with more than one daemon.


#### Docker Desktop

Docker Desktop is an easy-to-install application for your Mac, Windows or Linux environment that enables you to build and share containerized applications and microservices. Docker Desktop includes the Docker daemon (dockerd), the Docker client (docker), Docker Compose, Docker Content Trust, Kubernetes, and Credential Helper. For more information, see Docker Desktop.


#### Docker registries

A Docker registry stores Docker images. Docker Hub is a public registry that anyone can use, and Docker is configured to look for images on Docker Hub by default. You can even run your own private registry.

When you use the docker pull or docker run commands, the required images are pulled from your configured registry. When you use the docker push command, your image is pushed to your configured registry.
Docker objects

When you use Docker, you are creating and using images, containers, networks, volumes, plugins, and other objects. This section is a brief overview of some of those objects.


#### Dockerfile

Dockerfile is a file where you provide the steps to build your Docker Image. 


#### Images

An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization. For example, you may build an image which is based on the ubuntu image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.

You might create your own images or you might only use those created by others and published in a registry. To build your own image, you create a Dockerfile with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies.
