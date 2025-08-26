# TravelPlanner

An AI-powered iOS travel planning application that helps users discover and explore destinations using Google's Gemini AI.  

## Overview

TravelPlanner is a modular iOS application built with Swift that leverages Firebase services and Google's Gemini AI to provide intelligent travel recommendations. Users can search for travel destinations using natural language prompts, and the app returns specific landmarks, attractions, and points of interest with detailed information and map integration.

## Features

- **AI-Powered Travel Recommendations**: Uses Google Gemini AI to generate personalized travel suggestions
- **Interactive Map Integration**: MapKit integration with custom annotations for travel locations
- **Firebase Authentication**: Secure user authentication and session management
- **Modular Architecture**: Clean, maintainable codebase with VIPER pattern
- **Offline Support**: Mock data support for development and testing
- **Onboarding Flow**: User-friendly introduction to app features
- **Network Monitoring**: Real-time connectivity status tracking

## Architecture

The app follows a modular architecture with separate Swift Package Manager modules:

### Core Modules

- **App**: Main application target with AppDelegate and SceneDelegate
- **AppRouter**: Central navigation and routing logic
- **AIPlanner**: Core travel planning functionality with VIPER architecture
- **TravelPlannerAuth**: Firebase authentication module
- **TravelPlannerNetwork**: Network layer with Gemini AI integration
- **AppResources**: Shared data models and entities
- **TabBar**: Main tab bar controller
- **UserProfile**: User profile management
- **Splash**: App launch screen with animations
- **Onboarding**: User onboarding flow
- **MockData**: Local test data for development
- **AppCheckProvider**: Firebase App Check security

### Key Components

#### AI Integration
- **GeminiService**: Handles communication with Google's Gemini AI
- **TravelLocationService**: Manages travel location data fetching
- **Structured JSON Schema**: Ensures consistent AI responses

#### Data Models
```swift
struct TravelLocation: Codable {
    let id: String
    let name: String
    let description: String
    let latitude: Double
    let longitude: Double
    let symbol: String // SF Symbol
    let type: String   // Monument, Beach, Museum, etc.
}
```

## Requirements

- iOS 15.0+
- Xcode 15.0+
- Swift 6.1+
- Firebase project with Gemini AI enabled

## Dependencies

### External Dependencies
- **Firebase iOS SDK** (v12.0.0+)
  - FirebaseCore
  - FirebaseAuth
  - FirebaseAI
  - FirebaseAppCheck
- **DotLottie** (v0.8.7+) - For splash screen animations

### Internal Dependencies
All modules are managed as local Swift packages with clear dependency relationships.

## Setup

### 1. Firebase Configuration
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Firebase Authentication
3. Enable Gemini AI in Firebase
4. Download `GoogleService-Info.plist` and place it in `App/Resources/`

### 2. Gemini AI Setup
1. Enable Gemini AI in your Firebase project
2. Configure API keys and permissions
3. The app uses Gemini 2.5 Flash model for travel recommendations


## Usage

### Basic Flow
1. **Splash Screen**: App launches with animated splash
2. **Onboarding**: First-time users see feature introduction
3. **Authentication**: Firebase-based login/signup
4. **Main Interface**: Tab-based navigation with AI planner
5. **Travel Search**: Natural language travel queries
6. **Results**: Interactive map with location details

## Development

### Module Structure
Each module follows VIPER architecture:
- **View**: UI components and view controllers
- **Interactor**: Business logic and data operations
- **Presenter**: View logic and formatting
- **Entity**: Data models
- **Router**: Navigation and module assembly
