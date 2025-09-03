# TravelPlanner

An AI-powered iOS travel planning application that helps users discover and explore destinations. It leverages Google's Gemini AI along with interactive maps, onboarding, authentication, and local persistence.

## Overview

TravelPlanner is a modular iOS application built with Swift that leverages Firebase services and Google's Gemini AI to provide intelligent travel recommendations. Users can search for travel destinations using natural language prompts, and the app returns specific landmarks, attractions, and points of interest with detailed information and map integration.

<p align="center">    
    <img width="300" alt="Image" src="https://github.com/user-attachments/assets/b318c546-126d-4a04-ab60-5a1ab949f3ec" />
    <img width="300" alt="Image" src="https://github.com/user-attachments/assets/ed901f64-a321-4889-b328-691df7731e3d" />
    <img width="300" alt="Gif" src="https://github.com/user-attachments/assets/325a270c-8cb8-43d0-ae0e-9a3d7da93b92" />
</p>

## Features

- **AI-Powered Travel Recommendations**: Uses Google Gemini AI to generate personalized travel suggestions
- **Interactive Map Integration**: MapKit integration with custom annotations for travel locations
- **Firebase Authentication**: Secure user authentication and session management
- **Modular Architecture**: Clean, maintainable codebase with VIPER pattern
- **Onboarding Flow**: User-friendly introduction to app features
- **Splash Screen** : Animated splash screen
- **Network Monitoring**: Real-time connectivity status tracking
- **Reachability**: Live network status via `NWPathMonitor`
- **Local persistence**: Store places and folders using Core Data

## Tech Stack

- **Language**: Swift  
- **Frameworks**: UIKit, MapKit, Core Data, Network  
- **Architecture**: VIPER, Modular with Swift Package Manager (SPM)  
- **UI**: XIB-based UI + Programmatic UI
- **AI**: Google Gemini API  
- **Backend Services**: Firebase (Auth, App Check)  

## Architecture

The app is modular, constructed using Swift Package Manager (SPM), and follows the VIPER architecture:

### Modules

- **App**: Main application target with AppDelegate and SceneDelegate
- **AppRouter**: Central navigation and routing logic
- **AIPlanner**: Core travel planning functionality
- **Folder**: Stores user-saved locations
- **FolderDetail**: Displays the contents of a folder
- **TravelPlannerAuth**: Includes login and sign-up screens. Utilizes Firebase Auth
- **TravelPlannerNetwork**: Network layer with Gemini AI integration; includes `ReachabilityManager` to track network connection via `NWPathMonitor`
- **AppResources**: Shared data models and entities
- **TabBar**: Main tab bar controller
- **UserProfile**: User profile management
- **Splash**: App launch screen with animations
- **Onboarding**: User onboarding flow
- **AppCheckProvider**: Firebase App Check security

## Usage

### Basic Flow
1. **Splash Screen**: App launches with animated splash
2. **Onboarding**: First-time users see feature introduction
3. **Authentication**: Firebase-based login and sign-up
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
