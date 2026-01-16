# Simple Guide: Azure Storage Accounts

If you plan on storing any data in Azure—whether it's a simple file, a database backup, or a website image—you **must** first create an Azure Storage Account. It is the "foundation" for all your data needs.



### What is it?
Think of an Azure Storage Account as a **secure digital container** for your data. It gives your files a unique address so they can be accessed safely from anywhere in the world using a web link (HTTP/HTTPS).


### Key Rules
* **Resource Groups**: Like any other Azure resource, a Storage Account **must** live inside a Resource Group. You cannot create one without it.
* **Unique Name**: The name you give your Storage Account must be unique across the *entire world* because it becomes part of your web URL.
* **All-in-One**: One single account can hold different types of data (files, images, or messages) all at the same time.

---

## 1. Core Storage Services
Inside a single storage account, you can use one or all of the following services:

| Service | Best For | Technical Description |
| :--- | :--- | :--- |
| **Azure Blobs** | Unstructured Data | Optimized for massive amounts of data like images, videos, documents, or log files. The cloud equivalent of a file system for applications. |
| **Azure Files** | Cloud File Shares | Fully managed file shares accessible via **SMB** or **NFS** protocols. Allows "mounting" a drive in the cloud like a local network share. |
| **Azure Queues** | App Messaging | A messaging store for reliable communication between application parts (e.g., Web front-end to back-end worker). |
| **Azure Tables** | NoSQL Data | Ideal for semi-structured data that doesn't require complex joins or foreign keys, such as user profiles or address books. |

---

## 2. Key Tiers & Redundancy

### **Performance Tiers**
* **Standard**: Backed by magnetic hard drives (HDD); best for general workloads.
* **Premium**: Backed by solid-state drives (SSD); best for low-latency/high-performance.

### **Replication (Durability)**

* **LRS**: Locally-redundant storage (3 copies in 1 data center).
* **ZRS**: Zone-redundant storage (Copies across 3 availability zones).
* **GRS**: Geo-redundant storage (Replicated to a secondary region).

---

> [!TIP]
> **Use Case Reminder**: Use **Azure Files** if you need to lift-and-shift a legacy app that expects a file server. Use **Azure Blobs** if you are building a modern cloud-native app that needs to store high volumes of media or logs.