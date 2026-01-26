# Docker Essentials Cheat Sheet

## 1. Building Images
The **build** command turns your `Dockerfile` and source code into a runnable image.

* **Basic Build:**
    ```bash
    docker build .
    ```
    *`. (The Dot)`: Tells Docker to look for the `Dockerfile` in the current directory.*

* **Build with Tagging (Recommended):**
    ```bash
    docker build -t <name>:<tag> .
    # Example:
    docker build -t my-django-app:v1 .
    ```

* **View Images:**
    ```bash
    docker images -a
    ```
    *Note: `<untagged>` images occur if you build without a tag or rebuild an image using the same tag name.*

    ```bash
    docker images -a
    ```
    **Example Output:**
    ```text
    IMAGE              ID              DISK USAGE   CONTENT SIZE   EXTRA
    <untagged>         76c191aceca8    898MB        230MB          U
    my-django-app:v1   981c919959aa    898MB        230MB          U
    ```

* **Pushing to Docker Hub:**
    1. **Login:** `docker login`
    2. **Tag for Registry:** `docker tag <image_id> <your_username>/<repo_name>:<tag>` 
       (need to do this if we haven't tagged with the username when we built it, no need if: docker build -t yourusername/my-django-app:v1 .)
    3. **Push:** `docker push <your_username>/<repo_name>:<tag>`

---

## 2. Running Containers
The **run** command creates an active instance (container) from your static image.

* **Syntax:**
    ```bash
    docker run --name <container_name> -p <host_port>:<container_port> <image_id_or_tag>
    ```
    ```bash
    example:
    1. without using tag, with image id: docker run --name some_name -p 8000:8000 76c191aceca8
    2. if using tag:                    docker run --name some_name -p 8000:8000 my-django-app:v1
    ```

* **Port Mapping (Left:Right):**
    * **Host Port (Left):** The port on your laptop (e.g., `localhost:8000`).
    * **Container Port (Right):** The port inside the Docker container where the app is listening.
    
    > **Note:** Ports **can be different**. This is extremely useful if you are a developer running multiple projects that all use port `8000` internally(differnt conatiner obviously). You cannot run them all on port `8000` on your laptop simultaneously because the ports would clash. 
    >
    > With Docker, you can map them to different Host ports to avoid this:
    >
    > * **Project A:** `docker run -p 8001:8000 project-a`
    > * **Project B:** `docker run -p 8002:8000 project-b`
    > * **Project C:** `docker run -p 8003:8000 project-c`

* **Running in Background (Detached Mode):(seesion used for running image will be free)**
    ```bash
    docker run -d --name <container_name> -p 8000:8000 my-django-app:v1
    ```
    *Use `-d` so your terminal doesn't get "stuck" in the app logs.*

* **Accessing the application in this example(django web app):** 
    http://localhost:8000/demo/
---

## 3. Managing Active Containers

* **List Running Containers:**
    ```bash
    docker ps
    ```

* **List ALL Containers (including stopped ones):**
    ```bash
    docker ps -a
    ```

* **Check Logs of a Background Container:**
    ```bash
    docker logs <container_id_or_name>
    ```

---

## 4. Scaling and Distribution

* **Scaling (Running multiple instances):**
    Since the image is a blueprint, you can run multiple containers on different host ports:
    ```bash
    docker run -d -p 8001:8000 my-django-app:v1
    docker run -d -p 8002:8000 my-django-app:v1
    ```

---

## 5. Maintaining & Cleanup

### Containers 📦
* **Inspect:** `docker inspect <container_id_or_name>`
* **Start a Stopped Container:** `docker start <container_id_or_name>`
* **Stop a Container:** `docker stop <container_id>`
* **Remove a Container:** `docker rm <container_id_or_name>`
* **The "Nuke" Option (Clean everything unused(not running, i.e, stopped)):** 
   `docker system prune`

### Images 🖼️
* **Remove a Specific Image:** `docker rmi <image_id_or_tag>`
    * *Note:* You must remove any containers using this image before you can delete it.
* **Remove Dangling Images:** `docker image prune`
    * *Note:* This cleans up "layer" images that no longer have a name/tag.*
* **Remove ALL Unused Images:** `docker image prune -a`
    * *Note:* this to delete every image that isn't currently being used by a running container.*


---

## 6. Accessing Containers 🐚

Since containers provide an isolated environment, you can access them much like a VM to run commands or inspect files.

* **Interactive Run (New Container):** `docker run -it <image_id_or_tag> bash`
  *Use this to start a fresh container and jump immediately into its shell.*

* **Execute Shell (Existing Container):** `docker exec -it <container_id> bash`
  *Use this to enter a container that is already running in the background.*

> **Note:** If `bash` is not available in the image (like in some lightweight Alpine images), try using `sh` instead.

### 💡 When to use this:
* **Debugging Only:** Use this to inspect logs, check if files exist, or test network connectivity. 🔍
* **Don't Code Inside:** Never use this to update your app's code. Since containers are temporary, any changes you make manually will be **deleted** when the container stops. 
* **The Workflow:** Always change code on your **Host** (laptop), rebuild the image, and deploy a fresh container. 🏗️