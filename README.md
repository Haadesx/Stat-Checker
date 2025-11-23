<div align="center">

# 📊 Stat Check
### The Ultimate Native System Monitor for macOS

[![macOS](https://img.shields.io/badge/platform-macOS-lightgrey.svg?style=for-the-badge&logo=apple)](https://www.apple.com/macos)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge)](LICENSE)
[![Release](https://img.shields.io/github/v/release/Haadesx/Stat-Checker?style=for-the-badge&color=green)](https://github.com/Haadesx/Stat-Checker/releases)

<br />

**Stat Check** is a beautifully crafted, native macOS application designed to give you deep insights into your Mac's performance. Built with **SwiftUI** and **Apple Silicon** in mind, it combines powerful monitoring with a stunning glassmorphic interface.

[**Download Now**](https://github.com/Haadesx/Stat-Checker/releases/latest) · [Report Bug](https://github.com/Haadesx/Stat-Checker/issues) · [Request Feature](https://github.com/Haadesx/Stat-Checker/issues)

</div>

---

## ✨ Features

### 🚀 Real-Time Monitoring
Experience zero-latency updates for your system's most critical metrics.
*   **CPU**: Detailed load analysis with per-core breakdown.
*   **Memory**: Precise RAM usage tracking with dynamic scaling charts.
*   **Network**: Live upload/download speeds (0 B/s idle detection).
*   **Disk**: Instant storage capacity and usage visualization.

### ⚡️ Process Manager
A powerful Task Manager built right in.
*   **Live Sorting**: Sort by CPU, Memory, or Name instantly.
*   **Search**: Find any running process in milliseconds.
*   **Deep Stats**: See exactly how much RAM and CPU every app is using.

### 📈 Historical Insights
Don't just see what's happening now—understand your workflow.
*   **30-Second History**: Smooth, animated charts for all metrics.
*   **Productivity Dashboard**: Track your usage trends over Days, Weeks, and Months.

### 💎 Premium Design
*   **Glassmorphism**: Native macOS materials that blend perfectly with your wallpaper.
*   **Menu Bar Widget**: A compact, always-visible companion for quick checks.
*   **Dark Mode**: Fully optimized for late-night coding sessions.

---

## 📸 Screenshots

<div align="center">
  <img src="Stat Check/screenshots/dashboard.png" alt="Dashboard" width="800"/>
</div>

---

## 🛠 Installation

### Option 1: Direct Download (Recommended)
Since Stat Check uses low-level system APIs to provide detailed process information, it is distributed directly to ensure full functionality.

1.  Go to the [**Releases Page**](https://github.com/Haadesx/Stat-Checker/releases).
2.  Download the latest `Stat.Check.zip`.
3.  Unzip and drag **Stat Check** to your `Applications` folder.
4.  Open the app. (You may need to approve it in *System Settings > Privacy & Security*).

### Option 2: Build from Source
1.  Clone the repo:
    ```bash
    git clone https://github.com/Haadesx/Stat-Checker.git
    ```
2.  Open `Stat Check.xcodeproj` in Xcode 15+.
3.  **Important**: Go to the target settings -> `Signing & Capabilities` and ensure **App Sandbox** is **DISABLED**.
4.  Build and Run (`Cmd + R`).

---

## 🏗 Tech Stack

*   **Language**: Swift 5.9
*   **UI Framework**: SwiftUI
*   **Charts**: Swift Charts
*   **Persistence**: SwiftData
*   **System APIs**: `libproc`, `Darwin`, `IOKit`

---

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

<div align="center">

Made with ❤️ by [Haadesx](https://github.com/Haadesx)

</div>
