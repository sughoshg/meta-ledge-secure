DEPENDS = "${@bb.utils.contains('ARCH', 'x86', 'elfutils-native', '', d)}"
DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native"

include linux-ledge-common.inc
include linux-ledge-sign.inc

# enable module signing
# The signing configuration are located on fragment-14-module-signature
# to veirfy if a module are signed:
# tail -c 28 <kernel_module.ko>
KERNEL_SIGN_ENABLE = "1"

# rename DTB
# DTB_RENAMING = "xyz.dtb:zyx.dtb "
