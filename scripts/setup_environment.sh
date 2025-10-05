#!/bin/bash

# HEIC Converter Pro - Environment Setup Script
# This script sets up the development environment for the project

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_status "Setting up HEIC Converter Pro development environment..."

# Navigate to project root
cd "$(dirname "$0")/.."

# Check Flutter installation
print_status "Checking Flutter installation..."
if ! command_exists flutter; then
    print_error "Flutter is not installed or not in PATH"
    print_status "Please install Flutter from https://flutter.dev/docs/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n 1)
print_success "Flutter found: $FLUTTER_VERSION"

# Check Flutter doctor
print_status "Running Flutter doctor..."
flutter doctor

# Get Flutter dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Install CocoaPods (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Checking CocoaPods installation..."
    if ! command_exists pod; then
        print_warning "CocoaPods not found. Installing..."
        sudo gem install cocoapods
    fi
    
    print_status "Installing CocoaPods dependencies..."
    cd ios
    pod install
    cd ..
    print_success "CocoaPods dependencies installed"
fi

# Generate code
print_status "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run analysis
print_status "Running Flutter analysis..."
flutter analyze

# Create environment files if they don't exist
print_status "Setting up environment files..."

if [[ ! -f ".env" ]]; then
    if [[ -f "env.example" ]]; then
        cp env.example .env
        print_success "Created .env file from env.example"
        print_warning "Please update .env file with your actual configuration values"
    else
        print_warning "env.example not found, skipping .env creation"
    fi
else
    print_status ".env file already exists"
fi

# Create assets directories if they don't exist
print_status "Creating assets directories..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/animations
mkdir -p fonts

print_success "Assets directories created"

# Check Android setup
print_status "Checking Android setup..."
if [[ -d "android" ]]; then
    if [[ -f "android/local.properties" ]]; then
        print_success "Android local.properties found"
    else
        print_warning "Android local.properties not found"
        print_status "Creating Android local.properties..."
        
        # Try to find Flutter SDK path
        FLUTTER_SDK=$(flutter --version | grep "Flutter SDK" | awk '{print $4}')
        if [[ -z "$FLUTTER_SDK" ]]; then
            FLUTTER_SDK=$(which flutter | sed 's|/bin/flutter||')
        fi
        
        if [[ -n "$FLUTTER_SDK" ]]; then
            echo "flutter.sdk=$FLUTTER_SDK" > android/local.properties
            print_success "Created Android local.properties with Flutter SDK path"
        else
            print_warning "Could not determine Flutter SDK path"
        fi
    fi
else
    print_warning "Android directory not found"
fi

# Check iOS setup
if [[ "$OSTYPE" == "darwin"* ]]; then
    print_status "Checking iOS setup..."
    if [[ -d "ios" ]]; then
        print_success "iOS project found"
    else
        print_warning "iOS directory not found"
    fi
fi

# Run tests
print_status "Running tests..."
if flutter test; then
    print_success "All tests passed"
else
    print_warning "Some tests failed"
fi

print_success "Environment setup completed!"
echo ""
print_status "Next steps:"
echo "  1. Update .env file with your configuration"
echo "  2. Configure Firebase project"
echo "  3. Set up AdMob account and update ad unit IDs"
echo "  4. Configure Google Play Billing (for Android)"
echo "  5. Set up App Store Connect (for iOS)"
echo "  6. Run './scripts/build_android.sh' to build Android APK"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "  7. Run './scripts/build_ios.sh' to build iOS IPA"
fi
