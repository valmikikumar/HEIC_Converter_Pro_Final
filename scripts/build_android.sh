#!/bin/bash

# HEIC Converter Pro - Android Build Script
# This script builds the Android APK and App Bundle for different environments

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
BUILD_TYPE="release"
ENVIRONMENT="production"
BUILD_NUMBER=$(date +%Y%m%d%H%M)
VERSION_NAME="1.0.0"

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

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -t, --type TYPE       Build type (debug, release) [default: release]"
    echo "  -e, --env ENV         Environment (development, staging, production) [default: production]"
    echo "  -n, --number NUMBER   Build number [default: timestamp]"
    echo "  -v, --version VERSION Version name [default: 1.0.0]"
    echo "  -h, --help            Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                    # Build release APK for production"
    echo "  $0 -t debug -e development           # Build debug APK for development"
    echo "  $0 -e staging -n 123 -v 1.1.0       # Build release APK for staging"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--type)
            BUILD_TYPE="$2"
            shift 2
            ;;
        -e|--env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -n|--number)
            BUILD_NUMBER="$2"
            shift 2
            ;;
        -v|--version)
            VERSION_NAME="$2"
            shift 2
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option $1"
            show_usage
            exit 1
            ;;
    esac
done

# Validate build type
if [[ "$BUILD_TYPE" != "debug" && "$BUILD_TYPE" != "release" ]]; then
    print_error "Invalid build type: $BUILD_TYPE. Must be 'debug' or 'release'"
    exit 1
fi

# Validate environment
if [[ "$ENVIRONMENT" != "development" && "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    print_error "Invalid environment: $ENVIRONMENT. Must be 'development', 'staging', or 'production'"
    exit 1
fi

print_status "Starting Android build..."
print_status "Build Type: $BUILD_TYPE"
print_status "Environment: $ENVIRONMENT"
print_status "Version: $VERSION_NAME"
print_status "Build Number: $BUILD_NUMBER"

# Navigate to project root
cd "$(dirname "$0")/.."

# Clean previous builds
print_status "Cleaning previous builds..."
flutter clean

# Get dependencies
print_status "Getting Flutter dependencies..."
flutter pub get

# Generate code
print_status "Generating code..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run analysis
print_status "Running Flutter analysis..."
flutter analyze

# Run tests (skip for debug builds to save time)
if [[ "$BUILD_TYPE" == "release" ]]; then
    print_status "Running tests..."
    flutter test
fi

# Set up environment-specific configuration
print_status "Setting up environment configuration for $ENVIRONMENT..."

# Update pubspec.yaml with version info
if command -v sed &> /dev/null; then
    sed -i.bak "s/version: .*/version: $VERSION_NAME+$BUILD_NUMBER/" pubspec.yaml
    rm -f pubspec.yaml.bak
fi

# Build APK
print_status "Building Android APK..."
if [[ "$BUILD_TYPE" == "debug" ]]; then
    flutter build apk --debug \
        --build-name="$VERSION_NAME" \
        --build-number="$BUILD_NUMBER" \
        --dart-define=ENVIRONMENT="$ENVIRONMENT"
else
    flutter build apk --release \
        --build-name="$VERSION_NAME" \
        --build-number="$BUILD_NUMBER" \
        --dart-define=ENVIRONMENT="$ENVIRONMENT" \
        --obfuscate \
        --split-debug-info=build/debug-info
fi

# Build App Bundle (only for release builds)
if [[ "$BUILD_TYPE" == "release" ]]; then
    print_status "Building Android App Bundle..."
    flutter build appbundle --release \
        --build-name="$VERSION_NAME" \
        --build-number="$BUILD_NUMBER" \
        --dart-define=ENVIRONMENT="$ENVIRONMENT" \
        --obfuscate \
        --split-debug-info=build/debug-info
fi

# Show build outputs
print_success "Build completed successfully!"
echo ""
print_status "Build outputs:"
if [[ "$BUILD_TYPE" == "debug" ]]; then
    echo "  📱 Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
else
    echo "  📱 Release APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "  📦 App Bundle: build/app/outputs/bundle/release/app-release.aab"
fi

# Show file sizes
if [[ "$BUILD_TYPE" == "release" ]]; then
    echo ""
    print_status "File sizes:"
    if [[ -f "build/app/outputs/flutter-apk/app-release.apk" ]]; then
        APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
        echo "  📱 APK Size: $APK_SIZE"
    fi
    if [[ -f "build/app/outputs/bundle/release/app-release.aab" ]]; then
        AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)
        echo "  📦 AAB Size: $AAB_SIZE"
    fi
fi

print_success "Android build process completed!"
