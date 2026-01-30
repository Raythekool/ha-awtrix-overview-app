# AWTRIX Overview App 🌡️💧🔋

[![GitHub Release][releases-shield]][releases]
[![License][license-shield]](LICENSE)
[![hacs][hacs-shield]][hacs]
[![Project Maintenance][maintenance-shield]][maintainer]
[![GitHub Activity][commits-shield]][commits]

[![Buy Me A Coffee][coffee-shield]][coffee]

A custom Home Assistant app for AWTRIX that displays temperature, humidity, and battery level on a single screen with icons and progress bar.

![AWTRIX Overview App](https://img.shields.io/badge/AWTRIX-3-blue?style=flat-square&logo=homeassistant)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Compatible-green?style=flat-square&logo=homeassistant)

## ✨ Features

- 🌡️ **Temperature** display with dynamic colors
- 💧 **Humidity** percentage
- 🔋 **Battery** level with progress bar
- 🎨 Color-coded values based on thresholds
- 📊 All data visible on a single screen (no rotation)
- 🎭 Optional icon support
- ⚡ Low battery warning with fade effect
- 🔄 Auto-refresh on sensor changes

## 📸 Display Layout

**Option 1: Battery Bar at Bottom**
```
┌────────────────────────────────┐
│  🏠 22.5° 45%                  │
│  ██████████████████████░░░░░░  │
└────────────────────────────────┘
  Temp & Humidity     Battery 85%
```

**Option 2: Battery Bar at Top**
```
┌────────────────────────────────┐
│  ██████████████████████░░░░░░  │
│  🏠 22.5° 45%                  │
└────────────────────────────────┘
  Battery 85%         Temp & Humidity
```

## 🚀 Installation

### Import Blueprint

1. Go to Home Assistant
2. Navigate to **Settings** → **Automations & Scenes** → **Blueprints**
3. Click **Import Blueprint**
4. Paste this URL:
   ```
   https://github.com/Raythekool/ha-awtrix-overview-app/blob/main/awtrix_overview_app.yaml
   ```

[![Open your Home Assistant instance and show the blueprint import dialog.](https://my.home-assistant.io/badges/blueprint_import.svg)](https://my.home-assistant.io/redirect/blueprint_import/?blueprint_url=https%3A%2F%2Fgithub.com%2FRaythekool%2Fha-awtrix-overview-app%2Fblob%2Fmain%2Fawtrix_overview_app.yaml)

## ⚙️ Configuration

### Required Parameters

- **AWTRIX Device**: Your AWTRIX 3 device(s)
- **Temperature Sensor**: e.g., `sensor.living_room_temperature`
- **Humidity Sensor**: e.g., `sensor.living_room_humidity`
- **Battery Sensor**: e.g., `sensor.phone_battery_level`

### Optional Parameters

- **Show Icon**: Display icon on the left (default: `false`)
- **Icon Name**: Icon to display (default: `home`)
- **Temperature Unit**: °C, °F, or ° (default: `°C`)
- **Bar Position**: top or bottom (default: `bottom`)
- **Text Color**: dynamic or fixed color (default: `dynamic`)
- **Refresh Interval**: 1-60 minutes (default: `5`)

## 🎨 Color Schemes

### Temperature Colors (Dynamic Mode)

| Temp | Color | Status |
|------|-------|--------|
| < 15°C | Blue | Cold |
| 15-20°C | Green | Cool |
| 20-25°C | Light Green | Comfort |
| 25-30°C | Orange | Warm |
| > 30°C | Red | Hot |

### Battery Bar Colors

| Level | Color | Effect |
|-------|-------|--------|
| > 60% | Green | None |
| 30-60% | Yellow | None |
| < 30% | Red | None |
| < 20% | Red | Fade |

## 🎨 Icons

See [ICONS_UPLOAD.md](ICONS_UPLOAD.md) for detailed instructions.

**Recommended icons from [LaMetric](https://developer.lametric.com/icons):**
- Temperature: `2289`, `53284`
- Humidity: `46633`, `2520`
- Battery: `9956`, `47188`
- Home: `2`, `19768`

**Quick upload:**
```bash
python upload_icons.py
```

## 🐛 Troubleshooting

**App not displaying:**
1. Check sensors are configured
2. Verify AWTRIX is online
3. Check MQTT topics in Developer Tools

**Icons not showing:**
1. Upload icons using provided scripts
2. Verify icon names match (case-sensitive)
3. Check AWTRIX web interface

**Colors not changing:**
1. Ensure sensors return numeric values
2. Set Text Color to "dynamic"

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

## ⭐ Support

Give a ⭐️ if this project helped you!

[![Buy Me A Coffee][coffee-shield]][coffee]

## 📄 License

MIT License - see [LICENSE](LICENSE)

## 🔗 Links

- [AWTRIX 3 Documentation](https://blueforcer.github.io/awtrix3/)
- [Home Assistant](https://www.home-assistant.io/)
- [LaMetric Icons](https://developer.lametric.com/icons)

## 👨‍💻 Author

**Marco Dodaro**

- GitHub: [@Raythekool](https://github.com/Raythekool)
- LinkedIn: [marcododaro](https://www.linkedin.com/in/marcododaro)

---

Made with ❤️ for the Home Assistant community

<!-- BADGES -->
[releases-shield]: https://img.shields.io/github/release/Raythekool/ha-awtrix-overview-app.svg?style=for-the-badge
[releases]: https://github.com/Raythekool/ha-awtrix-overview-app/releases
[license-shield]: https://img.shields.io/github/license/Raythekool/ha-awtrix-overview-app.svg?style=for-the-badge
[hacs-shield]: https://img.shields.io/badge/HACS-Custom-orange.svg?style=for-the-badge
[hacs]: https://github.com/hacs
[maintenance-shield]: https://img.shields.io/badge/maintainer-Marco%20Dodaro-blue.svg?style=for-the-badge
[maintainer]: https://github.com/Raythekool
[commits-shield]: https://img.shields.io/github/commit-activity/y/Raythekool/ha-awtrix-overview-app.svg?style=for-the-badge
[commits]: https://github.com/Raythekool/ha-awtrix-overview-app/commits/main
[coffee-shield]: https://img.shields.io/badge/buy%20me%20a%20coffee-donate-yellow.svg?style=for-the-badge
[coffee]: https://www.buymeacoffee.com/marcodod
