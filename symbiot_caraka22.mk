#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

TARGET_REQUIRES_HIDL_CAS_HAL := false

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from caraka22 device
$(call inherit-product, device/caraka/caraka22/device.mk)

# Force insecure ADB for recovery debugging
WITH_ADB_INSECURE := true

# Inherit common SymbiotOS definitions
$(call inherit-product, vendor/symbiot/config/common_full_phone.mk)

PRODUCT_NAME := symbiot_caraka22
PRODUCT_DEVICE := caraka22
PRODUCT_BRAND := CARAKA-22
PRODUCT_MODEL := CARAKA-22
PRODUCT_MANUFACTURER := CARAKA-22

PRODUCT_GMS_CLIENTID_BASE := android-caraka

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="vnd_k65v1_64_bsp-user 12 SP1A.210812.016 mp1V15401 release-keys" \
    BuildFingerprint=alps/vnd_k65v1_64_bsp/k65v1_64_bsp:12/SP1A.210812.016/mp1V15401:user/test-keys \
    DeviceProduct=CARAKA-22 \
    SystemDevice=CARAKA-22 \
    SystemName=CARAKA-22

PRODUCT_LOCALES := en_US in_ID
