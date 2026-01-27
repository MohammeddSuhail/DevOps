# Understanding Docker Layers

In Docker, an image is not a single monolithic file. Instead, it is a collection of **read-only layers** stacked on top of each other. Each layer represents a change made to the filesystem during the build process.

## 1. How Layers Are Created
When you run `docker build`, Docker executes the instructions in your `Dockerfile` line by line. For instructions like `RUN`, `COPY`, or `ADD`:
1. Docker spins up a **temporary intermediate container** based on the previous layer.
2. It executes the command inside that temporary container.
3. It takes a "snapshot" of the changes (filesystem diff).
4. That snapshot becomes a new **read-only layer**.
5. The temporary container is deleted, and the process moves to the next line.



## 2. Key Concepts

### Layer Caching
Docker remembers (caches) each layer. If you rebuild an image and haven't changed a specific line in the `Dockerfile`, Docker reuses the existing layer from its cache instead of running the command again. This is why second builds are much faster.

### Immutability (Read-Only)
Once a layer is created, it cannot be changed. If you "delete" a file in a higher layer, the file is simply hidden from the final view; it still exists in the lower layer where it was originally created.

### The Writable Layer (Container Layer)
When you start a container, Docker adds a thin **Writable Layer** on top of the image layers. 
* All changes made during the container's runtime (writing logs, editing files) happen here.
* When the container is deleted, this layer is destroyed. The underlying image layers remain untouched.



## 3. Best Practices for Layer Optimization

* **Combine Commands:** Every `RUN` instruction creates a layer. Combine related commands using `&&` and `\` to keep the image size small.
  * *Example:* `RUN apt-get update && apt-get install -y git`
* **Order Matters:** Place instructions that change frequently (like `COPY . /app`) at the **bottom** of your Dockerfile. Place instructions that rarely change (like OS updates or installing dependencies) at the **top**. This maximizes the use of the layer cache.
* **Clean Up in the Same Layer:** If you download a temporary file to install a tool, delete that file in the same `RUN` command. If you delete it in a separate line, the file remains in the previous layer, bloating the image size.

## 4. Useful Commands
* `docker history <image_id>`: Shows the layers, their size, and the commands that created them.
* `docker inspect <image_id>`: Provides detailed metadata, including the RootFS (filesystem) layers.