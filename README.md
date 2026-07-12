# 🚀 Space Explorer

**Space Explorer** is an iOS app that lets users explore historic space missions through videos and audio recordings. Built with SwiftUI, it features custom media playback controls, theme customization, and a professional user experience.

---

## 📱 Features

### 🎬 Video Playback
- Watch historic space mission videos
- Custom controls: Play, Pause, Stop, Mute
- Full-screen mode
- Progress slider with time display
- Auto-play on open
- Unique summaries for each video

### 🎵 Audio Playback
- Listen to space communications and interviews
- Custom controls: Play, Pause, Stop, Mute
- Progress slider with time display
- Auto-play on open
- Now Playing animation indicator
- Unique summaries for each audio

### ⚙️ Settings & Customization
- **Theme Modes:** System, Light, Dark
- **5 Background Colours:** Light, Blue, Purple, Gray, Dark
- **In-App Settings:** Change theme and colours directly in the app
- **iOS Settings Integration:** Changes sync with the iOS Settings app
- **Reset All Settings:** Reset to defaults

### 🎨 User Experience
- **Onboarding Screen:** Welcomes users on first launch
- **Professional UI:** Clean card-based design with hover effects
- **Responsive Layout:** Works on all iPhone sizes
- **Animations:** Smooth transitions and visual feedback

---

## 📸 Screenshots

*Coming soon...*

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **SwiftUI** | UI framework |
| **AVPlayer** | Video playback |
| **AVAudioPlayer** | Audio playback |
| **AVAsset** | Video/audio metadata extraction |
| **AVAssetImageGenerator** | Thumbnail generation |
| **AVKit** | Video player controls |
| **AVFoundation** | Media handling |
| **UserDefaults** | Settings persistence |
| **Combine** | Reactive state management |
| **UIKit** | ShareSheet (UIActivityViewController) |

---

## 📁 Project Structure

```
SpaceExplorer/
├── SpaceExplorerApp.swift      # App entry point
├── ContentView.swift           # Root view with settings
├── OnboardingView.swift        # First-launch onboarding
├── Models/
│   ├── SpaceVideo.swift        # Video data model
│   └── SpaceAudio.swift        # Audio data model
├── Services/
│   ├── VideoLoader.swift       # Loads videos with thumbnails
│   └── AudioLoader.swift       # Loads audio with summaries
├── Views/
│   ├── MainView.swift          # Tab navigation
│   ├── VideoListView.swift     # Video list with cards
│   ├── VideoPlayerView.swift   # Video player controls
│   ├── AudioListView.swift     # Audio list with cards
│   ├── AudioPlayerView.swift   # Audio player controls
│   └── SettingsView.swift      # In-app settings
├── Settings/
│   ├── SettingsKeys.swift      # Enums and keys
│   └── Settings.swift          # Settings manager
├── Utilities/
│   └── ShareSheet.swift        # Sharing functionality
├── Resources/
│   ├── Apollo11.mp4
│   ├── ISS.mp4
│   ├── MarsRover.mp4
│   ├── SpaceXLaunch.mp4
│   ├── MissionControl.mp3
│   ├── RocketCountdown.mp3
│   ├── AstronautInterview.mp3
│   └── SpaceFacts.mp3
└── Settings.bundle/
    └── Root.plist              # iOS Settings integration
```

---

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 17.0 or later
- macOS Sonoma or later

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/snaimio/iOSApp5.git
   ```

2. **Open the project:**
   ```bash
   cd iOSApp5
   open SpaceExplorer.xcodeproj
   ```

3. **Build and run:**
   - Select a simulator or device
   - Press **⌘ + R**

---

## 👨‍💻 Author

**Sheikh Naim**  

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- SwiftUI Cookbook by Ray Wenderlich
- NASA for public domain media content

---

**Made with ❤️ and SwiftUI**
