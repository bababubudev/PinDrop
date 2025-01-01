# Pin Drop - iOS Map Application

A modern iOS application that allows users to search locations, drop pins on a map, and manage saved locations with a clean SwiftUI interface.

<img src="https://github.com/user-attachments/assets/b7e916a1-351d-4108-8c90-a8ffc1b2cfe0" altSrc="Screenshot_2" width=260 />
<img src="https://github.com/user-attachments/assets/14d4c294-d867-4fca-ba36-d68999450f27" altSrc="Screenshot" width=260 />

## Features

- Interactive map interface with custom pin dropping
- Location search with autocomplete suggestions
- Current location pinning
- Custom pin naming and color selection
- View and manage all saved pins
- Location permission handling
- Dark mode support

## Requirements

- iOS 15.0+
- Xcode 14.0+
- SwiftUI
- MapKit

## Installation

1. Clone this repository
2. Open the project in Xcode
3. Build and run on your iOS device or simulator

## Usage

### Search Locations
- Tap the search bar at the top of the screen
- Enter a location name or address
- Select from the autocomplete suggestions
- Choose "Add pin" to mark the location

### Manual Pin Dropping
- Tap anywhere on the map to drop a new pin
- Enter a custom name for the pin
- Select a color for the pin marker

### Managing Pins
- Tap the menu button (•••) to:
  - View all saved pins
  - Pin your current location
  - Remove all pins
- View the complete list of pins to:
  - Jump to specific locations
  - Remove individual pins

## Architecture

The app follows a MVVM architecture pattern with the following key components:

- `ContentView`: Main view containing the map interface and user controls
- `LaunchView`: Handles location permissions and initial app state
- `MapViewModel`: Manages map state and location operations
- Custom views for search, pin management, and permissions

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
