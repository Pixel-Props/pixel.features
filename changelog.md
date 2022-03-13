**2022-03-13 (22031300)**
- Made a device_prefs directory where all the device preferences are stored and used by both the service and installer.
- Fixed a bug where [busybox](https://github.com/topjohnwu/Magisk/issues/5540#issuecomment-1059940824) could not read from a string (creating temp file instead). Which resulted in a fix of the [service.sh](https://github.com/Pixel-Props/pixel.features/blob/main/system/product/etc/sysconfig/service.sh) script.
- The installer now backs up Utils to the root MODPATH as it is used by the service.
- If does not have package the package is removed from the module.

**2022-03-03 (22030300)**
- Fixed [insert_gms_features()](https://github.com/Pixel-Props/pixel.features/blob/main/addon/SQLite3/install.sh) where variables were not defined which caused the service to not install flags properly.
- Added more flags to the [service.sh](https://github.com/Pixel-Props/pixel.features/blob/main/system/product/etc/sysconfig/service.sh)
- SDK checks installer. [privapp-permissions-google-p.xml](https://github.com/Pixel-Props/pixel.features/blob/main/system/product/etc/permissions/privapp-permissions-google-p.xml) will be removed from the module (Causing [Bootloop on A11](https://github.com/Pixel-Props/pixel.features/issues/3#issuecomment-1057879710)).
- The service.sh is still not working. I am opening an issue on the Magisk repo.

**2022-02-28 (22022801-22022802)**
- Enabling new Google Dialer pad on sqlite3 GMS
- Disabled uninstaller as it is too destructive for now
- Fixed installed package detection

**2022-02-28 (22022800)**
- Added Pixel GBoard Features
- Added support for Google Dialer Call Recording
- Detecting if the system has themed_bootanimation before installing monet version of the bootanimation
- SDK checks for NgaResources, DevicePersonalization and PixelWallpapers2021
- Previously the script was not installing packages, Now it has a proper [install_package()](https://github.com/Pixel-Props/pixel.features/blob/main/addon/Utils/install.sh).
- The script now automatically warns the user if there is a newer version of the script.
- Patching device_config flags and system prefs at [service.sh](https://github.com/Pixel-Props/pixel.features/blob/main/system/product/etc/sysconfig/service.sh)
- Checks for memory availability before using [GoogleCamera_6gb_or_more_ram.xml](https://github.com/Pixel-Props/pixel.features/blob/main/system/product/etc/sysconfig/GoogleCamera_6gb_or_more_ram.xml)
- Volume keys now have a fallback that re-assign new keys
- The installer now has an option to automatically install recommended settings
- Added [sepolicy](https://github.com/Pixel-Props/pixel.features/blob/main/sepolicy.rule) rules
- Added an [update.json](https://github.com/Pixel-Props/pixel.features/blob/main/update.json) for magisk updates
- Added a script [uninstaller](https://github.com/Pixel-Props/pixel.features/blob/main/uninstall.sh) that uninstall most of the features
- Installer addins are now in separate files
- A ton of other fixes and changes...

**2022-01-17 (220117)**
- Updated Dark BootAnimation to the new Dark Monet BootAnimation (might not be working before dec.2021 patch)
- Added Sailfish Pixel Props in order to add Unlimited GPhoto at Original Quality (**[REF](https://t.me/PixelProps/105)**)
- Added Quick Tap to sysconfig
