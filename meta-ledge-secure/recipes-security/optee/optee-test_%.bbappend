FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
# 3.16
SRC_URI = "git://github.com/OP-TEE/optee_test.git;protocol=https"

PV="3.16.0+git${SRCPV}"
SRCREV = "1cf0e6d2bdd1145370033d4e182634458528579d"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

DEPENDS:append = "python3-cryptography-native "

EXTRA_OEMAKE:append_armv7a = " COMPILE_NS_USER=32"
EXTRA_OEMAKE:append_armv7e = " COMPILE_NS_USER=32"

# for libgcc.a
EXTRA_OEMAKE:append = " LIBGCC_LOCATE_CFLAGS=--sysroot=${STAGING_DIR_HOST} \
                    CFG_PKCS11_TA=y \
                    "

SRC_URI:append_arm = " file://0001-Correct-support-of-32bits.patch "
SRC_URI:append = " file://0001-regression_6000.c-detect-available-storage-IDs-at-ru.patch "
