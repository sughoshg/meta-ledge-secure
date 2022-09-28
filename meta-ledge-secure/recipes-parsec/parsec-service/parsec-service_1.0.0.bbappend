FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

SRC_URI:append = " \
        file://config-fragment-optee.toml \
        file://config-fragment-tpm.toml \
	"

do_install:append() {
    if ${@bb.utils.contains('MACHINE_FEATURES', 'optee', 'true', '', d)}; then
        install -m 400 -o parsec -g parsec ${WORKDIR}/config-fragment-optee.toml ${D}${sysconfdir}/parsec
        if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
            sed -i 's|^Description=\(.*\)$|Description=\1\nRequires=tee-supplicant.service\nAfter=tee-supplicant.service|' ${D}${systemd_system_unitdir}/parsec.service
        fi

    fi
    if [ ${@bb.utils.contains('PACKAGECONFIG_CONFARGS', 'tpm-provider', 'true', '', d)} -a \
         ${@bb.utils.contains('DISTRO_FEATURES', 'tpm2', 'true', '', d)} ]; then
        install -m 400 -o parsec -g parsec ${WORKDIR}/config-fragment-tpm.toml ${D}${sysconfdir}/parsec
    fi
}
