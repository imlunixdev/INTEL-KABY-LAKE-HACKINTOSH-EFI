# Dell Inspiron 14 3481 — Ventura v2 test candidate

**Not a validated stable EFI. No Dell boot or hardware test has been performed. A verified USB map is still missing.**

Target: Core i3-8130U, UHD 620, 8 GB RAM, macOS Ventura 13.x. This build derives from the supplied Monterey EFI and uses official OpenCore 1.0.7 RELEASE.

The original Monterey EFI was preserved separately and is not included in this public package. The existing v1 release remains the known-working reference.

## Before booting

1. Read EFI_AUDIT.md and TESTING.md. Complete Dell hardware identification and USB mapping before treating this build as stable.
2. Generate your own MacBookPro14,1 SystemSerialNumber, MLB, SystemUUID and ROM in PlatformInfo/Generic. The supplied values are intentionally unusable placeholders; never use them for Apple services. Do not reuse an Ice Lake model's identifiers for this Kaby Lake profile. See [Dortania platform identity guidance](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/kaby-lake.html#platforminfo).
3. Run OpenCore 1.0.7 ocvalidate again after personalizing the config.
4. Test from a spare FAT32 USB EFI partition using Dell's one-time boot menu. Keep the working Monterey boot device available. No internal EFI partition has been modified by this audit.
5. This candidate enables SIP and Apple Secure Boot. Test with an unpatched Ventura installation. Do not use it to boot an installation requiring legacy root patches without reviewing that incompatibility first.

EFI.rar contains exactly one top-level EFI folder. It contains no private identifiers, documentation, alternative configs or debug logs. Documentation, ACPI source, validation results and a manifest accompany the archive in the repository.

Read [EFI_AUDIT.md](EFI_AUDIT.md), [WIFI_RESEARCH.md](WIFI_RESEARCH.md), [TESTING.md](TESTING.md) and [CHANGELOG-v2.md](CHANGELOG-v2.md).
