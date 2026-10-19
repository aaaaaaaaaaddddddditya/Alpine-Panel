# Installation Guide

## Prerequisites
- Ubuntu/Debian 20.04+
- Root or sudo access
- Internet connection

## Method 1: Automated Installation (Recommended)

```bash
# Download installer
git clone https://github.com/aaaaaaaaaaddddddditya/Alpine-Panel.git
cd Alpine-Panel

# Run installer
sudo bash install.sh
```

**Installation takes 3-5 minutes and will:**
- Update system
- Install PHP 8, Nginx, MySQL, Docker
- Setup database
- Configure services
- Start everything automatically

Access: `http://localhost`

## Method 2: Docker Compose

```bash
git clone https://github.com/aaaaaaaaaaddddddditya/Alpine-Panel.git
cd Alpine-Panel

docker-compose up -d
```

Access: `http://localhost`

## Method 3: Manual Installation

```bash
# Install dependencies
sudo apt-get update
sudo apt-get install -y php-fpm nginx mysql-server docker.io git

# Clone repository
git clone https://github.com/aaaaaaaaaaddddddditya/Alpine-Panel.git
cd Alpine-Panel

# Setup database
sudo mysql < database-schema.sql

# Copy environment file
cp .env.example .env

# Set permissions
sudo chown -R www-data:www-data .
sudo chmod -R 755 public storage

# Start services
sudo service mysql start
sudo service php-fpm start
sudo service nginx restart
```

## After Installation

1. Access: `http://localhost` or `http://your-domain.com`
2. Login with:
   - Email: `admin@alpine-panel.local`
   - Password: `admin123`
3. **Change password immediately!**

## Cloudflare Setup

1. Point domain DNS to Cloudflare
2. In Cloudflare DNS, add A record:
   - Name: your-domain.com
   - IPv4: Your server IP
   - Proxy: Proxied

## Troubleshooting

**Port 80 already in use:**
```bash
sudo fuser -k 80/tcp
```

**MySQL connection error:**
```bash
sudo service mysql restart
```

**Permission issues:**
```bash
sudo chown -R www-data:www-data /opt/alpine-panel
```

## Support

For issues, check installation logs or create an issue on GitHub.
