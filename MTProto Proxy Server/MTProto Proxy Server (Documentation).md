# Telegram MTProto Proxy Server

This repository documents how to deploy a **Telegram MTProto Proxy** using **Docker on Ubuntu**.

The proxy allows Telegram users to connect when direct access to Telegram is restricted.

⚠️ This proxy **only works for Telegram** and does not provide full internet access.

---

# Server Environment

Cloud Provider: Google Cloud  
Region: Netherlands / Europe  
OS: Ubuntu 22.04 Minimal  
Container Runtime: Docker  
Protocol: MTProto  
Default Port: 443

---

# Requirements

Before starting you need:

- A Linux server (Ubuntu recommended)
- Public IPv4 address
- SSH access
- Docker installed
- TCP port **443** open in the firewall

---

# Step 1 – Connect to the Server

Connect to the server using SSH:

```bash
ssh username@your_server_ip
```

Example:

```bash
ssh ubuntu@34.xxx.xxx.xxx
```

---

# Step 2 – Update the System

Update package lists and upgrade packages:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
```

---

# Step 3 – Install Docker

Install Docker:

```bash
sudo apt install docker.io -y
```

Enable and start Docker:

```bash
sudo systemctl enable docker
sudo systemctl start docker
```

Verify installation:

```bash
sudo docker --version
```

---

# Step 4 – Generate a Secret Key

MTProto requires a **secret key** for authentication.

Generate a secret:

```bash
openssl rand -hex 16
```

Example output:

```
a4f9c1e8b2d7f41a8a3c91b4c02a9d3c
```

Save this key because users will need it to connect.

---

# Step 5 – Run MTProto Proxy in Docker

Start the MTProto proxy container:

```bash
sudo docker run -d \
  --name mtproxy \
  --restart unless-stopped \
  -p 443:443 \
  -e SECRET=YOUR_SECRET_KEY \
  telegrammessenger/proxy
```

Replace `YOUR_SECRET_KEY` with the secret generated earlier.

---

# Step 6 – Verify the Container

Check running containers:

```bash
sudo docker ps
```

Expected output example:

```
CONTAINER ID   IMAGE                    STATUS
xxxxxx         telegrammessenger/proxy  Up
```

---

# Step 7 – Verify Port 443

Check that the proxy is listening on port 443:

```bash
sudo ss -tulnp | grep 443
```

Expected result:

```
0.0.0.0:443
```

---

# Step 8 – Firewall Configuration

Ensure TCP port **443** is open.

Example if using UFW:

```bash
sudo ufw allow 443/tcp
```

For cloud providers (Google Cloud, AWS, etc.) also open port **443** in the network firewall rules.

---

# Connecting from Telegram

Users need the following information:

Server IP:

```
YOUR_PUBLIC_IP
```

Port:

```
443
```

Secret:

```
YOUR_SECRET_KEY
```

---

# Telegram Desktop Connection Guide

1. Open Telegram
2. Go to **Settings**
3. Select **Advanced**
4. Open **Connection Type**
5. Enable **Use Custom Proxy**
6. Click **Add Proxy**
7. Select **MTProto**

Enter the following:

Host:

```
SERVER_IP
```

Port:

```
443
```

Secret:

```
SECRET_KEY
```

Save and connect.

---

# Monitoring Connections

View active connections:

```bash
sudo ss -tn state established '( sport = :443 )'
```

Count active connections:

```bash
sudo ss -tn state established '( sport = :443 )' | wc -l
```

View logs:

```bash
sudo docker logs mtproxy
```

View logs in real time:

```bash
sudo docker logs -f mtproxy
```

---

# Restarting the Proxy

Restart container:

```bash
sudo docker restart mtproxy
```

Stop container:

```bash
sudo docker stop mtproxy
```

Start container:

```bash
sudo docker start mtproxy
```

---

# Notes

- This proxy is intended for **Telegram access only**
- Do not share the secret publicly if bandwidth is limited
- Each user may open multiple connections
- Monitor traffic to maintain server stability

---

# License

This documentation is provided for educational and personal use.