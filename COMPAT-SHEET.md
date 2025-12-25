# iLinux Compatibility Matrix

This document tracks **real-world tested compatibility** for iLinux.

Only entries listed here should be considered tested.
If a distribution is not listed, it is **not tested**, even if it is theoretically compatible.

---

## Status badges

<!-- Replace placeholders with real badges after testing -->

![Project Status](https://img.shields.io/badge/status-experimental-red)
![Maturity](https://img.shields.io/badge/maturity-alpha-orange)
![Testing Coverage](https://img.shields.io/badge/testing-incomplete-yellow)
![Stability](https://img.shields.io/badge/stability-unstable-red)

---

## Desktop environment compatibility

<!-- Enable badges when tested -->

![GNOME](https://img.shields.io/badge/GNOME-supported-brightgreen)
![KDE](https://img.shields.io/badge/KDE-unstable-red)
![XFCE](https://img.shields.io/badge/XFCE-not_tested-lightgrey)

---

## Tested distributions table

| Distribution | Version | Desktop Environment | Install Mode | Components Tested                 | Result               | Notes                 | Logs / Screenshots                                  |
| ------------ | ------- | ------------------- | ------------ | --------------------------------- | -------------------- | --------------------- | --------------------------------------------------- |
| Ubuntu       | 24.04   | GNOME 45            | R            | GTK theme, Icons, Dock, Wallpaper | ⚠️ Works with issues | Dock icons misaligned | [screenshot.png](assets/screenshots/screenshot.png) |
| Debian       | 12      | GNOME 44            | C            | GTK theme, Icons                  | ✅ Tested             | None                  |                                                     |
| Linux Mint   | 21      | Cinnamon 6.4        | R            | GTK theme                         | ❌ Untested           | VM not available      |                                                     |

> Replace example rows with your actual test results.

---

## Component-level compatibility (Shields.io)

<!-- Enable badges as components are tested -->

![GTK Themes](https://img.shields.io/badge/GTK_themes-working-brightgreen)
![Icon Themes](https://img.shields.io/badge/icons-working-brightgreen)
![Cursor Themes](https://img.shields.io/badge/cursors-working-brightgreen)
![Dock](https://img.shields.io/badge/dock-partial-yellow)
![GNOME Extensions](https://img.shields.io/badge/extensions-unstable-red)

---

## Script behavior badges (Shields.io)

<!-- Optional -->

![Non-destructive](https://img.shields.io/badge/non--destructive-yes-brightgreen)
![Requires sudo](https://img.shields.io/badge/requires-sudo-blue)
![Interactive installer](https://img.shields.io/badge/installer-interactive-blue)
![Automation](https://img.shields.io/badge/automation-partial-yellow)

---

## Legend

* ✅ Tested and working
* ⚠️ Works with issues
* ❌ Untested or broken

---

## Notes

* Always link screenshots or logs for clarity
* Only merge verified test results
* Keep the experimental warning in mind