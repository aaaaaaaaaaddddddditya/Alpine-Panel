#!/bin/bash

################################################################################
#                    Alpine Cloud Panel - Installer                           #
#                     Fast & Easy Installation                                #
################################################################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║       Alpine Cloud Panel - Minecraft Server Manager         ║
║                  Craft Your World 🏔️                        ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

# Check root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}✗ Run with sudo: sudo bash install.sh${NC}"
   exit 1
fi

# Detect OS
if [ ! -f /etc/os-release ]; then
    echo -e "${RED}✗ Unsupported OS${NC}"
    exit 1
fi

. /etc/os-release
if [[ "$ID" != "ubuntu" && "$ID" != "debian" ]]; then
    echo -e "${RED}✗ Ubuntu/Debian only${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 System: $ID $VERSION_ID${NC}\n"

# Step 1: Update system
echo -e "${YELLOW}[1/7] Updating system packages...${NC}"
apt-get update -qq && apt-get upgrade -y -qq > /dev/null 2>&1
echo -e "${GREEN}✓ System updated${NC}\n"

# Step 2: Install dependencies
echo -e "${YELLOW}[2/7] Installing dependencies (PHP, Nginx, MySQL, Docker)...${NC}"
PACKAGES="php-fpm php-mysql php-curl php-json php-gd php-xml php-mbstring php-zip \
          nginx mysql-server docker.io docker-compose git curl wget"
apt-get install -y -qq $PACKAGES > /dev/null 2>&1
echo -e "${GREEN}✓ Dependencies installed${NC}\n"

# Step 3: Clone from GitHub
echo -e "${YELLOW}[3/7] Cloning Alpine Panel from GitHub...${NC}"
if [ -d /opt/alpine-panel ]; then
    rm -rf /opt/alpine-panel
fi
git clone https://github.com/aaaaaaaaaaddddddditya/Alpine-Panel.git /opt/alpine-panel > /dev/null 2>&1
cd /opt/alpine-panel
echo -e "${GREEN}✓ Repository cloned${NC}\n"

# Step 4: Create directories
echo -e "${YELLOW}[4/7] Setting up directories...${NC}"
mkdir -p public/{assets/{css,js},uploads} src config storage/{servers,backups,logs} docker
chmod -R 755 public storage
chown -R www-data:www-data /opt/alpine-panel
echo -e "${GREEN}✓ Directories ready${NC}\n"

# Step 5: Setup database
echo -e "${YELLOW}[5/7] Setting up MySQL database...${NC}"
service mysql start > /dev/null 2>&1 || true
sleep 2

# Create database and user
mysql -u root << SQLEOF 2>/dev/null || true
CREATE DATABASE IF NOT EXISTS alpine_panel;
CREATE USER IF NOT EXISTS 'alpine'@'localhost' IDENTIFIED BY 'alpine123';
GRANT ALL PRIVILEGES ON alpine_panel.* TO 'alpine'@'localhost';
FLUSH PRIVILEGES;
SQLEOF

echo -e "${GREEN}✓ Database configured${NC}\n"

# Step 6: Configure services
echo -e "${YELLOW}[6/7] Configuring Nginx & PHP...${NC}"

# Nginx config
cat > /etc/nginx/sites-available/alpine-panel << 'NGINXEOF'
server {
    listen 80 default_server;
    server_name _;
    root /opt/alpine-panel/public;
    client_max_body_size 100M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\. { deny all; }
}
NGINXEOF

ln -sf /etc/nginx/sites-available/alpine-panel /etc/nginx/sites-enabled/ 2>/dev/null || true
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
nginx -t > /dev/null 2>&1
echo -e "${GREEN}✓ Nginx configured${NC}\n"

# Step 7: Start services
echo -e "${YELLOW}[7/7] Starting services...${NC}"
service php-fpm start > /dev/null 2>&1 || true
service nginx restart > /dev/null 2>&1 || true
service mysql start > /dev/null 2>&1 || true

echo -e "${GREEN}✓ Services started${NC}\n"

# Completion
echo -e "${GREEN}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║              ✓ Installation Complete!                      ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${YELLOW}📍 Access Alpine Panel:${NC}"
echo -e "   http://localhost or your-domain.com"
echo ""
echo -e "${YELLOW}📁 Installation Location:${NC}"
echo -e "   /opt/alpine-panel"
echo ""
echo -e "${YELLOW}🐳 Docker Status:${NC}"
docker --version 2>/dev/null || echo "   Docker ready for setup"
echo ""
echo -e "${YELLOW}📊 Database:${NC}"
echo -e "   Host: localhost"
echo -e "   Name: alpine_panel"
echo -e "   User: alpine"
echo ""
echo -e "${GREEN}✓ Ready to use!${NC}"
echo ""

