# 🎞️ RHEL 8 Package Management & Updates - Complete Guide

A complete guide for understanding and managing packages in **Red Hat Enterprise Linux 8**.

---

## 🧰 What Are Packages?

**Packages** are bundles of software that include:
- Executable binaries
- Configuration files
- Documentation
- Dependencies

In RHEL, packages have the `.rpm` (Red Hat Package Manager) format.

---

## 🛠️ Package Management Tools in RHEL 8

### 1. `dnf` - High-level package manager
- Replaces `yum`
- Handles installations, updates, and dependencies
- Supports repository management and module streams

### 2. `rpm` - Low-level package tool
- Used to query, verify, or manually install `.rpm` files
- Doesn’t resolve dependencies

---

## 🔄 DNF vs RPM

| Feature                  | `dnf`                          | `rpm`                          |
|--------------------------|--------------------------------|--------------------------------|
| Dependency resolution    | ✅ Yes                         | ❌ No                          |
| Install software         | ✅ Yes                         | ✅ (manual only)              |
| Repositories supported   | ✅ Yes                         | ❌ No                          |
| Query installed packages | ✅ Yes                         | ✅ Yes                         |
| Update packages          | ✅ Yes                         | ❌ No                          |

---

## 🌟 Common Use Cases and Commands

### ✅ Install Software

```bash
sudo dnf install <package-name>
```
> Example: `sudo dnf install httpd`

---

### 🔎 Search Available Packages

```bash
dnf search <package-name>
```
> Example: `dnf search nginx`

---

### 📋 List Installed Packages

```bash
dnf list installed
```
Filter a specific package:
```bash
dnf list installed | grep nginx
```
With RPM:
```bash
rpm -qa
rpm -q nginx
```

---

### 📄 Get Package Info

```bash
dnf info <package-name>
```
> Shows version, summary, repo, architecture, etc.

---

### 🔄 Update Packages

Update specific:
```bash
sudo dnf update <package-name>
```
Update all:
```bash
sudo dnf update
```

---

### ❌ Remove a Package

```bash
sudo dnf remove <package-name>
```
> Example: `sudo dnf remove nginx`

---

### 📦 Install Local `.rpm` Files

Manual (no dependency check):
```bash
sudo rpm -ivh package.rpm
```
With DNF (dependency aware):
```bash
sudo dnf install ./package.rpm
```

---

### 🔁 Reinstall a Package

```bash
sudo dnf reinstall <package-name>
```

---

## 📁 Repository Management

### List Enabled Repos

```bash
dnf repolist
```

---

### Add Custom Repo

Create `/etc/yum.repos.d/myrepo.repo`:
```ini
[myrepo]
name=My Custom Repo
baseurl=http://example.com/repo/
enabled=1
gpgcheck=0
```

---

### Clean Cache

```bash
dnf clean all
dnf makecache
```

---

## 📦 RPM Commands (Low-Level)

Install `.rpm` manually:
```bash
sudo rpm -ivh package.rpm
```
Remove:
```bash
sudo rpm -e package-name
```
Query installed:
```bash
rpm -q package-name
rpm -qa
```
Check signature:
```bash
rpm --checksig package.rpm
```
Rebuild RPM DB:
```bash
rpm --rebuilddb
```

---

## 📦 `dnf download` – Download Without Installing

Use this when you want to **download an RPM** (and optionally dependencies) without installing.

### 🔽 Download a Package

```bash
dnf download <package-name>
```
> Example: `dnf download nginx`

### 🔗 Download with Dependencies

```bash
dnf download --resolve <package-name>
```
> Example: `dnf download --resolve httpd`

### 📌 Download a Specific Version

```bash
dnf download <package-name>-<version>
```
> Example: `dnf download bash-5.0.17`

### 📂 Change Destination Folder

```bash
dnf download --destdir=/tmp/myrpms <package-name>
```

### ⚠️ Required Plugin

Ensure plugin is installed:
```bash
sudo dnf install dnf-plugins-core
```

---

## 📦 DNF Modules & AppStreams (RHEL 8 Feature)

Modules allow multiple versions of software.

### List Available Modules

```bash
dnf module list
```

### Enable a Specific Stream

```bash
sudo dnf module enable nodejs:18
```

### Install the Module

```bash
sudo dnf install nodejs
```

### Reset a Module

```bash
sudo dnf module reset <module-name>
```

---

## 🤖 Automating Updates

Install `dnf-automatic`:
```bash
sudo dnf install dnf-automatic
```

Configure:
```bash
sudo vi /etc/dnf/automatic.conf
```

Enable and start:
```bash
sudo systemctl enable --now dnf-automatic.timer
```

---

## 🛠️ Troubleshooting

| Issue                         | Command                                  |
|------------------------------|------------------------------------------|
| Unsatisfied dependencies     | `dnf repoquery --unsatisfied`           |
| Broken RPM database          | `rpm --rebuilddb`                       |
| Clean package metadata       | `dnf clean all && dnf makecache`        |
| Force remove broken package  | `rpm -e --nodeps <package-name>`        |

---

## 📁 Summary: Common DNF Commands

| Task                       | Command                                       |
|----------------------------|-----------------------------------------------|
| Search package             | `dnf search <pkg>`                            |
| Install package            | `dnf install <pkg>`                           |
| Remove package             | `dnf remove <pkg>`                            |
| Update all packages        | `dnf update`                                  |
| List installed packages    | `dnf list installed`                          |
| Show package info          | `dnf info <pkg>`                              |
| Enable repo/module stream  | `dnf module enable <mod>:<stream>`           |
| List all modules           | `dnf module list`                             |
| Install from repo          | `dnf install ./package.rpm`                  |
| Automate updates           | `dnf-automatic` + `systemctl enable`         |

---

## 🔪 Practice Exercises

1. Install and verify `wget` and `tree`.
2. Search and install the latest version of `git`.
3. List all installed packages with `dnf` and `rpm`.
4. Enable and install `python38` using DNF module streams.
5. Set up `dnf-automatic` for unattended updates.

---

## 📘 Compatibility with Other OS

### Works on:
- RHEL 8 / 9
- Rocky Linux
- AlmaLinux
- Oracle Linux
- CentOS Stream
- Fedora
- Amazon Linux 2/2023 (with `dnf`)

### Doesn’t Work on:
- Ubuntu / Debian / Mint — use `apt`
- openSUSE — uses `zypper` (though it supports `.rpm`, the tools differ)

### Check OS Compatibility
```bash
cat /etc/os-release
```

---

## 📘 References

- [Red Hat DNF Documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/package_management/index)
- `man dnf`
- `man rpm`

---

Now you're ready to manage packages in RHEL 8 and compatible distros like a pro! 🚀
