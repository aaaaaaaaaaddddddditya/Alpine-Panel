# Alpine Cloud Panel

Complete Minecraft server hosting control panel with Docker integration.

## Features
- 🎮 Full server management (create, start, stop, delete)
- 👥 Role-based access control (Owner, Admin, User)
- 🌐 Docker container integration
- 📊 Real-time system monitoring
- 💾 Backup & restore management
- 🌙 Dark theme UI
- 📱 Responsive design

## Quick Start

### Option 1: Automated Installation (Recommended)
```bash
sudo bash install.sh
```

### Option 2: Docker Compose
```bash
docker-compose up -d
```

### Option 3: Manual Setup
```bash
# 1. Install dependencies
sudo apt-get install php-fpm nginx mysql-server docker.io

# 2. Clone repository
git clone https://github.com/aaaaaaaaaaddddddditya/Alpine-Panel.git
cd Alpine-Panel

# 3. Setup database
mysql -u root < database-schema.sql

# 4. Configure .env
cp .env.example .env

# 5. Start services
sudo service nginx start
sudo service php-fpm start
sudo service mysql start

# 6. Access
# http://localhost
```

## Default Credentials
- Email: `admin@alpine-panel.local`
- Password: `admin123`

**Change immediately after first login!**

## System Requirements
- Ubuntu/Debian 20.04+
- PHP 8.0+
- MySQL 5.7+
- Docker & Docker Compose
- 2GB RAM minimum

## File Structure
```
alpine-panel/
├── public/              (Web root)
├── src/                 (PHP classes)
├── config/              (Configuration)
├── storage/             (Data, backups)
├── docker/              (Docker files)
├── install.sh          (Installer)
└── docker-compose.yml  (Docker setup)
```

## Support
See documentation in `/docs` for detailed guides.

## License
MIT License - Open Source
