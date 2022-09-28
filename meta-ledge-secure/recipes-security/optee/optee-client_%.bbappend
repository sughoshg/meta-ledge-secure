FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

# 3.16
PV="3.16.0+git${SRCPV}"
SRCREV = "06db73b3f3fdb8d23eceaedbc46c49c0b45fd1e2"

SRC_URI:append = " \
file://0001-libckteec-add-support-for-ECDH-derive.patch \
	file://0002-tee-supplicant-introduce-struct-tee_supplicant_param.patch \
	file://0003-tee-supplicant-refactor-argument-parsing-in-main.patch \
	file://0004-tee-supplicant-rpmb-introduce-readn-wrapper-to-the-r.patch \
	file://0005-tee-supplicant-rpmb-read-CID-in-one-go.patch \
	file://0006-tee-supplicant-add-rpmb-cid-command-line-option.patch \
	file://create-tee-supplicant-env \
        file://optee-udev.rules \
	"

EXTRA_OECMAKE:append = " \
    -DRPMB_EMU=0 \
"

do_install:append() {
	install -D -p -m0755 ${WORKDIR}/create-tee-supplicant-env ${D}${sbindir}/create-tee-supplicant-env
        sed -i 's|^ExecStart=.*$|EnvironmentFile=-@localstatedir@/run/tee-supplicant.env\nExecStartPre=-/sbin/modprobe -r tpm_ftpm_tee\nExecStartPre=@sbindir@/create-tee-supplicant-env @localstatedir@/run/tee-supplicant.env\nExecStart=@sbindir@/tee-supplicant $RPMB_CID $OPTARGS\nExecStartPost=-/sbin/modprobe tpm_ftpm_tee\nExecStop=-/sbin/modprobe -r tpm_ftpm_tee|' ${D}${systemd_system_unitdir}/tee-supplicant.service
	sed -i -e s:@sbindir@:${sbindir}:g \
	       -e s:@localstatedir@:${localstatedir}:g ${D}${systemd_system_unitdir}/tee-supplicant.service
	install -d ${D}${sysconfdir}/udev/rules.d
	install -m 0644 ${WORKDIR}/optee-udev.rules ${D}${sysconfdir}/udev/rules.d/optee.rules
}

inherit useradd
USERADD_PACKAGES = "${PN}"
GROUPADD_PARAM:${PN} = "--system teeclnt"
