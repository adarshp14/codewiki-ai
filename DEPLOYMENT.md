# 🚀 CodeWiki AI - Unified Free Deployment Guide

**NEW: FastAPI Backend + Ollama AI running together on Render's free tier!**

## 🎯 Architecture Overview

```
┌─────────────────────────────────────────┐    ┌─────────────────┐
│           Render Container (FREE)       │    │   Frontend      │
│  ┌─────────────────┐ ┌─────────────────┐│    │   (Vercel)      │
│  │   FastAPI       │ │     Ollama      ││◄──►│   Next.js       │
│  │   Backend       │ │   AI Models     ││    │                 │
│  └─────────────────┘ └─────────────────┘│    └─────────────────┘
│        :8000              :11434        │
└─────────────────────────────────────────┘
```

## 💰 Cost Breakdown (100% FREE)

| Service | What's Included | Monthly Cost |
|---------|-----------------|--------------|
| **Render** | FastAPI + Ollama + PostgreSQL | **$0** |
| **Vercel** | Next.js Frontend + Global CDN | **$0** |
| **AI Models** | nomic-embed-text + llama2:7b | **$0** |
| **Total** | | **$0** |

## 🔧 Step 1: Get API Keys

### Google Gemini API (Required)
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create API key
3. Copy for later use

### OpenAI API (Optional)
1. Go to [OpenAI Platform](https://platform.openai.com/api-keys)
2. Create API key
3. Copy for later use

## 🐍 Step 2: Deploy Backend + Ollama (Render)

### 2.1 Create Render Account
1. Go to [dashboard.render.com](https://dashboard.render.com/)
2. Sign up with GitHub

### 2.2 Create Web Service
1. Click **"New +"** → **"Web Service"**
2. Connect your GitHub repository:
   ```
   https://github.com/adarshp14/codewiki-ai
   ```

### 2.3 Configure Service
- **Name**: `codewiki-ai-backend`
- **Region**: Choose closest to your users
- **Branch**: `main`
- **Runtime**: `Docker`
- **Dockerfile Path**: `./Dockerfile.render`
- **Auto-Deploy**: `Yes`

### 2.4 Environment Variables
Add these in the Render dashboard:

| Variable | Value | Required |
|----------|-------|----------|
| `GOOGLE_API_KEY` | Your Google API key | ✅ Yes |
| `CORS_ORIGINS` | `https://codewiki-ai.vercel.app` | ✅ Yes |
| `NODE_ENV` | `production` | ✅ Yes |
| `OPENAI_API_KEY` | Your OpenAI key | ❌ Optional |
| `OPENROUTER_API_KEY` | Your OpenRouter key | ❌ Optional |

### 2.5 What Happens Automatically
The Dockerfile.render will automatically:
- ✅ Install Ollama
- ✅ Start Ollama server 
- ✅ Pull `nomic-embed-text` model
- ✅ Pull `llama2:7b` model
- ✅ Start FastAPI backend
- ✅ Configure health checks

## 📦 Step 3: Deploy Frontend (Vercel)

### 3.1 Install Vercel CLI
```bash
npm install -g vercel
```

### 3.2 Deploy to Vercel
```bash
# Login to Vercel
vercel login

# Deploy the project
vercel

# Follow prompts:
# - Link to existing project? N
# - Project name: codewiki-ai
# - Directory: ./
# - Want to override settings? N
```

### 3.3 Set Environment Variables
```bash
# Set API URL to your Render backend
vercel env add NEXT_PUBLIC_API_URL
# Value: https://codewiki-ai-backend.onrender.com

vercel env add NEXT_PUBLIC_APP_ENV
# Value: production

vercel env add NEXT_PUBLIC_APP_NAME  
# Value: CodeWiki AI
```

### 3.4 Deploy to Production
```bash
vercel --prod
```

## 🌐 Your Deployment URLs

After successful deployment:

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | `https://codewiki-ai.vercel.app` | Main application |
| **Backend** | `https://codewiki-ai-backend.onrender.com` | API server |
| **Health Check** | `https://codewiki-ai-backend.onrender.com/health` | Service status |
| **Ollama Status** | `https://codewiki-ai-backend.onrender.com/ollama/status` | AI models status |

## 🔍 Monitoring & Health Checks

### Backend Health Check
```bash
curl https://codewiki-ai-backend.onrender.com/health
```

Expected response:
```json
{
  "status": "healthy",
  "service": "CodeWiki AI API", 
  "version": "1.0.0",
  "components": {
    "api": "healthy",
    "ollama": "healthy"
  },
  "ollama_version": "0.1.x"
}
```

### Ollama Status Check
```bash
curl https://codewiki-ai-backend.onrender.com/ollama/status
```

Expected response:
```json
{
  "status": "healthy",
  "version": "0.1.x",
  "host": "http://localhost:11434",
  "models": ["nomic-embed-text", "llama2:7b"],
  "required_models": ["nomic-embed-text", "llama2:7b"],
  "models_ready": true
}
```

## 🔒 Security Features

### CORS Protection
- Only allows requests from trusted domains
- Production: `https://codewiki-ai.vercel.app`
- Development: `http://localhost:3000`

### Security Headers
- `X-Frame-Options: DENY`
- `X-Content-Type-Options: nosniff`
- `X-XSS-Protection: 1; mode=block`
- `Referrer-Policy: strict-origin-when-cross-origin`

### Environment Variables
- API keys secured via platform environment variables
- No secrets committed to repository
- Production/development environment separation

## 🚀 Benefits of Unified Deployment

### ✅ Advantages
- **Single Container**: Both FastAPI and Ollama in one place
- **No Setup**: Ollama installs and configures automatically
- **Free Tier**: Everything runs on Render's free plan
- **Auto Models**: Required AI models download automatically
- **Health Checks**: Monitor both services with built-in endpoints
- **Zero Config**: No manual Ollama setup required

### ⚠️ Considerations
- **Cold Starts**: Container sleeps after 15 minutes (normal for free tier)
- **Model Downloads**: First deployment takes ~5-10 minutes for model downloads
- **RAM Limits**: 512MB RAM (sufficient for nomic-embed-text)
- **Storage**: Models stored in container (redownloaded on redeploy)

## 🔧 Troubleshooting

### Container Not Starting
1. Check Render logs for Docker build errors
2. Verify Dockerfile.render exists in repository
3. Ensure environment variables are set

### Ollama Not Responding
1. Check `/ollama/status` endpoint
2. Container may still be downloading models
3. Wait 5-10 minutes for initial model download

### CORS Errors
1. Verify `CORS_ORIGINS` environment variable
2. Should match your Vercel frontend URL exactly
3. Check browser developer console for specific errors

### Model Download Issues
1. First deployment takes longer for model downloads
2. Check container logs in Render dashboard
3. nomic-embed-text (~1GB) downloads automatically

## 📈 Performance Optimization

### For Free Tier
- Models are cached in container memory
- First API call may be slower (cold start)
- Subsequent calls are fast (~100-200ms)
- Consider using smaller models if needed

### Scaling Options
- Upgrade to Render paid plan for no cold starts
- Use external Redis for caching
- Implement model warming strategies

## 🎉 Next Steps

1. **Test the deployment** with a sample repository
2. **Configure model preferences** in the UI
3. **Share your CodeWiki AI** with others
4. **Monitor usage** via health check endpoints

---

**🎯 Success!** Your CodeWiki AI is now running completely free with:
- ✅ FastAPI backend with full security
- ✅ Ollama AI models (nomic-embed-text, llama2:7b)  
- ✅ Professional frontend with global CDN
- ✅ Comprehensive monitoring and health checks
- ✅ Zero ongoing costs

**Need Help?**
- 🐛 Issues: [GitHub Issues](https://github.com/adarshp14/codewiki-ai/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/adarshp14/codewiki-ai/discussions)