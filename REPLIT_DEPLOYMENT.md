# CodeWiki AI - Replit Deployment Guide

## Quick Start

1. **Import to Replit**
   - Go to [Replit](https://replit.com)
   - Click "Create Repl" → "Import from GitHub"
   - Enter: `https://github.com/adarshp14/codewiki-ai`
   - Select "Import from GitHub"

2. **Configure Environment Variables**
   - Open your Repl
   - Go to "Secrets" tab (lock icon in sidebar)
   - Add the following secrets:

   ```
   GOOGLE_API_KEY=your_google_api_key_here
   ```

   **Optional secrets:**
   ```
   OPENAI_API_KEY=your_openai_api_key_here
   OPENROUTER_API_KEY=your_openrouter_api_key_here
   ```

3. **Run the Application**
   - Click the green "Run" button, or
   - Type in the Shell: `npm run replit`

## What Happens During Deployment

The startup script will automatically:
- Install Python and Node.js dependencies
- Build the Next.js frontend
- Attempt to install Ollama (for local AI models)
- Start FastAPI backend on port 8000
- Start Next.js frontend on port 3000
- Monitor and restart services if they crash

## Access Your Application

Once deployed, you can access:
- **Frontend**: `https://your-repl-name.your-username.repl.co`
- **Backend API**: `https://your-repl-name.your-username.repl.co:8000`
- **Health Check**: `https://your-repl-name.your-username.repl.co:8000/health`

## Features

✅ **Multi-service Architecture**
- Next.js frontend (React 19)
- FastAPI backend (Python)
- Ollama AI models (when available)

✅ **AI Providers Supported**
- Google Gemini (requires API key)
- OpenAI (optional)
- OpenRouter (optional)
- Ollama local models (automatic)

✅ **Security Features**
- CORS protection
- Security headers
- Environment variable isolation

## Troubleshooting

### If Ollama Installation Fails
- The app will continue working with external AI providers
- Make sure `GOOGLE_API_KEY` is set in Secrets

### If Backend Fails to Start
- Check the Console for error messages
- Ensure all required secrets are set
- Try restarting the Repl

### If Frontend Build Fails
- Check Node.js dependencies in the Console
- Try running `npm install` manually
- Restart the Repl

## Manual Commands

If you need to run services manually:

```bash
# Backend only
npm run backend

# Install dependencies
npm install
pip install -r api/requirements.txt

# Build frontend
npm run build

# Start frontend
npm start
```

## Support

- Repository: https://github.com/adarshp14/codewiki-ai
- Issues: https://github.com/adarshp14/codewiki-ai/issues

---
🚀 **CodeWiki AI** - AI-powered documentation generator