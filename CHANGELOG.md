# Changelog

All notable changes to iLinux will be documented here.

---

## [1.1.0] - 2026-04-25

### Fixed
- Inter font download was hardcoded to v3.21 which no longer exists — now fetches the latest release automatically via the GitHub API
- Wallpaper URLs pointed to a broken Apple CDN — replaced with `vinceliuice/WhiteSur-wallpapers` served from GitHub raw
- Script would silently exit mid-install due to `set -e` catching a failed `wget -q` with no error message
- `apply_settings` would pass an empty string to `gsettings cursor-theme` when cursor was skipped, potentially resetting it
- `$SUDO_USER` was not validated — running as plain root (without sudo) would install everything to `/root`
- Fonts were not registered after install (`fc-cache` was missing)
- `picture-uri-dark` gsettings key was not set, leaving dark mode wallpaper unchanged on GNOME 42+

### Added
- `gh_latest_asset()` helper — resolves the latest GitHub release download URL for any repo
- `gh_clone()` helper — clones a repo on first run, pulls latest on subsequent runs (no duplicate clones)
- Sudo guard at startup with a clear error message if not run correctly

### Changed
- Removed `-q` flag from `wget` calls so download failures are visible
- Git-cloned theme repos now update themselves on re-run instead of failing or duplicating

---

## [1.0.0] - 2025

### Added
- Interactive installer with single-keypress input
- Recommended and Custom install modes
- GTK theme support: WhiteSur, McMojave
- Icon theme support: WhiteSur, McMojave-circle
- Cursor theme support: WhiteSur
- Plank dock setup with centered alignment
- macOS wallpaper download (Big Sur, Ventura)
- GNOME tweaks: animations, rounded corners
- Automatic `gsettings` application for all chosen themes

### Notes
- Ubuntu/Debian + GNOME only
- Requires internet connection
