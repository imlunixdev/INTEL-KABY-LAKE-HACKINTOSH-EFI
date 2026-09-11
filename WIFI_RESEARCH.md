# Qualcomm Wi-Fi and Bluetooth research

## Actual card identification

**Exact chipset: UNKNOWN. PCI vendor/device ID: UNKNOWN. Subsystem ID: UNKNOWN. ACPI/PCI path: UNKNOWN. Bluetooth USB VID:PID: UNKNOWN.**

The provided EFI contains no Qualcomm DeviceProperties, wireless driver, hardware inventory or IORegistry dump. Its single SSDT contains no WLAN hardware ID. The executing host is an ASUS AMD desktop, not the Dell. Dell family specifications cannot identify this particular adapter, so no chipset has been assumed and no spoof has been installed.

Use Collect-Dell-Hardware.ps1 on the Dell under Windows to capture hardware IDs and location paths. Under Linux use `lspci -nnk`, `lspci -t`, and `lsusb`; under macOS use IORegistry plus PCI enumeration. Capture PCI vendor/device/subsystem, device revision and the bridge path. Bluetooth has a separate USB identity. Windows instance paths and Linux bus addresses must not be directly mistaken for OpenCore PciRoot paths without translating the bridge hierarchy.

## Family-specific findings

| Possible family | Identification clue, not this machine's measured ID | Evidence and Ventura status |
| --- | --- | --- |
| AR9565/QCA9565 | 168c:0036 in Linux ath9k and ATH9KInjector | Legacy AR9K patches exist. Not a ready-to-use stock Ventura solution; exact ID, old driver dependencies and current OS build must be checked. |
| QCA9377 | Commonly 168c:0042; hardware revision matters | ath10k family. No reliable functioning macOS driver established by this research. |
| QCA6174/QCA61x4A | Commonly 168c:003e; inspect revision/subsystem too | ath10k family. No reliable functioning macOS driver established by this research. |

Linux's ath10k header also names 0042 under a QCA6174 revision constant, so a single ID lookup is not a sufficient exact-card identification. Read the actual driver probe/revision and module information. Dell marketing names alone are not proof.

For a card positively identified as QCA9377 or QCA6174/QCA61x4A, the conservative result is:

**UNSUPPORTED WITH CURRENT RELIABLE MACOS DRIVERS**

For this particular laptop the conclusion remains **IDENTIFICATION PENDING**. It would be incorrect to assign that conditional unsupported result to an unidentified adapter as if detection had occurred.

## Driver/source investigation

Reviewed maintained upstream driver references, current search results for Qualcomm macOS/IOKit/ath10k projects, ATH9KFixup source metadata, OpenCore Legacy Patcher's wireless patch selection, AthBluetoothFirmware USB matching and Linux ath9k/ath10k identifiers.

ATH9KFixup's available source continuation lists AR946x, AR9485 and AR9565. Its injector matches 168c:0032/0033/0034/0036/0037 and depends on the old AirPortAtheros40 family. The historical instructions target much older macOS releases and are not a verified Ventura installation recipe. They do not implement an ath10k driver for QCA9377/QCA6174. No binary was downloaded or installed from this project.

Linux ath10k is a mac80211 driver; OpenBSD/Linux code and firmware blobs are not macOS kexts. A Linux kernel module cannot be repackaged into IOKit by changing an Info.plist. The 8devices QCA9377 project produces Linux USB/SDIO modules, not a macOS PCIe driver. OpenIntelWireless itlwm targets Intel adapters, not Qualcomm. No source-backed, reliably functional Ventura IOKit/DriverKit port matching QCA9377/QCA6174 was established. This is a bounded research conclusion, not a claim that no future or private driver could ever exist.

Spoofing 003e/0042 to an AR9K ID would only alter matching; it cannot implement missing firmware/protocol support. An AirPort label is not a successful radio, scan, authentication or traffic test.

## If AR9565 is confirmed

Keep investigation on a separate spare boot drive and installation. First establish the exact PCI ID and Bluetooth ID. Audit the compatible legacy AirPortAtheros40 stack, required injector/fixup and Ventura kernel-collection dependencies against the exact 13.x build. Then determine whether the networking userspace requires the corresponding root patches. Do not combine unrelated patched IO80211 copies from random EFI archives.

OCLP's current LegacyWireless code specifically recognizes AirPortAtheros40-class hardware; it does not make all Qualcomm chips supported. On Monterey and newer it replaces airportd/WiFiAgent components; on Ventura and newer it also supplies networking frameworks/helpers. The code contains build-specific handling after Ventura 13.6.5. This illustrates why an EFI-only filename swap is insufficient. OCLP targets supported real-Mac patching scenarios; applying its assets to a Hackintosh needs separate compatibility analysis.

Root-volume changes can require reduced SIP/authenticated-root protections and version-specific AMFI handling, and may have to be reapplied after OS updates. Exact requirements must be derived from the selected patchset and OS build; no blanket SIP/AMFI-disabling recipe is provided for this unidentified card. The candidate has full SIP and no such changes. No optional experimental kext is included without a confirmed hardware match.

Validate cold-boot firmware initialization, scanning, WPA authentication, DHCP, sustained traffic, reconnect and sleep/wake on the exact laptop before enabling anything by default.

## Bluetooth is separate

Reviewed zxystd/AthBluetoothFirmware, an Atheros firmware uploader with USB ID-specific personalities (52 entries in the reviewed Info.plist). This is not evidence that the Dell's unknown Bluetooth controller is supported, nor a Wi-Fi driver. A matching ID, firmware revision, Ventura transport compatibility and cold-boot test are necessary. A controller that works only after booting Windows may merely retain firmware, so warm-boot success is insufficient.

Do not install IntelBluetoothFirmware or Broadcom firmware for Qualcomm. Internal Bluetooth USB mapping/type 255 must be established before diagnosing firmware. No Bluetooth firmware or fake controller NVRAM data is shipped. Bluetooth may be independently usable even when Wi-Fi is unsupported, but that has not been demonstrated here.

## Sources checked

- [Dortania chipset support](https://dortania.github.io/Wireless-Buyers-Guide/unsupported.html)
- [ATH9KFixup source](https://github.com/black-dragon74/ATH9KFixup) and [injector matching](https://github.com/black-dragon74/ATH9KFixup/blob/master/ATH9KInjector.kext/Contents/Info.plist)
- [Linux ath10k hardware IDs](https://github.com/torvalds/linux/blob/master/drivers/net/wireless/ath/ath10k/hw.h) and [ath9k PCI matching](https://github.com/torvalds/linux/blob/master/drivers/net/wireless/ath/ath9k/pci.c)
- [Linux Wireless ath10k documentation](https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath10k.html)
- [8devices QCA9377 Linux driver](https://github.com/8devices/qcacld-2.0)
- [OpenIntelWireless](https://github.com/OpenIntelWireless/itlwm)
- [OCLP LegacyWireless source](https://github.com/dortania/OpenCore-Legacy-Patcher/blob/main/opencore_legacy_patcher/sys_patch/patchsets/hardware/networking/legacy_wireless.py)
- [Atheros Bluetooth source and matching](https://github.com/zxystd/AthBluetoothFirmware/blob/master/Ath3kBT/Info.plist)

Accessed during the 2026-09-10 audit. No wireless functionality tested.
