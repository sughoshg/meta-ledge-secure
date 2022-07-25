
DEPENDS:append = " e2fsprogs-native"

IMAGE_INSTALL:append = "\
    kernel-modules \
    ${@bb.utils.contains("MACHINE_FEATURES", "optee", "packagegroup-ledge-optee", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tsn", "packagegroup-ledge-tsn", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tpm2", "packagegroup-security-tpm2", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "tpm2", "packagegroup-ledge-tpm-lava", "", d)} \
    efivar \
    fwts \
    "
