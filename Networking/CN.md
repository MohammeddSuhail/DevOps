# 🌐 Internet & Networking Fundamentals

## 📜 History of the Internet

- Started as **ARPANET** in the U.S., used **TCP/IP** protocol.
- Hyperlinks and document sharing led to the invention of the **World Wide Web (WWW)**.
- Documents are accessed via **URLs**.
- Initially, there were **no search engines**, so they were later created to help navigate the web.
- To standardize communication, protocols were created and governed by the **Internet Society**.

---

## 📡 Internet Structure

### Basic Flow

```
ISP
 |
Modem/Router (global IP)
 |—— Device 1
 |—— Device 2   (local IPs via DHCP)
```

- Devices get **local IPs** via **DHCP**.
- When a device sends a request (e.g., google.com), the **router** uses **NAT (Network Address Translation)** to map internal device IPs to the public IP and track responses.

---

## 📦 Protocols Overview

### 📶 Transport Layer Protocols

| Protocol | Type | Purpose | Example Use |
|----------|------|---------|-------------|
| **TCP** (Transmission Control Protocol) | Connection-Oriented | Reliable, ordered, error-checked | HTTP, FTP, SMTP |
| **UDP** (User Datagram Protocol) | Connectionless | Faster, unordered, best-effort | DNS, VoIP, video streaming |

### 🌐 Application Layer Protocols (Use TCP/UDP)

| Protocol | Transport | Port(s) | Purpose |
|----------|-----------|---------|---------|
| **HTTP** | TCP | 80 | Web browsing (stateless) |
| **HTTPS** | TCP | 443 | Secure web browsing |
| **FTP** | TCP | 20/21 | File transfer |
| **SSH** | TCP | 22 | Remote login |
| **Telnet** | TCP | 23 | Remote terminal |
| **SMTP** | TCP | 25 | Sending email |
| **DNS** | UDP/TCP | 53 | Domain name resolution |
| **DHCP** | UDP | 67/68 | IP address allocation |
| **POP3** | TCP | 110 | Email receiving |
| **NTP** | UDP | 123 | Time sync |
| **TFTP** | UDP | 69 | Simplified file transfer |
| **RIP** | UDP | 520 | Routing protocol |

---

## 🧠 OSI Model (Theoretical)

1. **Application Layer** — User-facing: Browsers, Email Clients
2. **Presentation Layer** — Encryption, Decryption, Compression
3. **Session Layer** — Session management, Authentication
4. **Transport Layer** — TCP/UDP, segmentation, ports
5. **Network Layer** — IP addressing, Routing, Fragmentation
6. **Data Link Layer** — MAC address, Frames, CRC, Flow control
7. **Physical Layer** — Bits to signals, actual transmission

---

## 📦 TCP/IP Model (Practical)

1. **Application Layer** — HTTP, FTP, SMTP, DNS, etc.
2. **Transport Layer** — TCP/UDP, ports
3. **Internet Layer** — IP, ICMP, ARP
4. **Network Access Layer** — Ethernet, MAC, cables

---

## 🔄 How Layers Interact (Example: Opening https://example.com)

```
[Application Layer]  →  HTTP (GET /)
[Transport Layer]    →  TCP (Port 443)
[Internet Layer]     →  IP (source IP → destination IP)
[Network Access]     →  MAC + Signals over medium
```

- Application protocols (HTTP, FTP, etc.) sit at the top and **use Transport Layer protocols** (TCP/UDP) to send and receive data.
- Transport Layer ensures **reliable or fast delivery** (depending on protocol).
- Internet Layer routes the data based on **IP addresses**.
- Network Layer handles local delivery based on **MAC addresses**.

---

## 🛰️ IP Addressing

### IPv4

- 32-bit dotted format: `192.168.1.1`
- Classes:
  - **Class A**: 0xxxxxxx (1–126) → Large networks
  - **Class B**: 10xxxxxx (128–191)
  - **Class C**: 110xxxxx (192–223)
  - **Class D**: Multicast
  - **Class E**: Experimental
- Issues: Limited IPs → CIDR introduced

### CIDR & Subnetting

- Example: `200.10.20.40/28` → 28 bits for network, 4 bits for host
- Subnetting: `Network ID + Subnet ID + Host ID`
- VLSM allows variable-sized subnets

### IPv6

- 128-bit, written in hexadecimal
- Example: `2001:0db8:85a3:0000:0000:8a2e:0370:7334`

---

## 🔁 ARP & NAT

### ARP (Address Resolution Protocol)

- Resolves IP → MAC on LAN
- Broadcasts for MAC associated with a given IP

### NAT (Network Address Translation)

- Maps private IPs to public IP
- Allows multiple internal devices to share one external IP

---

## 📬 How Email Works

| Function | Protocol | Port |
|----------|----------|------|
| Send     | SMTP     | 25   |
| Receive  | POP3     | 110  |
| Receive (sync) | IMAP | 143  |

---

## 🔐 VPN

- VPN (Virtual Private Network) creates an **encrypted tunnel** over the public internet.
- Used to **secure data** and **hide your real IP**.

---

## 🌐 HTTP Basics

### HTTP Methods

- `GET` – Fetch resource
- `POST` – Send data
- `PUT` – Update data
- `DELETE` – Delete data

### Status Codes

- `1XX` – Info
- `2XX` – Success
- `3XX` – Redirect
- `4XX` – Client Error
- `5XX` – Server Error

---

## 🍪 Cookies in HTTP

- HTTP is **stateless**, so websites use **cookies** to remember users.
- Stored by the browser, sent with every request to the domain.

---

## 🛠️ Devices & Networking Layers

| Device   | OSI Layer | Function |
|----------|-----------|----------|
| Repeater | Physical  | Amplifies signal |
| Hub      | Physical  | Broadcasts to all |
| Bridge   | Data Link | Connects LANs |
| Switch   | Data Link | Filters by MAC |
| Router   | Network   | Routes IP packets |
| Gateway  | All       | Protocol translation |
| Modem    | Physical  | Digital ↔ Analog |

---

## 📶 Types of Networks

| Type | Range      | Tech Used        |
|------|------------|------------------|
| PAN  | Personal   | Bluetooth        |
| LAN  | Building   | Ethernet, Wi-Fi  |
| MAN  | City-wide  | FDDI, ATM        |
| WAN  | Global     | Fiber, Satellite |

---

## 🛰️ Routing & Protocols

| Type   | Description | Example |
|--------|-------------|---------|
| Static | Manual      | Admin sets |
| Dynamic| Auto        | RIP, OSPF, BGP |

### Routing Protocols

- **RIP**: Distance vector (hop count)
- **OSPF**: Link-state (best path)
- **BGP**: Inter-AS routing (used between ISPs)

---

## 🔢 Ephemeral Ports

- Temporary client-side ports
- Range: `49152–65535`

---

## 🧪 Useful Commands

```bash
# Check your public IP
curl ifconfig.me -s
```

---




## 🔢 Port Number Ranges Explained

### 📌 Port Categories:

| **Port Range**     | **Name**                            | **Description**                                                                 |
|--------------------|-------------------------------------|---------------------------------------------------------------------------------|
| `0–1023`           | **Well-known Ports**                | Assigned by IANA for core services like HTTP (`80`), FTP (`21`), SSH (`22`).   |
| `1024–49151`       | **Registered Ports**                | Registered with IANA by vendors (e.g., MySQL `3306`, MSSQL `1433`). Many remain unassigned and can be used. |
| `49152–65535`      | **Dynamic / Private / Ephemeral Ports** | Used for temporary client-side connections (e.g., browsers, random app ports). |

---

### ✅ Can I Use Ports in the Registered Range (1024–49151)?

Yes, you **can use unassigned ports** in this range.

- Only a **subset** of these ports are officially registered by software vendors.
- The rest are **free to use** for custom/internal apps or services.
- Example: Port `7185` is not officially assigned by IANA and is safe to use.

---

### ❗ Important Notes:

- Avoid using **assigned ports** that belong to popular services unless you're implementing those services.
- To prevent conflicts, **check if a port is already in use** on your system using:

```bash
netstat -tuln
