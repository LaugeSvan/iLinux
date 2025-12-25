# iLinux

<img src="icon.svg" width="100" height="100">

**macOS-inspired Linux installer**
by **SalsaCat**

<div style="background-color:#ffdddd; border-left:6px solid #ff0000; padding:12px; margin-top:12px; margin-bottom:12px;">
  <strong>⚠️ WARNING: EXPERIMENTAL AND UNTESTED</strong><br><br>
  <strong>iLinux is experimental and has not been fully tested yet.</strong><br><br>
  While the installer is written using known tools and established themes, it has not been verified on real hardware or across multiple distributions.<br><br>
  In theory, the script should work on supported systems. In practice, things may break.
</div>

You should:

* Read the script before running it
* Test in a virtual machine or non-critical environment
* Expect bugs, partial installs, or manual cleanup

By running iLinux, you acknowledge that you are using **untested software**.

---

## Tested distributions

iLinux will include a **tested distributions list** once real-world testing begins.

This section will clearly document:

* Distribution name
* Version
* Desktop environment
* Tested status

Until this list exists, **no distribution should be considered officially tested or supported**, even if it is theoretically compatible.

---

## Overview

iLinux is an interactive shell script that transforms a GNOME-based Linux system into a macOS-like desktop experience.

It automates the installation of themes, icons, fonts, docks, animations, and tweaks while still giving the user control. The goal is visual consistency and a familiar workflow, not pretending Linux is macOS internally.

---

## Features

* Interactive terminal installer
* One-key **Recommended** install or fully **Custom** install
* macOS-style GTK themes
* macOS-style icon packs
* macOS-style cursor themes
* Centered dock similar to macOS
* Smooth animations and rounded corners
* macOS wallpapers
* Automatic application of settings

All handled through a single script.

---

## Supported systems

**Currently supported**

* Ubuntu and Debian-based distributions
* GNOME desktop environment

Other desktop environments may be supported in the future.

---

## Installation

Clone the repository and run the installer.

```bash
git clone https://github.com/LaugeSvan/iLinux.git
cd iLinux
chmod +x macos.sh
sudo ./macos.sh
```

---

## Installation modes

When the script starts, you will be prompted to choose an installation mode.

### Recommended install (R)

Installs the curated setup chosen by the project.

Includes:

* WhiteSur GTK theme
* WhiteSur icon theme
* WhiteSur cursor theme
* Inter font as a San Francisco alternative
* macOS Big Sur wallpaper
* Dock, animations, and rounded corners enabled

This is the fastest way to get the intended iLinux experience.

---

### Custom install (C)

Lets you choose each component individually.

You can select or skip:

* GTK theme
* Icon pack
* Cursor theme
* Wallpaper

Example menu:

```
1) WhiteSur
2) McMojave
0) Skip
```

This mode is recommended if you want control or already have parts installed.

---

## What this project is not

* This does not turn Linux into macOS
* This does not install Apple software
* This does not bypass licensing or DRM
* This does not aim for full macOS parity

iLinux focuses on **look and feel**, not identity.

---

## Philosophy

macOS aesthetics work because they are consistent, minimal, and predictable.
iLinux mirrors that philosophy while staying firmly within Linux and free software principles.

The script is modular, readable, and intentionally opinionated. You are encouraged to fork it and adapt it to your own preferences.

---

## GPL Compliance Notice

iLinux is licensed under the **GNU General Public License v3.0 or later**.

Any redistribution, modification, or derivative work must:

* Remain GPLv3 compatible
* Include source code
* Preserve copyright notices
* Preserve this license

Closed-source redistribution is not permitted.

This project intentionally enforces copyleft.

---

## Contributing

Pull requests are welcome.

Good contributions include:

* New GTK themes
* New icon packs
* New cursor themes
* Wallpapers
* GNOME compatibility improvements
* Script safety improvements

All contributions must be GPLv3 compatible.

See `CONTRIBUTING.md` for details.

---

## License

**GNU General Public License v3.0 or later**

See the `LICENSE` file for full license text.

---

## Credits

* WhiteSur and McMojave themes by vinceliuice
* Inter font by Rasmus Andersson
* GNOME developers and extension authors