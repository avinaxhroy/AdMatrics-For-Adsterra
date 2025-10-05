# AdMetrics for Adsterra(macOS)

Beautiful macOS app and widgets to monitor your Adsterra earnings in real-time.

![AdMetrics Widgets](https://img.shields.io/badge/macOS-14.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

✨ **Beautiful Widgets**
- 3 widget sizes: Small, Medium, and Large
- Premium blue gradient design with glass morphism
- Real-time balance and earnings display
- 7-day revenue sparkline (Medium widget)
- Detailed stats dashboard (Large widget)

📊 **Real-time Monitoring**
- Live Adsterra data
- Today's earnings with visual indicator
- Impressions, clicks, and CPM tracking
- Weekly revenue overview

🎨 **Premium Design**
- Vibrant blue gradient backgrounds
- Glass effect stat cards with depth
- Glowing indicators and shadows
- White text optimized for contrast
- Responsive layouts for all widget sizes

🔒 **Secure & Private**
- No data shared with third parties
- Local-only data processing

## Screenshots

### Widgets
- **Small Widget:** Balance and key metrics at a glance
- **Medium Widget:** Balance with 7-day trend sparkline
- **Large Widget:** Complete dashboard with all stats

## Installation

### One-Click Installer (Recommended)

1. Download the installer script:
   ```bash
   curl -O https://raw.githubusercontent.com/YOUR_USERNAME/AdMetrics/main/install.sh
   ```

2. Run the installer:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. Follow the on-screen instructions to:
   - Set up Adsterra API credentials
   - Configure your account
   - Add widgets to your desktop

### Manual Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/AdMetrics.git
   cd AdMetrics
   ```

2. **Open in Xcode:**
   ```bash
   open AdMetrics.xcodeproj
   ```

3. **Build and Run:**
   - Select the AdMetrics scheme
   - Press Cmd+R to build and run
   - The app will be installed to /Applications/

## Setup

### Adsterra API Setup

1. **Get Adsterra API:**
   - Go to [Adsterra Publisher Dashboard](https://beta.publishers.adsterra.com/api-token)
   - Copy Adsterra API

2. **Configure AdMetrics:**
   - Open AdMetrics app
   - Go to Settings
   - Enter API Token

4. **Add Widgets:**
   - Click the date/time in menu bar
   - Scroll down and click "Edit Widgets"
   - Find "AdMetrics" and drag widgets to your desktop
   - Choose from Small, Medium, or Large sizes

## Usage

### Main App
- Launch AdMetrics to view detailed statistics
- Refresh data with the refresh button
- Access settings to update credentials or preferences

### Widgets
- **Small Widget:** Quick balance overview with impressions and CPM
- **Medium Widget:** Balance with 7-day revenue trend line
- **Large Widget:** Complete dashboard with today's revenue, impressions, clicks, CTR, CPM, and weekly totals
- **Tap any widget** to open the main app

### Widget Updates
- Widgets automatically refresh every 15 minutes
- Data is cached for offline viewing
- Stale data indicator appears if refresh fails

## Requirements

- **macOS 14.0+** (Sonoma or later)
- **Xcode 15.0+** (for building from source)
- **Active Adsterra Account**

## Project Structure

```
AdMetrics/
├── AdMetrics/              # Main app target
│   ├── Services/           # API and data services
│   ├── Views/              # SwiftUI views
│   ├── Shared/             # Shared models and utilities
│   └── Assets.xcassets/    # App icon and assets
├── AdMetricsWidget/        # Widget extension
│   ├── SmallWidgetView.swift
│   ├── MediumWidgetView.swift
│   ├── LargeWidgetView.swift
│   └── WidgetAPIService.swift
└── Shared/                 # Shared code between app and widgets
    └── Models/             # Data models
```

## Building from Source

### Prerequisites
```bash
# Install Xcode from the App Store
xcode-select --install
```

### Build Steps
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/AdMetrics.git
cd AdMetrics

# Build for release
xcodebuild -scheme AdMetrics -configuration Release clean build

# The app will be in: build/Build/Products/Release/AdMetrics.app

# Install to Applications
cp -R build/Build/Products/Release/AdMetrics.app /Applications/
```

## Troubleshooting

### Widgets Not Updating
1. Remove old widgets from desktop (right-click → Remove Widget)
2. Kill widget service: `killall chronod`
3. Re-add fresh widgets from Widget Gallery

### Authentication Issues
1. Verify OAuth credentials in Settings
2. Check Google Cloud Console for API quota
3. Re-authenticate if needed

### App Icon Not Showing
```bash
# Clear icon cache
sudo rm -rf /Library/Caches/com.apple.iconservices.store
killall Dock Finder
```

## Privacy

AdMetrics respects your privacy:
- ✅ All data stored locally on your Mac
- ✅ Credentials secured in macOS Keychain
- ✅ No analytics or tracking
- ✅ No data sent to third-party servers
- ✅ Open source - audit the code yourself

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Built with SwiftUI and WidgetKit
- Uses Adsterra API
- Inspired by the need for beautiful macOS widgets

## Support

- 📧 Email: support@admetrics.app
- 🐛 Issues: [GitHub Issues](https://github.com/YOUR_USERNAME/AdMetrics/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/YOUR_USERNAME/AdMetrics/discussions)

## Roadmap

- [ ] Support for multiple Adsterra accounts
- [ ] Customizable widget themes
- [ ] Export data to CSV
- [ ] Monthly/yearly reports
- [ ] Menu bar quick stats
- [ ] Notifications for revenue milestones

---

Made with ❤️ for macOS
