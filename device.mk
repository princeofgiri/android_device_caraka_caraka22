#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/caraka/caraka22

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota/compression.mk)

# Dynamic Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_RETROFIT_DYNAMIC_PARTITIONS := false

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# API levels & Kernel VINTF override (stock kernel is 4.19.191)
PRODUCT_SHIPPING_API_LEVEL := 31
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# VNDK legacy compat (Android 12 vendor blobs on Android 16 platform)
PRODUCT_EXTRA_VNDK_VERSIONS := 31 32

# Boot, Health & Keymaster HALs (main boot from vendor blobs; health, recovery, charger + keymaster@4.1 from source)
PRODUCT_PACKAGES += \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.health-service.mediatek \
    android.hardware.health-service.mediatek-recovery \
    charger.recovery \
    android.hardware.keymaster@4.1-service

# IMS
$(call inherit-product, vendor/mediatek/ims/ims.mk)

# Update engine & fastbootd
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    fastbootd

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek \
    hardware/mediatek/libmtkperf_client

# Compatibility shims
PRODUCT_PACKAGES += \
    libbase_shim \
    libcamera_metadata_shim \
    libcam_utils_shim \
    libcrypto_shim.vendor \
    libdrm \
    libprocessgroup_shim \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat \
    libstagefright_foundation-v33 \
    libstagefright_foundation-v33.vendor \
    libtinyxml2-v34 \
    libutils-v32

# HAL & VNDK Compat Packages required by MT6765 vendor blobs
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor \
    android.hardware.audio@6.0.vendor \
    android.hardware.audio@7.0.vendor \
    android.hardware.audio@7.0-util.vendor \
    android.hardware.audio.common@5.0.vendor \
    android.hardware.audio.common@6.0.vendor \
    android.hardware.audio.common@6.0-util.vendor \
    android.hardware.audio.common@7.0.vendor \
    android.hardware.audio.common@7.0-enums.vendor \
    android.hardware.audio.common@7.0-util.vendor \
    android.hardware.audio.common-util.vendor \
    android.hardware.audio.effect@6.0.vendor \
    android.hardware.audio.effect@6.0-util.vendor \
    android.hardware.audio.effect@7.0.vendor \
    android.hardware.audio.effect@7.0-util.vendor \
    android.hardware.biometrics.fingerprint@2.1.vendor \
    android.hardware.bluetooth@1.0.vendor \
    android.hardware.bluetooth@1.1.vendor \
    android.hardware.bluetooth.audio@2.0.vendor \
    android.hardware.bluetooth.audio@2.1.vendor \
    android.hardware.boot@1.0.vendor \
    android.hardware.boot@1.1.vendor \
    android.hardware.boot@1.2.vendor \
    android.hardware.camera.common@1.0.vendor \
    android.hardware.camera.device@1.0.vendor \
    android.hardware.camera.device@3.2.vendor \
    android.hardware.camera.device@3.3.vendor \
    android.hardware.camera.device@3.4.vendor \
    android.hardware.camera.device@3.5.vendor \
    android.hardware.camera.device@3.6.vendor \
    android.hardware.camera.provider@2.4.vendor \
    android.hardware.camera.provider@2.5.vendor \
    android.hardware.camera.provider@2.6.vendor \
    android.hardware.cas@1.0.vendor \
    android.hardware.cas@1.1.vendor \
    android.hardware.cas@1.2.vendor \
    android.hardware.cas.native@1.0.vendor \
    android.hardware.drm@1.0.vendor \
    android.hardware.drm@1.1.vendor \
    android.hardware.drm@1.2.vendor \
    android.hardware.drm@1.3.vendor \
    android.hardware.drm@1.4.vendor \
    android.hardware.gatekeeper@1.0.vendor \
    android.hardware.gnss@1.0.vendor \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.0.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.gnss.measurement_corrections@1.0.vendor \
    android.hardware.gnss.measurement_corrections@1.1.vendor \
    android.hardware.gnss.visibility_control@1.0.vendor \
    android.hardware.gnss-V1-ndk.vendor \
    android.hardware.graphics.allocator@2.0.vendor \
    android.hardware.graphics.allocator@4.0.vendor \
    android.hardware.graphics.composer@2.1.vendor \
    android.hardware.graphics.composer@2.1-resources.vendor \
    android.hardware.graphics.composer@2.1-resources-v34.vendor \
    android.hardware.health@1.0.vendor \
    android.hardware.health@2.0.vendor \
    android.hardware.health@2.1.vendor \
    android.hardware.keymaster@3.0.vendor \
    android.hardware.keymaster@4.0.vendor \
    android.hardware.keymaster@4.1.vendor \
    android.hardware.light@2.0.vendor \
    android.hardware.light-V1-ndk \
    android.hardware.media.c2@1.0.vendor \
    android.hardware.media.c2@1.1.vendor \
    android.hardware.media.c2@1.2.vendor \
    android.hardware.media.omx@1.0.vendor \
    android.hardware.memtrack-V1-ndk \
    android.hardware.nfc@1.0.vendor \
    android.hardware.nfc@1.1.vendor \
    android.hardware.nfc@1.2.vendor \
    android.hardware.power@1.0.vendor \
    android.hardware.power@1.1.vendor \
    android.hardware.power@1.2.vendor \
    android.hardware.power-V2-ndk.vendor \
    android.hardware.radio@1.0.vendor \
    android.hardware.radio@1.1.vendor \
    android.hardware.radio@1.2.vendor \
    android.hardware.radio@1.3.vendor \
    android.hardware.radio@1.4.vendor \
    android.hardware.radio@1.5.vendor \
    android.hardware.radio@1.6.vendor \
    android.hardware.radio.config@1.0.vendor \
    android.hardware.radio.config@1.1.vendor \
    android.hardware.radio.config@1.2.vendor \
    android.hardware.radio.config@1.3.vendor \
    android.hardware.sensors@1.0.vendor \
    android.hardware.sensors@2.0.vendor \
    android.hardware.sensors@2.1.vendor \
    android.hardware.sensors@2.0-ScopedWakelock.vendor \
    android.hardware.soundtrigger@2.3.vendor \
    android.hardware.tetheroffload.config@1.0.vendor \
    android.hardware.tetheroffload.control@1.0.vendor \
    android.hardware.tetheroffload.control@1.1.vendor \
    android.hardware.thermal@1.0.vendor \
    android.hardware.thermal@2.0.vendor \
    android.hardware.usb@1.0.vendor \
    android.hardware.usb@1.1.vendor \
    android.hardware.usb@1.2.vendor \
    android.hardware.usb@1.3.vendor \
    android.hardware.usb.gadget@1.0.vendor \
    android.hardware.usb.gadget@1.1.vendor \
    android.hardware.vibrator-V2-ndk.vendor \
    android.hardware.wifi@1.0.vendor \
    android.hardware.wifi@1.1.vendor \
    android.hardware.wifi@1.2.vendor \
    android.hardware.wifi@1.3.vendor \
    android.hardware.wifi@1.4.vendor \
    android.hardware.wifi@1.5.vendor \
    android.hardware.wifi.hostapd@1.0.vendor \
    android.hardware.wifi.hostapd@1.1.vendor \
    android.hardware.wifi.hostapd@1.2.vendor \
    android.hardware.wifi.hostapd@1.3.vendor \
    android.hardware.wifi.supplicant@1.0.vendor \
    android.hardware.wifi.supplicant@1.1.vendor \
    android.hardware.wifi.supplicant@1.2.vendor \
    android.hardware.wifi.supplicant@1.3.vendor \
    android.hardware.wifi.supplicant@1.4.vendor \
    android.hidl.allocator@1.0.vendor \
    android.system.keystore2-V1-ndk.vendor \
    android.system.wifi.keystore@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.0.vendor \
    vendor.mediatek.hardware.mtkpower@1.1.vendor \
    vendor.mediatek.hardware.mtkpower@1.2.vendor \
    audioclient-types-aidl-cpp.vendor \
    framework-permission-aidl-cpp.vendor \
    shared-file-region-aidl-cpp.vendor \
    libalsautils.vendor \
    libaudiofoundation.vendor \
    libaudioclient_aidl_conversion.vendor \
    libavservices_minijail.vendor \
    libavservices_minijail_vendor \
    libchrome.vendor \
    libshmemcompat.vendor \
    libshmemutil.vendor \
    libcodec2_hidl@1.0.vendor \
    libcodec2_hidl@1.1.vendor \
    libcodec2_hidl@1.2.vendor \
    libcodec2_soft_common.vendor \
    libcodec2_hal_common.vendor \
    libdmabufheap.vendor \
    libeffects \
    libeffectproxy \
    libeffectsconfig.vendor \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libopus.vendor \
    libpcap.vendor \
    libssl.vendor \
    libstagefright_bufferpool@2.0.1.vendor \
    libsfplugin_ccodec_utils.vendor \
    libvorbisidec.vendor \
    libvpx.vendor \
    libz_stable.vendor

# RRO Overlays
PRODUCT_PACKAGES += \
    FrameworksResOverlayCaraka22 \
    WifiResOverlayCaraka22

# Walkie-Talkie (DMR Intercom) Module (from external/walkie)
PRODUCT_PACKAGES += \
    WalkieTalkie

# Rootdir, Fstab, Ueventd & Init files
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6765:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6765 \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6765:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.mt6765 \
    $(DEVICE_PATH)/prebuilts/mtk_plpath_utils:$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/mtk_plpath_utils \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6765:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6765 \
    $(DEVICE_PATH)/rootdir/etc/fstab.enableswap:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.enableswap \
    $(DEVICE_PATH)/rootdir/etc/ueventd.mt6765.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(DEVICE_PATH)/rootdir/etc/init.recovery.mt6765.rc:recovery/root/init.recovery.mt6765.rc \
    $(DEVICE_PATH)/rootdir/etc/init.ago.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.ago.rc \
    $(DEVICE_PATH)/rootdir/etc/init.cgroup.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.cgroup.rc \
    $(DEVICE_PATH)/rootdir/etc/init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.common.rc \
    $(DEVICE_PATH)/rootdir/etc/init.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.connectivity.rc \
    $(DEVICE_PATH)/rootdir/etc/init_connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init_connectivity.rc \
    $(DEVICE_PATH)/rootdir/etc/init.modem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.modem.rc \
    $(DEVICE_PATH)/rootdir/etc/init.mt6765.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6765.rc \
    $(DEVICE_PATH)/rootdir/etc/init.mt6765.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6765.usb.rc \
    $(DEVICE_PATH)/rootdir/etc/init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.project.rc \
    $(DEVICE_PATH)/rootdir/etc/init.sensor_1_0.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.sensor_1_0.rc \
    $(DEVICE_PATH)/rootdir/etc/init.stnfc.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.stnfc.rc \
    $(DEVICE_PATH)/rootdir/etc/init.tintele.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.tintele.rc \
    $(DEVICE_PATH)/rootdir/etc/multi_init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/multi_init.rc \
    $(DEVICE_PATH)/rootdir/etc/factory_init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.connectivity.common.rc \
    $(DEVICE_PATH)/rootdir/etc/factory_init.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.connectivity.rc \
    $(DEVICE_PATH)/rootdir/etc/factory_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.project.rc \
    $(DEVICE_PATH)/rootdir/etc/factory_init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/factory_init.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.connectivity.common.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.connectivity.common.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.connectivity.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.connectivity.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.modem.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.modem.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.project.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.rc \
    $(DEVICE_PATH)/rootdir/etc/meta_init.vendor.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/meta_init.vendor.rc

# Physical Hardware Key Layouts (Walkie-Talkie PTT, SOS, Channel, Keypad)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/usr/keylayout/mtk-kpd.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/mtk-kpd.kl \
    $(DEVICE_PATH)/rootdir/usr/keylayout/mtk-pmic-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/mtk-pmic-keys.kl \
    $(DEVICE_PATH)/rootdir/usr/keylayout/madev.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/madev.kl

# Inherit proprietary vendor
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)
$(call inherit-product, vendor/caraka/caraka22/caraka22-vendor.mk)
