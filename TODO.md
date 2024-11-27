# MSET9 Installer Todo

### Todo

- [ ] Show current status clearly in app
- [ ] Auto SD card detection for desktop (with disks_desktop)
- [ ] SD card monitoring for auto checking status
  - [x] Android implemented
  - [ ] Desktops - partially
- [ ] Check if drive is mounted with utf8 option for Linux and prompt for remount automatically
- [ ] SD read-only check after folder picked
- [ ] Check if user extracted files in wrong location (like inside Nintendo 3DS)
- [ ] Eject/umount SD card after setup/inject
- [ ] root_check.dart
  - [ ] Add github release support
  - [ ] Implement streamed zip decoder properly
- [ ] Add movable.sed support for directly making valid title db (mainly for CHN console)
- [ ] iOS support
  - [ ] Implement folder picker and scoped uri fs wrapper
  - [ ] TrollStore folder picker issue, maybe unsandboxed version that can list/access SD card directly
- [ ] Fully guided exploit, maybe integrate guide in app somehow
- [ ] CLI support

### In Progress

- [ ] Replace and phasing out MSET9Installer4Android on Play Store

### Done ✓

- [x] Auto release with GitHub Actions
- [x] Proper credits
