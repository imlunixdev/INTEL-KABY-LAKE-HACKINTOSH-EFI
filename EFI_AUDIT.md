# EFI audit — Ventura v2 candidate

## Scope and evidence

Audit date: 2026-09-10. Source: supplied Documents/EFI. Target hardware is user-reported Dell Inspiron 14 3481/P75F, i3-8130U, UHD 620 and 8 GB RAM. The executing Windows machine identified itself as an ASUS Ryzen desktop, so none of its device IDs were attributed to the Dell. No Dell DSDT/SSDT dump, IORegistry capture, codec dump, port map, storage model or PCI inventory was supplied. Repository main contained a README only, at 22d2b24282483331daa65f6622739539ad06a97e.

All 316 original files were backed up and verified with SHA-256 before edits. The source remains unchanged. The backup contains the owner's original identifiers and is PRIVATE: do not upload it. The v1 GitHub asset was not altered or re-audited; this privacy review covers the newly produced v2 files only.

**Status: statically validated candidate, not a stable machine-validated release.** Missing USB mapping and hardware evidence prevent completion of all requested phases. No performance, battery, network, acceleration or sleep improvement is claimed as measured.

## Bootloader and configuration

Original binary identifies as `OpenCore-Mod-92338e42-2025-10-12-304403268`, with a placeholder `REL-XXX-YYYY-MM-DD | MOD` banner. Its exact upstream semantic version cannot be established from the supplied binary. It is not correctly described as stock OpenCore 1.0.6 or 1.0.7.

Replaced BOOTx64.efi, OpenCore.efi and the driver stack with byte-for-byte official **OpenCore 1.0.7 RELEASE** files. Upstream latest was checked; 1.0.7 was the current stable release returned. Reviewed its changelog: EDK II refresh, SMBIOS firmware updates, and a Tahoe USB-port-limit compatibility change. The latter is deliberately not used.

Migrated against the same release's Sample.plist and authoritative Configuration documentation. Removed mod-only ACPI/Quirks/EnableForAll and Booter/Quirks/EnableForAll. Removed inactive manually populated DataHub/PlatformNVRAM/SMBIOS identity sections in Automatic mode. Reviewed arbitrary DeviceProperties and NVRAM maps separately from schema keys; did not retain example-only NVRAM entries from Sample.plist. Disabled serial custom configuration was reduced to official defaults.

Original config failed official ocvalidate with two unsupported EnableForAll keys. Final config passes matching ocvalidate 1.0.7 with no issues. This validates the schema, not firmware behavior or macOS driver function.

Drivers: HfsPlus, OpenCanopy, OpenRuntime, ResetNvramEntry became OpenHfsPlus, OpenRuntime, ResetNvramEntry, all from one official release. Built-in text picker replaces the graphical picker; unused theme/audio/image resources were removed. OpenHfsPlus provides HFS support without retaining a binary of unclear version; HFS scanning speed may differ. No UEFI tools are loaded.

## ACPI

Original MaLd0n.aml is a 1,629-byte SSDT (OEM table Mob 1.2), not a replaced DSDT. Decompiled with ACPICA iASL 20260408. It provides XOSI, GPIO globals, synthetic EC, PNLF, USBX, ALS0, MCHC, XSPI, MAC1, SMBus devices, conditional CPU plugin-type and an XHC.RHUB disable method.

Candidate SSDT-Baseline.aml is 1,031 bytes, derived directly from that source. Source is included and original author credited. Removed synthetic ALS0/MCHC/XSPI/MAC1/SMBus devices that had no supplied hardware justification, and removed RHUB hiding so firmware USB ports can be investigated without USBInjectAll. Guarded writes to GPHD and GPEN with CondRefOf to avoid writing absent objects. Kept existing Darwin guards, synthetic EC, PNLF UID 16, USBX power values, XOSI and conditional CPU plugin-type implementations for the original three CPU paths. Kept the inherited _OSI-to-XOSI rename so the input baseline is not silently switched to another OS path.

This is a reduced baseline, **not proof that these ACPI paths exist in the Dell firmware**. Existing external declarations are not a firmware dump. CPU helper injection remains conditional and may do nothing if the actual CPU object path/type differs. Check for existing _DSM, EC, PNLF, USBX and _STA collisions against original Dell tables before promotion. Do not add SSDT-PLUG, EC, PNLF or XOSI on top of this file; that would duplicate functions.

No RTC/AWAC fix, battery field patch, new GPIO interrupt patch, _PRW rename list or DSDT replacement was invented. Final compilation has zero errors, zero warnings and three harmless unused-argument remarks for PMPM's preserved four-argument calling convention. This is syntax verification only.

## CPU and SMBIOS

Changed MacBookPro16,2 (Ice Lake) to MacBookPro14,1, a Ventura-supported dual-core mobile Kaby Lake profile. This is a closer CPU generation/topology/power-class match to the reported i3-8130U. It is not selected as a speed trick. Automatic OpenCore identity generation is retained, using sanitized Generic fields. Custom SMBIOS update mode and its matching CustomSMBIOSGuid quirk remain paired to keep SMBIOS changes scoped to macOS.

Retained conditional plugin-type=1 and AppleXcpmCfgLock=true because actual CFG Lock state is unknown. AppleCpuPmCfgLock=false, AppleXcpmExtraMsrs=false, AppleXcpmForceBoost=false, DummyPowerManagement=false, and empty CPUID masks remain unchanged. No CPUFriend, altered FrequencyVectors, turbo cap, forced boost or CPU spoof was added. XCPM attachment, idle residency, package watts, scaling and turbo require measurement; none has been confirmed remotely.

## Graphics

Retained baseline `PciRoot(0x0)/Pci(0x2,0x0)`, AAPL,ig-platform-id bytes 0000c087 (0x87C00000) and device-id bytes 16590000 (0x5916). WhateverGreen's framebuffer reference identifies 0x87C00000 as a Kaby Lake mobile framebuffer with three connectors. That confirms it is a real mobile framebuffer, not that it matches every wire on this Dell. The device-id is an injected compatibility ID, **not the measured native PCI ID**.

Retained baseline framebuffer-patch-enable, stolenmem=00003001 (19 MiB), fbmem=00009000 (9 MiB), and connector 1's 12-byte HDMI override. These preserve the working internal-display baseline while DVMT and connector topology remain unknown. Removed connector 2 override and its enable flag: the original alldata was a literal string containing angle brackets, not 12-byte Data, and no Dell connector evidence supported activating a corrected override. A future external-display test may establish the correct port; none was invented here.

Retained igfxonln=1 pending wake tests. Removed agdpmod=vit9696 with the move to the iGPU-only Kaby Lake model, and removed -wegnoegpu because the target brief lists no discrete GPU. Capture full PCI inventory to confirm the latter assumption. Acceleration, video decoding, display brightness and HDMI remain NOT TESTED. No 7 MB graphics claim or FPS claim is made.

## Battery, input, audio, Ethernet and storage

VirtualSMC and its battery/CPU sensor plugins now come from the official 1.3.7 release rather than unproven 1.3.8 snapshots. ECEnabler 1.0.6 is retained: it supports access to EC fields wider than a byte and can avoid battery field splitting. Actual EC registers and battery behavior were not available. No new battery hotpatch was added. Removed SMCLightSensor and the associated synthetic constant-value ALS device; no physical ambient-light sensor was established.

Retained the baseline combination of PS/2 keyboard and I2C HID trackpad. Shipped VoodooPS2Controller + keyboard plugin only, VoodooI2C with GPIO/Services dependencies, I2CHID, and exactly one VoodooInput (from the I2C release). Removed competing PS/2 mouse/trackpad plugins and duplicate VoodooInput. Retained -vi2c-force-polling until ACPI interrupt routing can be checked; polling may affect idle power, so battery optimization cannot yet be claimed. BrightnessKeys remains for laptop brightness events. Actual touchpad identity and post-wake gestures are unconfirmed.

AppleALC updated to 1.9.7. `alcid=3` is preserved as a **baseline selection, not a detected codec/layout**. The audio codec and HDEF PCI path are unknown; moving it to a guessed DeviceProperties path would violate the evidence requirement. Once the codec and working layout are confirmed, migrate this argument to its actual device path.

RealtekRTL8100 2.0.1 was retained byte-for-byte from the supplied working EFI. Its match is 10ec:8136, consistent with the reported RTL8106 family, but not a Dell PCI measurement. Upstream is archived. No newer dependable driver was established, and Ventura runtime operation is NOT TESTED. Its disableASPM=true, EEE, checksum and segmentation settings are unchanged; do not enable ASPM solely for battery savings without testing this controller. IntelMausi was removed because the stated Ethernet hardware is Realtek.

NVMeFix 1.1.4 removed from the default candidate because the Dell's storage controller/model is unknown. Its presence in the old EFI does not prove that an NVMe disk exists. The baseline SATA compatibility property `pci8086,a182` at PCI 17,0 is retained pending actual storage identification, avoiding an unverified storage-path change. If a third-party NVMe controller is confirmed, evaluate official NVMeFix and APST behavior separately. No TRIM, NVMe ASPM or latency overrides were added.

## USB and sleep — unresolved release gates

Removed USBInjectAll and XHCI-unsupported; disabled XhciPortLimit. Removed the baseline ACPI RHUB disable. **No correct USB map exists in the supplied files, and none was fabricated.** The candidate exposes firmware/native topology for investigation; it does not guarantee that all external ports, internal webcam or Bluetooth are available within the 15-port limit.

Create a Dell-specific map using physical USB 2 and USB 3 insertion tests, identify internal devices and type 255 connectors, then add the generated map and its required driver. Verify no more than 15 ports per controller. A generic map from another Inspiron is not sufficient. This is required before calling the EFI stable.

Removed PowerTimeoutKernelPanic=true to avoid suppressing symptoms of failed power transitions, and removed the unsupported-by-evidence LAPIC panic suppression. Retained existing DisableRtcChecksum as a conservative baseline firmware safeguard pending RTC testing. No wake success, lid behavior, black-screen fix or sleep-drain improvement has been demonstrated.

## Remaining configuration rationale

Booter memory-map quirks are preserved from the working baseline: AvoidRuntimeDefrag, EnableSafeModeSlide, EnableWriteUnprotector, ProvideCustomSlide, SetupVirtualMap and SyncRuntimePermissions. RebuildAppleMemoryMap remains false; memory-attributes support is not available to justify changing the combination. GPU BAR resize settings remain -1. The official manual makes these firmware-dependent; no blanket laptop quirk preset was substituted.

DisableIoMapper remains true; DisableIoMapperMapping was turned off because the separate mapping quirk has no purpose while AppleVTD is disabled. DisableLinkeditJettison remains true for Lilu operation; PanicNoKextDump retains the original panic-display behavior. All other unmentioned Kernel and Booter settings are unchanged except schema migration. Full before/after settings and file inventory are provided in CONFIG_DIFF.json and INVENTORY.json.

UEFI KeySupport, ProvideConsoleGop, RequestBootVarRouting and baseline USB ownership/UnblockFsConnect settings are retained pending firmware tests. APFS MinDate/MinVersion remain -1 as inherited compatibility settings; these remove minimum APFS-driver version restrictions and are not a performance optimization. FadtEnableReset and ResetLogoStatus remain inherited ACPI quirks. Legacy NVRAM emulation is unused and firmware NVRAM persistence needs testing.

## Security and cleanup

Removed all original unique SMBIOS values from every public file, including inactive identity sections. Generic serial/MLB say GENERATE; UUID and ROM are zero. These require local personalization. Restored csr-active-config=00000000 and SecureBootModel=Default; no AMFI-disable flags or OCLP root patches are included. NVRAM Delete explicitly replaces stale boot arguments/SIP state and clears old revpatch and fake Bluetooth variables. Removed RestrictEvents and revpatch=sbvmm,diskread because the chosen model supports Ventura without update/model bypasses. Original boot arguments were repeated twice; final arguments are only `alcid=3 igfxonln=1 -vi2c-force-polling`. Removed verbose/watchdog suppression and unused resource/metadata files.

## What must be measured

No macOS shell was available. Compare stock Monterey and this candidate under equal AC/battery, temperature and workload conditions. Confirm Metal/IOAccelerator first; then X86PlatformPlugin attachment and XCPM, CPU/package power, thermal limits, storage health/latency, kernel retries, sleep assertions and actual sleep drain. Separate Spotlight indexing, RAM/swap pressure and thermal/storage limitations from EFI defects. An 8 GB machine can still swap under normal application load.

## Sources

- [Official OpenCore 1.0.7 release](https://github.com/acidanthera/OpenCorePkg/releases/tag/1.0.7)
- [OpenCore 1.0.7 Configuration source](https://github.com/acidanthera/OpenCorePkg/blob/1.0.7/Docs/Configuration.tex)
- [WhateverGreen Intel graphics reference](https://github.com/acidanthera/WhateverGreen/blob/1.7.0/Manual/FAQ.IntelHD.en.md)
- [Dortania Kaby Lake laptop configuration](https://dortania.github.io/OpenCore-Install-Guide/config-laptop.plist/kaby-lake.html)
- [ECEnabler](https://github.com/averycblack/ECEnabler), [NVMeFix](https://github.com/acidanthera/NVMeFix)
- [RealtekRTL8100 upstream](https://github.com/Mieze/RealtekRTL8100)
- [USBToolBox](https://github.com/USBToolBox/tool), [USB mapping](https://dortania.github.io/OpenCore-Post-Install/usb/)

## Complete loaded kext versions

Numerically lower versions replace unverified development snapshots with official stable RELEASE packages. VoodooI2CHID bundle version remains 1 inside the 2.9.1 distribution.

| Kext | Before | After | Purpose |
| --- | --- | --- | --- |
| Lilu | 1.7.2 | 1.7.2 | Dependency for AppleALC/WhateverGreen and SMC plugins |
| AppleALC | 1.9.6 | 1.9.7 | Audio with retained baseline layout 3 |
| BrightnessKeys | 1.0.4 | 1.0.3 | Laptop brightness key events |
| ECEnabler | 1.0.6 | 1.0.6 | Retained EC field-access compatibility |
| RealtekRTL8100 | 2.0.1 | 2.0.1 | Reported RTL8106 Ethernet; preserve working driver |
| VirtualSMC | 1.3.8 | 1.3.7 | SMC emulation |
| SMCBatteryManager | 1.3.8 | 1.3.7 | Battery reporting |
| SMCProcessor | 1.3.8 | 1.3.7 | CPU sensor visibility |
| VoodooI2CServices | 1 | 1 | I2C dependency |
| VoodooGPIO | 1.1 | 1.1 | I2C GPIO dependency |
| VoodooI2C | 2.9.1 | 2.9.1 | Baseline I2C trackpad controller |
| VoodooInput | 1.1.7 | 1.1.6 | Single multitouch event provider |
| VoodooI2CHID | 1 | 1 | Baseline HID trackpad satellite |
| VoodooPS2Controller | 2.3.8 | 2.3.7 | Baseline PS/2 keyboard controller |
| VoodooPS2Keyboard | 2.3.8 | 2.3.7 | PS/2 keyboard |
| WhateverGreen | 1.7.1 | 1.7.0 | Intel framebuffer and graphics compatibility |

Removed: IntelMausi 1.0.9; NVMeFix 1.1.4; RestrictEvents 1.1.7; USBInjectAll 1.0; XHCI-unsupported 1.0; SMCLightSensor 1.3.8.
