# PostgreSQL Installation Guide on Rocky Linux 8

## Step 1: Update System
```bash
sudo dnf update -y
```
- Ensures the system has the latest security patches and package updates.

## Step 2: Enable PostgreSQL Module
```bash
dnf module list postgresql
```
- Lists available PostgreSQL versions.
```bash
sudo dnf module enable postgresql:15 -y
```
- Enables PostgreSQL 15 (or the latest available version).

## Step 3: Install PostgreSQL
```bash
sudo dnf install postgresql-server postgresql-contrib -y
```
- Installs PostgreSQL server and additional utilities.

## Step 4: Initialize the Database
```bash
sudo postgresql-setup --initdb
```
- Initializes PostgreSQL database storage under `/var/lib/pgsql/data`.

## Step 5: Start and Enable PostgreSQL
```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```
- Starts the PostgreSQL service and enables it to start on boot.

## Step 6: Configure Authentication
```bash
sudo nano /var/lib/pgsql/data/pg_hba.conf
```
- Edit the authentication file.
- Change `peer` and `ident` to `md5` for password authentication:
```plaintext
local   all             all                                     md5
host    all             all             127.0.0.1/32            md5
host    all             all             ::1/128                 md5
```
```bash
sudo systemctl restart postgresql
```
- Applies authentication changes.

## Step 7: Set PostgreSQL Password
```bash
sudo -i -u postgres
psql
ALTER USER postgres WITH PASSWORD 'your-secure-password';
\q
exit
```
- Sets a secure password for the PostgreSQL user.

## Step 8: Enable Remote Connections (Optional)
```bash
sudo nano /var/lib/pgsql/data/postgresql.conf
```
- Change:
```plaintext
#listen_addresses = 'localhost'
```
- To:
```plaintext
listen_addresses = '*'
```
```bash
sudo nano /var/lib/pgsql/data/pg_hba.conf
```
- Add:
```plaintext
host    all             all             0.0.0.0/0               md5
```
```bash
sudo systemctl restart postgresql
```
- Applies changes for remote access.

## Step 9: Open Firewall for PostgreSQL
```bash
sudo firewall-cmd --add-service=postgresql --permanent
sudo firewall-cmd --reload
```
- Allows PostgreSQL traffic through the firewall.

## Step 10: Create a New Database & User
```bash
sudo -i -u postgres
psql
CREATE DATABASE mydb;
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
\q
exit
```
- Creates a database (`mydb`) and user (`myuser`) with full access.

## Step 11: Verify PostgreSQL Connection
```bash
psql -U postgres -d mydb -h 127.0.0.1 -W
```
- Tests the connection to the database.

## Step 12: Enable PostgreSQL on Boot
```bash
sudo systemctl enable postgresql
```
- Ensures PostgreSQL starts automatically after reboot.

## Troubleshooting
```bash
sudo journalctl -u postgresql --no-pager | tail -20
```
- Check PostgreSQL logs for errors.
```bash
sudo systemctl status postgresql
```
- Verify service status.
```bash
netstat -tulnp | grep 5432
```
- Ensure PostgreSQL is listening on the correct port.

---
Your PostgreSQL server is now fully set up on Rocky Linux 8! 🚀

