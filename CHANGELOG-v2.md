# v2 — Ventura candidate

- Replaced the unidentified OpenCore-Mod build with official OpenCore 1.0.7 RELEASE and migrated the config schema.
- Replaced snapshot/unverified kexts with traceable upstream stable builds; retained baseline RealtekRTL8100 2.0.1.
- Selected Ventura-supported MacBookPro14,1; sanitized public identity fields and restored SIP/Apple Secure Boot settings.
- Reduced the inherited SSDT, removed generic synthetic devices/RHUB hiding and guarded GPIO global writes. Firmware validation remains pending.
- Removed malformed, unverified connector 2 injection; kept the existing internal graphics framebuffer and DVMT baseline.
- Removed duplicate/debug boot arguments, RestrictEvents, IntelMausi, unconfirmed NVMeFix, USBInjectAll, XHCI-unsupported and the port-limit patch.
- Kept one input event provider and rebuilt dependency order. Retained PS/2 keyboard plus I2C HID baseline.
- Simplified picker/UEFI drivers and removed unused resources and metadata.
- Matching ocvalidate passes; ACPI compiles with no errors/warnings.
- No measured performance, battery, sleep, acceleration or Wi-Fi improvement claimed. USB mapping and Dell hardware identification are release gates. Wi-Fi/codec/native graphics IDs remain unidentified.
