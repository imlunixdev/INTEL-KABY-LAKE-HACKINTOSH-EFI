# 8th Generation Intel processors EFI
**macOS EFI file** for **8th generation Intel processors** with **integrated graphics (iGPU)**
- Tested on a **Dell Inspiron 15 3481 (P75F)** laptop.
- Works with **macOS 12 (Monterey)**.

The EFI file contains **essential kexts and some Ethernet networking kexts**, such as **RealtekRTL8100.kext**. If you are experiencing Ethernet or Wi-Fi issues, please follow the necessary instructions on the [**Dortania**](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#ethernet) website.

The **config.plist file can be modified to better suit your hardware**; you should use [**ProperTree**](https://github.com/corpnewt/ProperTree) to facilitate its configuration.

**⚠️ Warning!** From the moment you **modify any essential kext within the EFI**, support provided on our [**official Discord server**](https://discord.gg/6rMYgGhpma) will no longer be available.

All credit goes to [**Olarila Hackintosh**](https://olarila.com/), who provided the source code for this EFI.
