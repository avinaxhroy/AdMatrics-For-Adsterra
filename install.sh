#!/bin/bash

# AdMetrics One-Click Installer for macOS
# This script builds and installs AdMetrics app and widgets

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_header() {
    echo ""
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  AdMetrics Installer for macOS${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check macOS version
    macos_version=$(sw_vers -productVersion | cut -d '.' -f 1)
    if [ "$macos_version" -lt 14 ]; then
        print_error "macOS 14.0 (Sonoma) or later is required"
        print_error "Your version: $(sw_vers -productVersion)"
        exit 1
    fi
    print_success "macOS version: $(sw_vers -productVersion)"
    
    # Check if Xcode Command Line Tools are installed
    if ! xcode-select -p &> /dev/null; then
        print_error "Xcode Command Line Tools not found"
        print_info "Installing Xcode Command Line Tools..."
        xcode-select --install
        print_warning "Please complete the installation and run this script again"
        exit 1
    fi
    print_success "Xcode Command Line Tools installed"
    
    # Check if git is available
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        exit 1
    fi
    print_success "Git is available"
}

# Clone or update repository
setup_repository() {
    print_info "Setting up repository..."
    
    INSTALL_DIR="$HOME/AdMetrics"
    
    if [ -d "$INSTALL_DIR" ]; then
        print_info "AdMetrics directory exists, updating..."
        cd "$INSTALL_DIR"
        git pull origin main
    else
        print_info "Cloning AdMetrics repository..."
        git clone https://github.com/YOUR_USERNAME/AdMetrics.git "$INSTALL_DIR"
        cd "$INSTALL_DIR"
    fi
    
    print_success "Repository ready"
}

# Build the application
build_app() {
    print_info "Building AdMetrics (this may take a few minutes)..."
    
    cd "$INSTALL_DIR"
    
    # Clean previous builds
    rm -rf build/
    
    # Build for release
    xcodebuild clean build \
        -scheme AdMetrics \
        -configuration Release \
        -derivedDataPath ./build \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        > /tmp/admetrics_build.log 2>&1
    
    if [ $? -eq 0 ]; then
        print_success "Build completed successfully"
    else
        print_error "Build failed. Check /tmp/admetrics_build.log for details"
        tail -20 /tmp/admetrics_build.log
        exit 1
    fi
}

# Install the application
install_app() {
    print_info "Installing AdMetrics to /Applications/..."
    
    # Kill existing app if running
    killall -9 AdMetrics 2>/dev/null || true
    
    # Remove old version
    if [ -d "/Applications/AdMetrics.app" ]; then
        rm -rf /Applications/AdMetrics.app
    fi
    
    # Copy new version
    cp -R "$INSTALL_DIR/build/Build/Products/Release/AdMetrics.app" /Applications/
    
    if [ -d "/Applications/AdMetrics.app" ]; then
        print_success "AdMetrics installed to /Applications/"
    else
        print_error "Installation failed"
        exit 1
    fi
}

# Post-installation setup
post_install() {
    print_info "Performing post-installation setup..."
    
    # Open the app
    print_info "Launching AdMetrics..."
    open /Applications/AdMetrics.app
    
    # Wait a moment
    sleep 2
    
    # Refresh system services
    killall Dock 2>/dev/null || true
    killall chronod 2>/dev/null || true
    
    print_success "Post-installation complete"
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                ║${NC}"
    echo -e "${GREEN}║  ✅ AdMetrics Successfully Installed!          ║${NC}"
    echo -e "${GREEN}║                                                ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════╝${NC}"
    echo ""
    print_info "Next steps:"
    echo ""
    echo "  1. 📱 Open AdMetrics from Applications folder"
    echo "  2. ⚙️  Go to Settings and configure Google AdSense API"
    echo "  3. 🔐 Complete OAuth authentication"
    echo "  4. 📊 Add widgets to your desktop:"
    echo "     • Click date/time in menu bar"
    echo "     • Scroll down → 'Edit Widgets'"
    echo "     • Find 'AdMetrics' and drag to desktop"
    echo ""
    print_info "Documentation: $INSTALL_DIR/README.md"
    print_info "App location: /Applications/AdMetrics.app"
    echo ""
}

# Main installation flow
main() {
    print_header
    
    check_requirements
    echo ""
    
    setup_repository
    echo ""
    
    build_app
    echo ""
    
    install_app
    echo ""
    
    post_install
    echo ""
    
    show_completion
}

# Run main function
main
