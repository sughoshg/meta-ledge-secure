DEPENDS = "${@bb.utils.contains('ARCH', 'x86', 'elfutils-native', '', d)}"
DEPENDS += "openssl-native util-linux-native"
DEPENDS += "gmp-native"

include linux-ledge-common.inc
include linux-ledge-sign.inc

# rename DTB
# DTB_RENAMING = "xyz.dtb:zyx.dtb "
