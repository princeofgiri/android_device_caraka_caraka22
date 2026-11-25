# Device Tree: CARAKA-22 (MT6765)

Android Device Tree untuk **CARAKA-22** (ODM: Tintele DT965 / Project K608 / RC04) berbasis MediaTek MT6765, dirancang untuk kompatibilitas **LineageOS 23.2** / **SymbiotOS** (Android 16).

---

## 1. Spesifikasi Hardware

* **SoC**: MediaTek MT6765 (Helio P35 / G35 / G37)
* **Arsitektur**: ARM64 (`arm64-v8a`, 64-bit non-zygote force)
* **Kernel Baseline**: Linux Kernel `4.19.191` (prebuilt di `prebuilts/kernel`)
* **DTBO**: Prebuilt `prebuilts/dtbo.img`
* **Skema Partisi**: Virtual A/B (V-A/B) + Dynamic Partitions (`super.img`, 8.79 GB)
* **Ukuran Partisi**:
  * `boot`: 32 MB (`0x2000000`)
  * `dtbo`: 8 MB (`0x800000`)
  * `super`: 8,792,064,000 bytes (`0x20c0c4000`)
* **Modul Walkie-Talkie (DMR)**:
  * Device node radio: `/dev/intercom_device`
  * UART baseband/MCU: `/dev/ttyS0`
  * System app: `com.android.walkietalkie` (UID 1000)

---

## 2. Struktur Device Tree

```text
device/caraka/caraka22/
├── Android.bp
├── AndroidProducts.mk
├── BoardConfig.mk
├── device.mk
├── lineage_caraka22.mk
├── symbiot_caraka22.mk
├── manifest.xml
├── product.prop
├── system.prop
├── vendor.prop
├── prebuilts/
│   ├── dtbo.img
│   └── kernel
├── rootdir/
│   ├── etc/
│   │   ├── fstab.mt6765
│   │   ├── init.recovery.mt6765.rc
│   │   └── init.walkietalkie.rc
│   └── usr/
│       └── keylayout/
│           └── mtk-kpd.kl
├── sepolicy/
│   └── vendor/
│       ├── device.te
│       ├── file_contexts
│       └── system_app.te
└── walkietalkie/
    ├── Android.bp
    ├── DMR-base.apk
    └── privapp-permissions-walkietalkie.xml
```

---

## 3. Cara Build di SymbiotOS

1. Masuk ke direktori root source code Android:
   ```bash
   cd /home/haris/android-source/SymbiotOS
   ```
2. Inisialisasi build environment:
   ```bash
   source build/envsetup.sh
   source vendor/symbiot/build/envsetup.sh
   ```
3. Pilih target device:
   ```bash
   lunch symbiot_caraka22-bp4a-userdebug
   ```
4. Mulai kompilasi:
   ```bash
   m bacon -j$(nproc)
   ```
