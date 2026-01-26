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
