FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://grub.cfg"

do_configure() {
}

do_install() {
        install -d ${D}${EFI_FILES_PATH}
        install grub.cfg ${D}${EFI_FILES_PATH}/grub.cfg
}

inherit deploy

do_deploy() {
        install -m 644 ${D}${EFI_FILES_PATH}/grub.cfg ${DEPLOYDIR}
}

addtask deploy before do_package after do_install
