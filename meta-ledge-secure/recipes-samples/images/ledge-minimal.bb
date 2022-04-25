SUMMARY = "Minimal image"

LICENSE = "MIT"

inherit core-image features_check extrausers

# REQUIRED_DISTRO_FEATURES = "pam systemd"

CORE_IMAGE_BASE_INSTALL += " \
    kernel-modules \
    kernel-devicetree \
    "

