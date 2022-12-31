SUMMARY = "GRUB related packages"

inherit packagegroup

RDEPENDS:packagegroup-ledge-grub = "\
    ${@bb.utils.contains("MACHINE_FEATURES", "grub", "grub", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "grub", "grub-efi", "", d)} \
    ${@bb.utils.contains("MACHINE_FEATURES", "grub", "grub-bootconf", "", d)} \
    "
