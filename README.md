# Stat Check - macOS System Monitor

A modern, native macOS system monitor built with SwiftUI.

![App Screenshot](https://via.placeholder.com/800x500?text=Stat+Check+Screenshot)

## Features

*   **Dashboard**: Real-time overview of CPU, Memory, Disk, and Network usage.
*   **Process Manager**: View running applications with CPU and Memory usage. Sort and filter processes.
*   **Live Charts**: Smooth, animated charts showing the last 30 seconds of activity.
*   **Menu Bar Widget**: Quick access to system stats from the menu bar.
*   **Insights**: Historical data tracking to analyze system usage over time.
*   **Native Design**: Built with SwiftUI for a seamless macOS experience.

## Requirements

*   macOS 14.0+
*   Apple Silicon (Recommended) or Intel Mac

## Installation

1.  Download the latest release from the [Releases](https://github.com/Haadesx/Stat_Checker/releases) page.
2.  Unzip the file.
3.  Drag `Stat Check.app` to your Applications folder.
4.  **Note**: This app requires **Direct Distribution** (outside the App Store) to function fully, as it uses low-level APIs to monitor processes. You may need to allow it in System Settings > Privacy & Security.

## Building from Source

1.  Clone the repository:
    ```bash
    git clone https://github.com/Haadesx/Stat_Checker.git
    ```
2.  Open `Stat Check.xcodeproj` in Xcode.
3.  Ensure **App Sandbox** is disabled in the "Signing & Capabilities" tab of the "Stat Check" target (required for Process Manager).
4.  Build and Run (Cmd + R).

## Tech Stack

*   **SwiftUI**: UI Framework
*   **Swift Charts**: Data Visualization
*   **SwiftData**: Persistence
*   **Combine**: Reactive Updates
*   **libproc / Darwin**: Low-level system statistics

## License

MIT License
