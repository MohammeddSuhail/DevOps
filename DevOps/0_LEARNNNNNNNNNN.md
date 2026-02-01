# Tier-2 Product Company DevOps Interview Prep
## (Razorpay, PhonePe, Swiggy, Cred, Groww, Meesho)

---

## PART 1: EXACT INTERVIEW QUESTIONS (REAL PATTERNS)

### ROUND 1: DEVOPS / CLOUD TECHNICAL

---

### Linux (Very Common)

You WILL be asked scenario-based questions:

1. A server is slow — how do you debug it?
2. Difference between:
   - Load average vs CPU usage
3. What happens when disk becomes 100% full?
4. How do you find:
   - Top memory-consuming process
   - Open ports on a server
5. What happens when you run `kill -9`?
6. How does Linux handle memory (buffers/cache)?

Follow-up scenarios:
- CPU is low but latency is high — why?
- Disk I/O is high — how do you debug?

---

### Networking (Very Common)

1. What happens when you type `google.com` in a browser?
2. TCP vs UDP
3. DNS resolution flow
4. NAT Gateway vs Internet Gateway
5. L4 vs L7 Load Balancer
6. SSL / TLS handshake

Expectation:
- Clear explanation
- Step-by-step flow
- Real-world understanding

---

### Terraform (Almost Guaranteed)

Real questions asked:

1. What is Terraform state?
2. Where should Terraform state be stored in production?
3. How do you handle multiple environments?
4. What happens if the state file is deleted?
5. Difference between:
   - `count` vs `for_each`
6. How do you manage secrets in Terraform?
7. How do you avoid accidental deletion?
8. What is infrastructure drift?

Expectation:
- Practical usage
- Failure handling
- Team collaboration scenarios

---

### CI/CD

1. Design a CI/CD pipeline for a microservice
2. How do you do zero-downtime deployments?
3. Difference between:
   - Blue-green deployment
   - Canary deployment
4. Rollback strategies
5. Secrets management in pipelines

---

## ROUND 2: SYSTEM DESIGN (MOST IMPORTANT)

Common questions:

1. Design infrastructure for an e-commerce application
2. Design CI/CD for 100+ microservices
3. Design a Kubernetes cluster for high traffic
4. How would you handle:
   - Traffic spikes?
   - Pod crashes?
   - Database failures?
5. How do you ensure high availability?

They evaluate:
- Logical thinking
- Trade-offs
- Cost awareness
- Reliability & scalability

---

## ROUND 3: MANAGER / BAR RAISER

Typical questions:

- Biggest production issue you handled?
- How do you handle on-call pressure?
- What automation did you recently implement?
- How do you ensure system reliability?
- Why do you want to join our company?

This round decides the offer.

---

## PART 2: 30-DAY INTERVIEW PREPARATION PLAN

Time commitment:
- Weekdays: ~2–2.5 hours/day
- Weekends: 5–6 hours/day

---

### WEEK 1: Linux + Networking

**Day 1–2**
- Linux processes
- CPU, memory, disk
- Hands-on commands

**Day 3**
- Networking basics
- TCP/IP, DNS, ports

**Day 4**
- Load balancers
- HTTP vs HTTPS
- SSL handshake

**Day 5**
- Debugging scenarios
- Practice explaining aloud

**Day 6–7 (Weekend)**
- Mock interview questions
- Write answers in your own words

---

### WEEK 2: Terraform + Cloud

**Day 8**
- Terraform state & remote backend

**Day 9**
- Modules, variables, lifecycle rules

**Day 10**
- IAM + networking (AWS/Azure)

**Day 11**
- Infra design using Terraform

**Day 12**
- Failure & rollback scenarios

**Day 13–14 (Weekend)**
- Build infra:
  - VPC / VNet
  - VM
  - Load balancer
  - Security groups
- Explain infra aloud (interview-style)

---

### WEEK 3: Kubernetes + CI/CD

**Day 15**
- Kubernetes architecture

**Day 16**
- Deployments, services, pods

**Day 17**
- HPA, rolling updates

**Day 18**
- CI/CD design patterns

**Day 19**
- Monitoring & logging basics

**Day 20–21 (Weekend)**
- Mock system design
- Explain infra end-to-end

---

### WEEK 4: Interview Readiness

**Day 22–24**
- Revise weak topics
- Rehearse answers verbally

**Day 25–26**
- Mock interviews (record yourself)

**Day 27–28**
- Resume fine-tuning
- STAR stories for manager round

**Day 29–30**
- Apply to companies
- HR calls
- Company-specific prep

---

## PART 3: DSA CONFIRMATION

- ❌ No LeetCode grinding
- ❌ No graphs / DP / trees
- ✅ Basic coding logic only
- ✅ Reading & understanding scripts

DSA-heavy rounds are NOT standard for DevOps/SRE roles.
