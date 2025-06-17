# CodeWiki AI - Complete Deployment Guide

## 🚀 Free Deployment Options

### Option 1: Render (Recommended)

**Cost**: Free tier with 500 build minutes/month

**Steps**:
1. Go to [Render](https://render.com) and sign up
2. Connect your GitHub account
3. Create "New Blueprint" and select this repository
4. Render will automatically detect `render.yaml` and deploy both services
5. Set environment variables in Render dashboard:
   - `GOOGLE_API_KEY`: Your Google Gemini API key (required)
   - `OPENAI_API_KEY`: Optional OpenAI key
   - `OPENROUTER_API_KEY`: Optional OpenRouter key

**URLs after deployment**:
- Frontend: `https://codewiki-ai-frontend.onrender.com`
- Backend: `https://codewiki-ai-backend.onrender.com`

### Option 2: Railway

**Cost**: $5 monthly credits (free tier)

**Steps**:
1. Go to [Railway](https://railway.app) and sign up
2. Create new project from GitHub
3. Deploy both frontend and backend as separate services
4. Set environment variables in Railway dashboard

### Option 3: Fly.io

**Cost**: Free tier with 3 shared VMs

**Steps**:
1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Run: `flyctl auth login`
3. Run: `flyctl launch` (will detect Dockerfile)
4. Deploy: `flyctl deploy`

---

## 🏢 Enterprise Self-Hosted Deployment

### For Your Colleagues - Docker Compose

**Requirements**:
- Server with Docker and Docker Compose
- 4GB RAM minimum, 8GB recommended
- 50GB storage minimum

**Quick Start**:
```bash
# 1. Clone repository
git clone https://github.com/adarshp14/codewiki-ai.git
cd codewiki-ai

# 2. Configure environment
cp .env.enterprise .env
# Edit .env with your API keys and settings

# 3. Start services
docker-compose -f docker-compose.enterprise.yml up -d

# 4. Check status
docker-compose -f docker-compose.enterprise.yml ps
```

**Access**:
- Frontend: `http://your-server:3000`
- Backend API: `http://your-server:8000`
- Admin Dashboard: `http://your-server:3001` (Grafana)

### VPS Providers (Recommended)

**DigitalOcean Droplet**:
- 4GB RAM, 2 vCPUs, 80GB SSD: $24/month
- Easy Docker setup, managed backups

**Linode**:
- 4GB RAM, 2 vCPUs, 80GB SSD: $20/month
- Excellent performance, simple setup

**Hetzner**:
- 4GB RAM, 2 vCPUs, 40GB SSD: $8/month
- Most cost-effective option

---

## 🔒 Security Configuration

### SSL/HTTPS Setup

**Using Nginx with Let's Encrypt**:
```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Firewall Configuration
```bash
# Allow only necessary ports
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

---

## 👥 Team Access & User Management

### Option 1: Simple Shared Access
- Deploy once, share the URL
- All colleagues use same instance
- No user management needed

### Option 2: Basic Authentication
- Add environment variable: `AUTH_ENABLED=true`
- Set admin email: `ADMIN_EMAIL=your-email@company.com`
- Users access via shared login

### Option 3: Enterprise SSO (Advanced)
- Configure LDAP or SAML in `.env`
- Integrate with company Active Directory
- Role-based access control

---

## 📊 Monitoring & Maintenance

### Health Checks
```bash
# Check service status
curl http://your-server:8000/health

# View logs
docker-compose -f docker-compose.enterprise.yml logs -f backend

# Restart services
docker-compose -f docker-compose.enterprise.yml restart
```

### Backup Strategy
```bash
# Database backup
docker exec codewiki-db pg_dump -U codewiki_user codewiki_ai > backup.sql

# Volume backup
docker run --rm -v codewiki-ai_postgres-data:/data -v $(pwd):/backup alpine tar czf /backup/data-backup.tar.gz /data
```

### Updates
```bash
# Pull latest code
git pull origin main

# Rebuild and restart
docker-compose -f docker-compose.enterprise.yml up -d --build
```

---

## 🔧 Troubleshooting

### Common Issues

**Service won't start**:
```bash
# Check logs
docker-compose -f docker-compose.enterprise.yml logs service-name

# Check port conflicts
sudo netstat -tulpn | grep :8000
```

**Out of memory**:
```bash
# Check memory usage
docker stats

# Restart specific service
docker-compose -f docker-compose.enterprise.yml restart backend
```

**Ollama models not loading**:
```bash
# Check Ollama logs
docker-compose -f docker-compose.enterprise.yml logs ollama

# Manually pull models
docker exec codewiki-ollama ollama pull nomic-embed-text
```

---

## 📋 Cost Comparison

| Option | Cost/Month | Users | Features |
|--------|------------|-------|----------|
| Render Free | $0 | Unlimited | Basic features, 500 build minutes |
| Railway | $5 | Unlimited | Full features, better performance |
| VPS (Hetzner) | $8 | Unlimited | Full control, all features |
| VPS (DigitalOcean) | $24 | Unlimited | Managed backups, monitoring |
| Enterprise Cloud | $100+ | Unlimited | High availability, compliance |

---

## 🎯 Recommendations

**For Testing**: Use Render free tier
**For Small Team (5-10 people)**: Use VPS with Docker Compose
**For Large Team (50+ people)**: Use managed Kubernetes
**For Enterprise**: Use cloud provider with compliance features

---

## 📞 Support

- **Repository**: https://github.com/adarshp14/codewiki-ai
- **Issues**: https://github.com/adarshp14/codewiki-ai/issues
- **Documentation**: Check README.md for detailed setup

---

*🤖 CodeWiki AI - AI-powered documentation generator for your team*