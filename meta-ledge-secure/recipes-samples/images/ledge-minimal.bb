SUMMARY = "Minimal image"

LICENSE = "MIT"

inherit core-image extrausers

IMAGE_FEATURES += "package-management ssh-server-openssh allow-empty-password"
# REQUIRED_DISTRO_FEATURES = "pam systemd"

CORE_IMAGE_BASE_INSTALL += " \
    kernel-modules \
    kernel-devicetree \
    "

CORE_IMAGE_BASE_INSTALL += "\
    ${@bb.utils.contains("MACHINE_FEATURES", "optee", "packagegroup-ledge-optee", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "optee", "packagegroup-ledge-optee-test", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tsn", "packagegroup-ledge-tsn", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tpm2", "packagegroup-security-tpm2", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tpm2", "packagegroup-ledge-tpm-lava", "", d)} \
    efivar \
    fwts \
    "
