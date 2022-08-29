FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

SRC_URI:append = " \
        file://config-fragment-optee.toml \
        file://config-fragment-tpm.toml \
	"

do_install:append() {
    if ${@bb.utils.contains('MACHINE_FEATURES', 'optee', 'true', '', d)}; then
        install -m 400 -o parsec -g parsec ${WORKDIR}/config-fragment-optee.toml ${D}${sysconfdir}/parsec
    fi
    if [ ${@bb.utils.contains('PACKAGECONFIG_CONFARGS', 'tpm-provider', 'true', '', d)} -a \
         ${@bb.utils.contains('DISTRO_FEATURES', 'tpm2', 'true', '', d)} ]; then
        install -m 400 -o parsec -g parsec ${WORKDIR}/config-fragment-tpm.toml ${D}${sysconfdir}/parsec
    fi
}
