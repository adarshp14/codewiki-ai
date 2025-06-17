#!/bin/bash

echo "Starting CodeWiki AI on Replit..."

# Set environment variables
export PYTHONPATH="."
export NODE_ENV="production"
export PORT=${PORT:-8000}
export OLLAMA_HOST="http://localhost:11434"
export OLLAMA_ENABLED="true"

# Function to install Ollama if not present
install_ollama() {
    if ! command -v ollama &> /dev/null; then
        echo "Installing Ollama..."
        curl -fsSL https://ollama.ai/install.sh | sh
    else
        echo "Ollama already installed"
    fi
}

# Function to start Ollama
start_ollama() {
    echo "Starting Ollama server..."
    ollama serve &
    OLLAMA_PID=$!
    
    # Wait for Ollama to be ready
    echo "Waiting for Ollama to start..."
    sleep 10
    
    # Pull required models in background
    echo "Pulling AI models in background..."
    (
        sleep 5
        ollama pull nomic-embed-text 2>/dev/null || echo "Model pull will continue in background"
        echo "nomic-embed-text model ready"
    ) &
    
    return $OLLAMA_PID
}

# Function to install Python dependencies
install_python_deps() {
    echo "Installing Python dependencies..."
    pip install -r api/requirements.txt
}

# Function to install Node.js dependencies
install_node_deps() {
    echo "Installing Node.js dependencies..."
    npm install
}

# Function to build Next.js app
build_nextjs() {
    echo "Building Next.js application..."
    npm run build
}

# Function to start FastAPI backend
start_backend() {
    echo "Starting FastAPI backend on port $PORT..."
    cd api && python -m uvicorn main:app --host 0.0.0.0 --port $PORT --workers 1 &
    BACKEND_PID=$!
    cd ..
    return $BACKEND_PID
}

# Function to start Next.js frontend
start_frontend() {
    echo "Starting Next.js frontend on port 3000..."
    npm start &
    FRONTEND_PID=$!
    return $FRONTEND_PID
}

# Main execution
main() {
    echo "=================================="
    echo "CodeWiki AI - Replit Deployment"
    echo "=================================="
    
    # Install dependencies
    install_python_deps
    install_node_deps
    
    # Build frontend
    build_nextjs
    
    # Try to install and start Ollama (may not work in all Replit environments)
    if install_ollama; then
        start_ollama
        OLLAMA_PID=$?
    else
        echo "Ollama installation failed, continuing without local AI models"
        export OLLAMA_ENABLED="false"
    fi
    
    # Start backend
    start_backend
    BACKEND_PID=$?
    
    # Start frontend
    start_frontend
    FRONTEND_PID=$?
    
    echo ""
    echo "=================================="
    echo "CodeWiki AI is starting up!"
    echo "=================================="
    echo "Frontend: https://$REPL_SLUG.$REPL_OWNER.repl.co"
    echo "Backend API: https://$REPL_SLUG.$REPL_OWNER.repl.co:8000"
    echo "Health Check: https://$REPL_SLUG.$REPL_OWNER.repl.co:8000/health"
    echo ""
    echo "Environment:"
    echo "- Node.js Frontend: Running on port 3000"
    echo "- FastAPI Backend: Running on port $PORT"
    if [ "$OLLAMA_ENABLED" = "true" ]; then
        echo "- Ollama AI: Running on port 11434"
    else
        echo "- Ollama AI: Disabled (using external providers)"
    fi
    echo "=================================="
    
    # Keep the script running and monitor processes
    while true; do
        sleep 30
        
        # Check if processes are still running
        if ! kill -0 $FRONTEND_PID 2>/dev/null; then
            echo "Frontend stopped, restarting..."
            start_frontend
            FRONTEND_PID=$?
        fi
        
        if ! kill -0 $BACKEND_PID 2>/dev/null; then
            echo "Backend stopped, restarting..."
            start_backend
            BACKEND_PID=$?
        fi
    done
}

# Handle cleanup on exit
cleanup() {
    echo "Shutting down CodeWiki AI..."
    kill $FRONTEND_PID 2>/dev/null || true
    kill $BACKEND_PID 2>/dev/null || true
    kill $OLLAMA_PID 2>/dev/null || true
    exit 0
}

trap cleanup SIGINT SIGTERM

# Start the application
main