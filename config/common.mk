# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.setupwizard.rotation_locked=true


# RecueParty? No thanks.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.enable_rescue=false

# Show SELinux status on About Settings
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1

# Mark as eligible for Google Assistant
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.opa.eligible_device=true

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.dun.override=0
endif

# enable ADB authentication if not on eng build
ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Tethering - allow without requiring a provisioning app
# (for devices that check this)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    net.tethering.noprovisioning=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

ifeq ($(BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE),)
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/data/cache
else
  PRODUCT_DEFAULT_PROPERTY_OVERRIDES  += \
    ro.device.cache_dir=/cache
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/citrus/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/citrus/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/citrus/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/citrus/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/citrus/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Include low res bootanimation if display is less then 720p
TARGET_BOOTANIMATION_480 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -lt 720 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Include high res bootanimation if display is greater then 1080p
TARGET_BOOTANIMATION_1440 := $(shell \
  if [ $(TARGET_SCREEN_WIDTH) -gt 1080 ]; then \
    echo 'true'; \
  else \
    echo ''; \
  fi )

# Bootanimation
#qHD
ifeq ($(TARGET_BOOTANIMATION_480), true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/480.zip:system/media/bootanimation.zip
else
#HD
ifeq ($(TARGET_SCREEN_WIDTH), 720)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/720.zip:system/media/bootanimation.zip
else
#QHD
ifeq ($(TARGET_BOOTANIMATION_1440), true)
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/1440.zip:system/media/bootanimation.zip
else
#FHD
PRODUCT_COPY_FILES += \
    vendor/citrus/prebuilt/common/bootanimation/1080.zip:system/media/bootanimation.zip
endif
endif
endif

# Changelog
ifeq ($(CITRUS_RELEASE),true)
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/etc/Changelog.txt:system/etc/Changelog.txt
else
GENERATE_CHANGELOG := true
endif

# Dialer fix
PRODUCT_COPY_FILES +=  \
    vendor/citrus/prebuilt/common/etc/sysconfig/dialer_experience.xml:system/etc/sysconfig/dialer_experience.xml

# init.d support
PRODUCT_COPY_FILES += \
    v
