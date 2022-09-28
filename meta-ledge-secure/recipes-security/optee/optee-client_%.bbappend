FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE = "(ledge-secure-qemuarm64|ledge-qemuarm64|ledge-qemuarm)"

PV="3.18.0+git${SRCPV}"
SRCREV = "e7cba71cc6e2ecd02f412c7e9ee104f0a5dffc6f"

SRC_URI:append = " \
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
