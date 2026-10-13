# Lore

Lore is a SwiftUI-based dating and social connection app prototype focused on onboarding, discovery, matching, and conversation. The project is currently in active development and represents a modern, mobile-first experience for people to discover potential matches, browse profiles, and connect in a conversational flow.

## Overview

The application combines onboarding screens, profile creation, story-like discovery cards, and chat-style interactions in a single experience. The codebase is organized around a SwiftUI app architecture with domain models, DTOs, view models, and UI views that separate business behavior from presentation.

This repository currently appears to be an iOS app using Swift and SwiftUI, with a structure intended to support:

- personalized onboarding
- profile-based discovery
- story and home feed experiences
- match and chat workflows
- app state and persistence layers

## Project status

The repository description identifies the project as a dating app in progress, and the code structure suggests an early-stage product prototype rather than a fully production-ready service. The app includes UI flows for welcome, onboarding, sign-in, profile browsing, and chat discussion screens.

## Tech stack

- Language: Swift
- Framework: SwiftUI
- Platform: iOS / Apple ecosystem
- Build tools: Xcode / Swift Package ecosystem
- Data modeling: Foundation, Codable, domain and DTO structs
- Architecture: MVVM-inspired structure with separate models, view models, and views

## Key application concepts

### Onboarding
The app includes a multi-step onboarding flow in `ContentView.swift` that guides the user through:

- welcome screen
- name input
- age input
- gender selection
- match-ready completion step

This flow is implemented as a paged `TabView`, which makes it easy to extend with additional onboarding steps such as interests, photos, or bio information.

### Home and discovery experience
The `HomeViewActions.swift` file shows a social-feed style layout with:

- branded top navigation
- horizontal story cards
- profile cards in a vertical feed
- a polished, Instagram-like visual design

This suggests the app is designed around quick visual discovery and user browsing.

### Data model layer
The `Models` folder is split into:

- `Domain` for app-level entities such as `User`, `Match`, `Conversation`, `Gender`, and `SwipeAction`
- `DTO` for API or transport models such as `UserDTO`, `AuthDTO`, `ChatDTO`, and `DiscoveryDTO`

This separation indicates a clean approach to mapping backend responses into app use cases while preserving domain logic.

### View models and UI flow
The app includes view models for:

- chat list and chat detail screens
- onboarding
- profile management
- sign-in
- home feed behavior

This is consistent with a typical MVVM architecture for SwiftUI apps, where state and UI logic are isolated from rendering.

## How to run the project

### Prerequisites

- macOS
- Xcode (current supported version for the project)
- iOS simulator or a physical Apple device for testing

### Setup

1. Clone the repository:

```bash
git clone https://github.com/lazyskiddie/Lore.git
cd Lore
```

2. Open the Xcode project:

```bash
open "people connection.xcodeproj"
```

3. Select the simulator or connected device.

4. Build and run the app from Xcode.

## Notes on configuration

This repository does not currently show a `.env` file or explicit backend configuration files. The project appears to contain the iOS client and its domain models, while future integration may require backend endpoints, authentication configuration, and persistence setup.

## Development approach

The implementation suggests a mobile-first product that follows these design principles:

- clear UI steps for onboarding
- simple, expressive SwiftUI components
- modular separation of data and presentation
- extensibility for future networking and authentication

## Contributing

Contributions are welcome. A typical contribution flow would be:

1. Fork the repository
2. Create a feature branch
3. Implement your changes
4. Run the relevant Xcode tests or UI checks
5. Open a pull request for review


## Summary

Lore is a SwiftUI dating app prototype designed around a friendly, social-discovery experience. It already includes several core patterns needed for a modern app: onboarding, profile data modeling, discovery feed visuals, and chat-oriented workflows. The project is well-structured for further expansion into real networking, authentication, and production-ready app features.
