# Azure Networking Complete Notes

Azure Networking covers VNET, subnets, NSGs, ASGs, App Gateway, Load Balancer, Firewall, DNS, Route Tables, Peering, and VPN Gateway.

---

## Core Definitions
* **VNET (Virtual Network)**: Your private, isolated network in the Azure cloud. It is the fundamental building block that allows Azure resources to securely communicate with each other, the internet, and on-premises networks.
* **Subnet**: A range of IP addresses in the VNET. You can divide a VNET into multiple subnets for organization and security (e.g., separating Web, App, and Database layers).
* **NSG (Network Security Group)**: A basic "firewall" that contains security rules to allow or deny inbound/outbound traffic at the subnet or NIC (Network Interface) level.
* **ASG (Application Security Group)**: A feature that allows you to group VMs by function (e.g., "Web-Servers") and use that group name in NSG rules instead of managing individual IP addresses.

---

## 1. Virtual Network (VNET) Foundation
**Address Space**: CIDR-defined (10.0.0.0/16 = 65K IPs)  
**Multi-AZ**: Spans all availability zones automatically  
**Purpose**: Private, isolated network for Azure resources  

**VNET Structure:**
```yaml
VNET: 10.0.0.0/16 (65,536 IPs)
├── Subnets carved from VNET CIDR
└── Multi-AZ deployment by default
```

### IPv4 Architecture Breakdown
* **4 Bytes Total**: `(1 byte).(1 byte).(1 byte).(1 byte)`
* **32 Bits Total**: `(8 bits).(8 bits).(8 bits).(8 bits)`
* **Decimal Range**: `(0-255).(0-255).(0-255).(0-255)`
* **Total Address Space**: $256^4$ or $2^{32} \approx 4.29$ billion addresses.

### CIDR & Bit Masking
**CIDR (Classless Inter-Domain Routing)** defines the boundary between the **Network ID** and the **Host ID**.

* **The Rule**: In a 32-bit address, the CIDR number (e.g., `/24`) tells you how many bits are "locked" for the network path. The remaining bits are for your resources.
* **Example /24**:
  * **Locked Bits**: Starting 24 bits (Network ID).
  * **Usable Bits**: $32 - 24 = 8$ bits (Host ID).
  * **Capacity**: $2^8 = 256$ total addresses.

### Azure Networking: The "Reserved 5"
Azure reserves **5 IP addresses** within every subnet. You must subtract these from your total CIDR calculation to find your **Usable IPs**.

1.  **x.x.x.0**: Network Address.
2.  **x.x.x.1**: Default Gateway (for routing).
3.  **x.x.x.2**: Azure DNS (mapped to the VNET space).
4.  **x.x.x.3**: Future Use/Internal Azure redundancy.
5.  **x.x.x.255**: Broadcast Address (Reserved for protocol consistency).

**Calculation Formula**: $2^{(32 - CIDR)} - 5 = \text{Usable IPs}$

### Subnet Planning Reference

| CIDR Mask | Total IPs | Azure Usable IPs | Common Use Case |
| :--- | :--- | :--- | :--- |
| **/24** | 256 | 251 | Standard Workload Subnet |
| **/26** | 64 | 59 | Azure Bastion Subnet |
| **/27** | 32 | 27 | App Gateway (Minimum) |
| **/29** | 8 | 3 | Small Test/DB Subnet |


---

## 2. Subnet Architecture
```yaml
VNET: 10.0.0.0/16
├── App Gateway Subnet: 10.0.1.0/24 (min /27) - L7 Load Balancer
├── Web Subnet: 10.0.2.0/24 (254 IPs) - Frontend apps
├── App Logic Subnet: 10.0.3.0/24 - Backend apps
└── Database Subnet: 10.0.4.0/24 - DB servers
```

**Subnet Rules**:
* Must fit within VNET CIDR
* App Gateway subnet: minimum /27 (32 IPs)
* First/Last IP reserved (network ID, broadcast)

---

## 3. Load Balancers Complete

| Service | OSI Layer | Use Case | Deployment Location |
| :--- | :--- | :--- | :--- |
| **App Gateway** | L7 (HTTP/S) | URL path routing (`/login` → login pool) | App Gateway subnet |
| **Azure Load Balancer** | L4 (TCP/UDP) | Backend instance balancing | Within app subnets |

---
## 4. Firewall & Security Controls
- Azure Firewall (VNET perimeter)
- NSGs (subnet level) 
- ASGs (application level)

The layered security model represents defense-in-depth for Azure networking, with each layer providing progressive traffic filtering:
 - PERIMETER LAYER: Azure Firewall (VNET boundary)
 - SUBNET LAYER: NSG (priority rules 100-4096)
 - INSTANCE LAYER: NSG on NICs
 - APPLICATION LAYER: ASG (dynamic VM grouping)

**NSG Example Rules**:
```yaml
Priority 100: Allow HTTP/443 Internet → Web subnet
Priority 200: Allow TCP 8080 Web → App Logic  
Priority 300: Deny All Inbound → Web subnet
Priority 400: Allow TCP 1433 App Logic → DB subnet
```

## 5. Route Tables & Routing

**System Routes (Default):**
* **Intra-Subnet**: Direct communication
* **VNET-Internal**: Via VNET backbone
* **Internet**: Via Azure Internet Gateway

**User-Defined Routes (UDR):**
```yaml
Next Hop Types:
├── Virtual Appliance (Firewall/NVA)
├── VNET Gateway (VPN/Peering)
├── Internet Gateway
└── None (Drop/Blackhole)
```

## 6. Complete Traffic Flow
* **User**: abh.com → ISP DNS → Azure DNS → App Gateway IP (3.4.5.6)
* **Azure Firewall** ✓ (VNET perimeter)
* **App Gateway (L7)**: /login → Web Subnet pool (AZ1+AZ2) [NSG ✓]
* **Web Apps** → Internal L4 Load Balancer → App Logic [NSG ✓]
* **App Logic** → Database Subnet [NSG ✓]

## 7. DNS Resolution Flow
* **Domain**: abh.com (Azure DNS Zone)
* **A Record**: App Gateway Public IP (3.4.5.6)
* **Flow**: User → ISP DNS → Azure DNS → Firewall → App Gateway

## 8. Network Connectivity Options

### A. VNET Peering (Direct Routing)
* **What it is**: A configuration that merges two Azure VNETs into one logical network.
* **When to use**: **Azure-to-Azure** connections. To connect resources in different VNETs (e.g., Sales VNET to Billing VNET). Best for low-latency, high-speed communication between VNETs.
* **Does it need a Gateway?**: **No**. It uses the Azure Backbone routing directly.
* **Key Benefit**: Cheapest and fastest way to connect Azure resources.

### B. Virtual Network Gateway (The "Bridge" Resource)
* **What it is**: A managed VM (Gateway) deployed into a dedicated subnet called `GatewaySubnet`. It acts as the "entry point" for external connections.
* **Types of VNET Gateways**:
    1. **VPN Gateway**: 
       * **Use**: Connects On-Premises to Azure over the **Public Internet** (encrypted).
       * **Scenario**: Small/Medium business hybrid setup or remote workers (P2S).
    2. **ExpressRoute Gateway**: 
       * **Use**: Connects On-Premises to Azure via a **Private Dedicated Circuit** (no internet).
       * **Scenario**: Enterprise-grade security, high-speed requirements, and compliance.

---

### Comparison: Peering vs. Gateway
| Feature | VNET Peering | Virtual Network Gateway |
| :--- | :--- | :--- |
| **Connection Type** | VNET ↔ VNET | On-Prem ↔ VNET |
| **Path** | Microsoft Backbone | Internet (VPN) or Private Circuit (ER) |
| **Complexity** | Low (Instant setup) | High (Requires GatewaySubnet & IPs) |
| **Cost** | Data Transfer only | Hourly Gateway Fee + Data |


## 9. Additional Critical Components
* **WAF (Web Application Firewall)**: Layer 7 protection on App Gateway; Blocks SQL injection, XSS, malicious patterns.
* **Billing Components**: Charged Resources include Azure Firewall, App Gateway, Load Balancer, and Data Transfer (egress).

## 10. Inbound Connection Architecture Reference Diagram

```yaml
Internet
      ↓
DNS Resolution
      ↓
Azure Firewall (VNET Perimeter)
      ↓
App Gateway Subnet (L7 Load Balancer) → URL Path Routing ("/login")
      ↓
Web Subnet [NSG]
      ↓
Internal L4 Load Balancer
      ↓
App Logic Subnet [NSG]
      ↓
Database Subnet [NSG]
```

## Key Relationships Summary

| Component | Controls | Protects | Routes To |
| :--- | :--- | :--- | :--- |
| **VNET** | CIDR Space | All Resources | Subnets |
| **Subnet** | Subnet CIDR | IP Allocation | NSG/RT |
| **NSG** | Priority Rules | Subnet/NIC Traffic | Allow/Deny |
| **ASG** | VM Grouping | App Workloads | Dynamic Security |
| **App Gateway** | L7 Rules | Web Traffic | Web Subnet |
| **Load Balancer** | L4 Rules | Backend Instances | App Logic Subnet |

**All components interconnect for secure, scalable 3-tier architecture.**



## 11. NAT Gateway: The "Outbound" Traffic Flow

When a private resource (like an App Server) needs to reach the internet (e.g., for patches or API calls), it follows this specific path:

1.  **Request Initiation**: 
    * **App Server (App Logic Subnet)** says: *"I need to download an update from linux-patches.com."*
2.  **Route Table (UDR)**: 
    * The subnet identifies the request is destined for the internet. If a NAT Gateway is associated with the subnet, the traffic is automatically directed there.
3.  **NAT Gateway**: 
    * The Gateway receives the private packet and "masks" it. It assigns its **Static Public IP** to the request and sends it out to the Public Internet.
4.  **Internet Response**: 
    * The destination server (linux-patches.com) sees the request coming from a trusted, static IP and allows the download.

---

### Why use NAT Gateway for Outbound?

| Feature | NAT Gateway | Azure Firewall (Outbound) |
| :--- | :--- | :--- |
| **Primary Goal** | Scalable Outbound Connectivity | Security & Filtering |
| **IP Address** | **Static Public IP** (Fixed) | Public IP of the Firewall |
| **Performance** | Extremely high (best for SNAT) | High, but adds inspection latency |
| **Best For** | Downloading patches, API calls | Filtering traffic by Domain/URL |






## Azure Routing Reference: System vs. User-Defined Routes (UDR)

Azure routing is the "GPS" of your network. Traffic flow is determined by a combination of invisible **System Routes** and manually configured **User-Defined Routes (UDRs)**.

### Part 1: The System Default Routes (The "Invisible" Logic)
Azure automatically creates and assigns a system route table to every subnet. These are immutable—you cannot delete them—but they can be overridden by UDRs.

| Destination Prefix | Next Hop Type | Logic / Behavior |
| :--- | :--- | :--- |
| **Local VNet** (e.g., `10.0.0.0/16`) | **Virtual Network** | Enables direct communication between all subnets within the same VNet. |
| **0.0.0.0/0** | **Internet** | Default "exit ramp" for all outbound traffic not destined for a private range. |
| **Peered VNet** | **VNet Peering** | Automatically added upon peering to allow private traffic between different VNets. |
| **RFC 1918 Ranges** | **None** | Prevents internal traffic from leaking to the public internet by dropping it if no specific route exists. |

---

### Part 2: User-Defined Routes (UDR) (The "Manual" Logic)
UDRs allow you to force traffic through specific security or connectivity appliances. A UDR associated with a subnet will **always** override a System Route for the same prefix.

#### Common Next Hop Types for UDRs:
* **Virtual Appliance**: Directs traffic to the private IP of a firewall (e.g., Azure Firewall) or an NVA for inspection.
* **Internet**: Explicitly bypasses firewalls to use Azure's direct internet backbone.
* **Virtual Network Gateway**: Directs traffic to an on-premises site via VPN or ExpressRoute.
* **None**: Acting as a "Black Hole," this route drops any traffic destined for the specified prefix (useful for security isolation).

---

### Part 3: Selection Priority (The "Tie-Breaker")
If multiple routes match a destination, Azure selects the path based on these rules:
1.  **Longest Prefix Match (LPM)**: The most specific CIDR range always wins (e.g., `/24` is chosen over `/16`).
2.  **Hierarchy**: If prefixes are identical, the winner is decided by:
    * **1st: User-Defined Route (UDR)**
    * **2nd: BGP Routes** (via VPN/ExpressRoute)
    * **3rd: System Routes** (Default)

> [!TIP]
> **Verification**: You cannot see the "System Route Table" object in the portal. To see the actual routes being used by a VM, navigate to: 
> **VM -> Networking -> Network Interface -> Effective Routes**.