# Setting Up Nginx Web Server on RHEL

## Step 1: Install Nginx
Install Nginx using the package manager:
```bash
sudo dnf install -y nginx
```
This installs Nginx along with its dependencies.

## Step 2: Start and Enable Nginx Service
Start Nginx immediately and enable it to start on boot:
```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Step 3: Adjust Firewall Rules (If Enabled)
Allow HTTP and HTTPS traffic through the firewall:
```bash
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## Step 4: Verify Nginx is Running
Check if Nginx is running and listening on port 80:
```bash
sudo systemctl status nginx
sudo ss -tulnp | grep nginx
```

## Step 5: Test Nginx Web Server
Find the server’s IP address:
```bash
ip a | grep inet
```
Open a web browser and visit:
```
http://<your-server-ip>
```
You should see the default Nginx welcome page.

## Step 6: Modify Default Web Page
Edit the default Nginx HTML page:
```bash
sudo vi /usr/share/nginx/html/index.html
```
Add the following content:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to My Nginx Server</title>
</head>
<body>
    <h1>Success! Nginx is running.</h1>
</body>
</html>
```
Restart Nginx to apply changes:
```bash
sudo systemctl restart nginx
```

## Step 7: Configure a Custom Website
Create a new website directory:
```bash
sudo mkdir -p /var/www/mywebsite
sudo chown -R nginx:nginx /var/www/mywebsite
sudo chmod -R 755 /var/www/mywebsite
```
Create an Nginx configuration file:
```bash
sudo vi /etc/nginx/conf.d/mywebsite.conf
```
Add this configuration:
```nginx
server {
    listen 80;
    server_name mywebsite.com;

    root /var/www/mywebsite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
```
Restart Nginx:
```bash
sudo systemctl restart nginx
```

## Step 8: Enable HTTPS with SSL (Optional)
Install Certbot for SSL setup:
```bash
sudo dnf install -y certbot python3-certbot-nginx
```
Generate and apply an SSL certificate:
```bash
sudo certbot --nginx -d mywebsite.com -d www.mywebsite.com
```

## Additional Commands
- Check logs:
```bash
sudo journalctl -u nginx --no-pager | tail -n 20
```
- Stop Nginx:
```bash
sudo systemctl stop nginx
```
- Restart Nginx:
```bash
sudo systemctl restart nginx
```

This setup ensures a secure and efficient Nginx web server on RHEL.

