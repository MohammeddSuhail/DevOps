# Understanding Serverless (The Concept)
Before looking at Azure Functions, you have to understand **Serverless Computing**. It is a cloud-hosting model where the cloud provider (Azure) manages the machine resources entirely.

* **Abstraction of Infrastructure:** There are still servers, but you never see them. You don't manage the OS, CPU, or memory.
* **Scale-to-Zero:** This is the "magic" of serverless. If no one is using your code, nothing is running.
* **Micro-Billing:** You are only billed for the exact milliseconds your code is active. If it doesn't run, it costs $0.


---
# 2. Azure Functions (The Service)
**Azure Functions** is the specific Azure service (a "Function-as-a-Service" or FaaS) that lets you implement the serverless concept.

### The "On-the-Fly" Lifecycle
This is the mechanical core of how serverless works:

1.  **The Trigger:** An event happens (e.g., a file is uploaded to storage).
2.  **On-the-Fly Allocation:** The **Scale Controller** (the brain) instantly spins up a lightweight VM or container to run your code.
3.  **Execution:** Your code runs, finishes its task, and sends a result.
4.  **Auto-Deletion:** Once finished, Azure **wipes the VM**. It no longer exists until the next trigger wakes it up again.



### 3. Critical Constraints
* **Cold Start:** The boot-up delay for the first request after an idle period.
* **Stateless:** Local storage is temporary; all data must be saved to external databases/storage.
* **Events & Bindings:** Functions only "wake up" due to Triggers (HTTP, Timer, etc.) and use Bindings to connect to data without extra code.