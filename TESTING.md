# Physical-machine test matrix

All items below are **NOT TESTED**. Static validation does not check these behaviors. No macOS access was available.

## Required before stable release

- [ ] Dell PCI IDs, codec, trackpad IDs, storage model and original firmware ACPI collected — NOT TESTED
- [ ] Actual USB ports mapped, connector types recorded, internal devices identified, <=15 ports/controller — NOT TESTED
- [ ] ACPI namespace collisions/CPU path verified against original tables — NOT TESTED
- [ ] Private identity generated for MacBookPro14,1 and config revalidated — NOT TESTED

- [ ] OpenCore picker — NOT TESTED
- [ ] Ventura installer boot — NOT TESTED
- [ ] Ventura normal boot — NOT TESTED
- [ ] iGPU acceleration / Metal and IOAccelerator — NOT TESTED
- [ ] internal display — NOT TESTED
- [ ] brightness — NOT TESTED
- [ ] brightness keys — NOT TESTED
- [ ] CPU turbo — NOT TESTED
- [ ] CPU idle states / package residency — NOT TESTED
- [ ] battery percentage — NOT TESTED
- [ ] battery charging — NOT TESTED
- [ ] AC adapter detection — NOT TESTED
- [ ] sleep — NOT TESTED
- [ ] wake — NOT TESTED
- [ ] lid sleep/wake — NOT TESTED
- [ ] keyboard — NOT TESTED
- [ ] trackpad — NOT TESTED
- [ ] gestures — NOT TESTED
- [ ] speakers — NOT TESTED
- [ ] headphones — NOT TESTED
- [ ] microphone — NOT TESTED
- [ ] Ethernet / DHCP — NOT TESTED
- [ ] USB 2 (each external port) — NOT TESTED
- [ ] USB 3 (each SuperSpeed port) — NOT TESTED
- [ ] webcam — NOT TESTED
- [ ] Bluetooth (cold boot and after wake) — NOT TESTED
- [ ] Wi-Fi (identify card first) — NOT TESTED
- [ ] shutdown — NOT TESTED
- [ ] restart — NOT TESTED
- [ ] NVRAM persistence — NOT TESTED
- [ ] audio after sleep — NOT TESTED
- [ ] Ethernet after sleep — NOT TESTED
- [ ] trackpad after sleep — NOT TESTED
- [ ] HDMI/external display — NOT TESTED
- [ ] video hardware decoding — NOT TESTED
- [ ] sleep battery drain — NOT TESTED

## Safe test sequence

Keep the known-working Monterey EFI on a separate boot device. Test the personalized candidate using a spare USB and Dell's one-time boot menu before replacing an internal EFI. Keep an alternative input/network path available because USB mapping and wireless are unresolved. Confirm current Ventura has no root patches requiring lowered SIP before using this candidate's security settings.

Capture original ACPI with the official ACPICA tools or an OpenCore DEBUG SysReport in a separate diagnostic EFI. Never run the diagnostic EFI as the normal release. Use USBToolBox on Windows or a supported macOS mapping workflow; test every receptacle with both USB 2 and USB 3 devices. Record webcam/Bluetooth rather than inferring port numbers.

## macOS measurements (run on Dell)

```
sw_vers
system_profiler SPDisplaysDataType SPAudioDataType SPNVMeDataType SPSerialATADataType
sysctl machdep.xcpm.mode
ioreg -r -c X86PlatformPlugin -l
ioreg -r -c IOAccelerator -l
pmset -g assertions
pmset -g custom
pmset -g log
vm_stat
sysctl vm.swapusage
sudo kmutil showloaded
sudo powermetrics --samplers cpu_power -i 1000 -n 30
log show --last 30m --style compact --predicate 'process == "kernel"'
```

Verify sampler availability with `powermetrics --help` on the installed OS. No unsupported sampler output should be interpreted as a hardware failure. Inspect IORegistry for loaded AppleIntelKBLGraphics/IOAccelerator and actual framebuffer connectors; a VRAM label alone is not proof of acceleration. Confirm battery/adapter state over repeated plug/unplug transitions.

Measure at idle after indexing settles and under the same workload on AC and battery. Record temperature, turbo/scaling, package watts/residency, UI latency, memory pressure/swap and storage activity. Check Spotlight progress and thermal throttling. Use a sustained network transfer and counters to check Ethernet, then repeat after sleep. Test at least five lid cycles, AC/battery transitions and an overnight sleep drain measurement. Do not change pmset merely to hide wake failures.

Raw IORegistry/system reports may contain private identifiers: keep them local until sanitized. Collect-Dell-Hardware.ps1 records only selected hardware fields but still merits review before sharing.
