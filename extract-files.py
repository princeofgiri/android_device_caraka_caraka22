#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import os
import sys

extract_utils_path = os.environ.get('EXTRACT_UTILS_PATH')
if not extract_utils_path:
    for cand in (
        '/home/haris/android-source/SymbiotOS/tools/extract-utils',
        os.path.realpath(os.path.join(os.getcwd(), '..', '..', '..', 'tools', 'extract-utils')),
    ):
        cand = os.path.realpath(cand)
        if os.path.isdir(cand):
            extract_utils_path = cand
            break
if extract_utils_path and extract_utils_path not in sys.path:
    sys.path.insert(0, extract_utils_path)

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/caraka/caraka22',
    'hardware/mediatek',
    'hardware/mediatek/libmtkperf_client',
]


def lib_fixup_libvibrator(lib: str, partition: str, *args, **kwargs):
    return 'libvibrator_v31' if partition == 'vendor' else lib


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libvibrator': lib_fixup_libvibrator,
}

blob_fixups: blob_fixups_user_type = {
    # GNSS AIDL: ndk_platform -> ndk
    (
        'vendor/bin/hw/android.hardware.gnss-service.mediatek',
        'vendor/lib64/hw/android.hardware.gnss-impl-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.hardware.gnss-V1-ndk_platform.so', 'android.hardware.gnss-V1-ndk.so'),
    # Lights AIDL
    (
        'vendor/bin/factory',
        'vendor/bin/hw/android.hardware.lights-service.mediatek',
    ): blob_fixup()
        .replace_needed('android.hardware.light-V1-ndk_platform.so', 'android.hardware.light-V1-ndk.so'),
    # Memtrack AIDL
    'vendor/bin/hw/android.hardware.memtrack-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.memtrack-V1-ndk_platform.so', 'android.hardware.memtrack-V1-ndk.so'),
    # Power AIDL
    (
        'vendor/bin/hw/vendor.mediatek.hardware.mtkpower@1.0-service',
        'vendor/lib64/android.hardware.power-service-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.hardware.power-V2-ndk_platform.so', 'android.hardware.power-V2-ndk.so'),
    # Vibrator AIDL
    'vendor/bin/hw/android.hardware.vibrator-service.mediatek': blob_fixup()
        .replace_needed('android.hardware.vibrator-V2-ndk_platform.so', 'android.hardware.vibrator-V2-ndk.so'),
    # Keystore2 (wifi keystore HIDL bridge)
    (
        'vendor/lib64/libkeystore-engine-wifi-hidl.so',
        'vendor/lib/libkeystore-engine-wifi-hidl.so',
    ): blob_fixup()
        .replace_needed('android.system.keystore2-V1-ndk_platform.so', 'android.system.keystore2-V1-ndk.so'),
    # HWComposer service: use composer@2.1-resources-v34
    'vendor/bin/hw/android.hardware.graphics.composer@2.1-service': blob_fixup()
        .replace_needed('android.hardware.graphics.composer@2.1-resources.so', 'android.hardware.graphics.composer@2.1-resources-v34.so'),
    # HWComposer MT6765: SetTaskProfiles shim
    'vendor/lib64/hw/hwcomposer.mt6765.so': blob_fixup()
        .add_needed('libprocessgroup_shim.so'),
    # Libbase WriteStringToFd / Basename / Trim symbol drift
    (
        'vendor/bin/hw/android.hardware.sensors@2.0-service.multihal-mediatek',
        'vendor/bin/hw/android.hardware.usb@1.2-service-mediatekv2',
        'vendor/bin/STFlashTool',
        'vendor/bin/dmabuf_dump',
        'vendor/bin/nfcstackp-vendor',
        'vendor/lib64/hw/android.hardware.boot@1.0-impl-1.2-mtkimpl.so',
        'vendor/lib/hw/android.hardware.boot@1.0-impl-1.2-mtkimpl.so',
        'vendor/lib64/hw/android.hardware.health@2.0-impl-2.1.so',
        'vendor/lib/hw/android.hardware.health@2.0-impl-2.1.so',
        'vendor/lib64/libavservices_minijail_vendor.so',
        'vendor/lib/libavservices_minijail_vendor.so',
        'vendor/lib64/libnvram.so',
        'vendor/lib/libnvram.so',
        'vendor/lib64/libsysenv.so',
        'vendor/lib/libsysenv.so',
    ): blob_fixup()
        .add_needed('libbase_shim.so'),
    # WPA supplicant & hostapd: OpenSSL/BoringSSL sk_dup shim
    (
        'vendor/bin/hw/wpa_supplicant',
        'vendor/bin/hw/hostapd',
    ): blob_fixup()
        .add_needed('libcrypto_shim.so'),
    # Audio HAL & USB Audio: compat stagefright, alsautils-v31, tinyxml2-v34
    (
        'vendor/lib64/hw/audio.primary.mt6765.so',
        'vendor/lib/hw/audio.primary.mt6765.so',
        'vendor/lib64/hw/audio.usb.default.so',
        'vendor/lib/hw/audio.usb.default.so',
    ): blob_fixup()
        .add_needed('libstagefright_foundation-v33.so')
        .replace_needed('libalsautils.so', 'libalsautils-v31.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # PowerHAL & ExtAmp: tinyxml2-v34
    (
        'vendor/lib64/libpowerhal.so',
        'vendor/lib/libpowerhal.so',
        'vendor/lib64/librt_extamp_intf.so',
        'vendor/lib/librt_extamp_intf.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # PQ impl: libutils + libtinyxml2 ABI drift
    (
        'vendor/lib64/hw/vendor.mediatek.hardware.pq@2.15-impl.so',
        'vendor/lib/hw/vendor.mediatek.hardware.pq@2.15-impl.so',
    ): blob_fixup()
        .replace_needed('libutils.so', 'libutils-v32.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    # Camera provider & MTK camera app: libcamera_metadata_shim & Thread::run shim
    'vendor/lib64/hw/android.hardware.camera.provider@2.6-impl-mediatek.so': blob_fixup()
        .add_needed('libcamera_metadata_shim.so'),
    'vendor/bin/hw/camerahalserver': blob_fixup()
        .add_needed('libcam_utils_shim.so'),
    'vendor/lib64/libmtkcam_device3_app.so': blob_fixup()
        .replace_needed('libutils.so', 'libcam_utils_shim.so'),
    # RIL: libutils-v32
    'vendor/bin/hw/mtkfusionrild': blob_fixup()
        .add_needed('libutils-v32.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'caraka22',
    'caraka',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
