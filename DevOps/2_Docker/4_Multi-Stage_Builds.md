# Advanced Docker Optimization 🚀

## 🏗️ Multi-Stage Builds
Standard builds include compilers, build caches, and source code in the final image, making it massive. Multi-stage builds use multiple `FROM` statements to separate the **build** environment from the **runtime** environment.

> **The Key:** Using Multi-Stage Builds, you can have **any number of stages** (e.g., Build, Lint, Test, Security Scan). Docker creates **temporary containers** to run these intermediate steps, but it only saves the very last stage as your final image. This keeps your production image tiny and hides your internal build logic.

**Example of a 2-stage workflow:**
* **Stage 1 (Build):** Docker launches a **temporary container** using a "heavy" image (e.g., `golang`, `maven`, `node`). This container has all the tools needed to compile the code. Once the build is finished, this container is discarded.
* **Stage 2 (Run):** Docker starts a fresh, minimal image. It reaches into the discarded Stage 1 container to copy **only** the final "executable" or "binary." This is the only part that becomes your final, permanent image.


### Multi-Stage Example (Go)
```dockerfile
# STAGE 1: Build (A temporary "Kitchen" stage)
FROM golang:1.21 AS build-env
WORKDIR /src
COPY . .
RUN go build -o /hello main.go

# STAGE 2: Ship (The final "Dining Room" image)
FROM alpine:latest
# We reach into the temporary build-env stage to grab the binary
COPY --from=build-env /hello /hello
CMD ["./hello"]
```


---

## 🍃 Distroless Images
Distroless images are the ultimate "minimal" runner. They contain only your application and its dependencies (like a language runtime). Unlike standard images, they do not contain a full Linux Operating System.

### The Difference in Layers:

* **Standard Image (Ubuntu/Debian):** Contains a **full OS**, shell, package manager, and hundreds of utilities you don't need to run your app.
* **Minimal Image (Alpine):** A **very lightweight OS** (~5MB) that still includes a shell (`sh`) and a package manager (`apk`).
* **Distroless:** **No Operating System.** It only contains the application and the specific libraries (like Python or OpenJDK) required to execute it.

**What is NOT inside:**
* ❌ **Package managers** (`apt`, `yum`, `pip`)
* ❌ **Shells** (`bash`, `sh`)
* ❌ **Standard utilities** (`ls`, `cd`, `grep`, `cat`)

**Benefits:**
* **Security:** Reduces the "attack surface." A hacker cannot use system tools or download scripts if they breach the app. 🛡️
* **Size:** Significantly reduces the final image size (often by 80-90%). 📉

```dockerfile
FROM gcr.io/distroless/python3
WORKDIR /app
COPY my_script.py .
# No shell means we must use the "Exec Form" (JSON array)
CMD ["my_script.py"]
```


---

## 🛠️ Combined Example (Multi-Stage Builds + Distroless)
```dockerfile
# --- Stage 1: The Build Environment (Heavy Maven Image) ---
FROM maven:3.9-eclipse-temurin-17 AS build-stage
WORKDIR /build
COPY pom.xml .
COPY src ./src
# Compile the code and create the JAR file
RUN mvn clean package -DskipTests


# --- Stage 2: The Production Runtime (Minimal Distroless Image) ---
FROM gcr.io/distroless/java17-debian11
WORKDIR /app

# Copy ONLY the final .jar file from the builder stage
COPY --from=build-stage /build/target/app-1.0.jar /app/app.jar

# Distroless requires the JSON array format for CMD
CMD ["app.jar"]
```



---

## Example of a 3-stage workflow of Multi-Stage Builds:

```dockerfile
# --- STAGE 1: Build ---
# We use a heavy image with the Go compiler
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
# Compile the application into a static binary
RUN go build -o /my-app main.go


# --- STAGE 2: Test ---
# We reuse the builder's environment to run tests
FROM builder AS tester
# If the tests fail, the Docker build process crashes here
RUN go test -v ./...


# --- STAGE 3: Final Production ---
# We start fresh with Distroless for maximum security and tiny size
FROM gcr.io/distroless/static-debian11
WORKDIR /
# Grab only the compiled binary from the BUILDER stage
# (The tester stage is completely discarded)
COPY --from=builder /my-app /my-app

USER nonroot:nonroot
CMD ["/my-app"]
```