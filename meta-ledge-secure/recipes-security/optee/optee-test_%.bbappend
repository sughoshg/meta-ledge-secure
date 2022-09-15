FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "git://github.com/OP-TEE/optee_test.git;protocol=https"

PV="3.18.0+git${SRCPV}"
SRCREV = "da5282a011b40621a2cf7a296c11a35c833ed91b"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

DEPENDS:append = "python3-cryptography-native "

EXTRA_OEMAKE:append_armv7a = " COMPILE_NS_USER=32"
EXTRA_OEMAKE:append_armv7e = " COMPILE_NS_USER=32"

# for libgcc.a
EXTRA_OEMAKE:append = " LIBGCC_LOCATE_CFLAGS=--sysroot=${STAGING_DIR_HOST} \
                    CFG_PKCS11_TA=y \
                    "

SRC_URI:append_arm = " file://0001-Correct-support-of-32bits.patch "
