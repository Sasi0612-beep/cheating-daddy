#!/bin/bash
# Script to run the Cheating Daddy application
# This script handles running the application in both normal and headless environments

set -e

echo "🚀 Starting Cheating Daddy Application..."
echo ""

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo "✅ Dependencies installed"
    echo ""
fi

# Check if running in a headless environment (e.g., CI/CD)
if [ -z "$DISPLAY" ]; then
    echo "🖥️  Headless environment detected"
    echo "Starting Xvfb virtual display..."
    
    # Check if Xvfb is available
    if ! command -v Xvfb &> /dev/null; then
        echo "❌ Error: Xvfb is not installed"
        echo "On Ubuntu/Debian: sudo apt-get install xvfb"
        exit 1
    fi
    
    # Start Xvfb if not already running
    if ! pgrep -x "Xvfb" > /dev/null; then
        Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &
        XVFB_PID=$!
        echo "✅ Xvfb started (PID: $XVFB_PID)"
        sleep 2
    else
        echo "✅ Xvfb already running"
    fi
    
    export DISPLAY=:99
    export ELECTRON_DISABLE_SANDBOX=1
    echo "ℹ️  Set DISPLAY=:99 and ELECTRON_DISABLE_SANDBOX=1"
    echo ""
fi

# Run the application
echo "▶️  Starting Electron application..."
echo ""
npm start
