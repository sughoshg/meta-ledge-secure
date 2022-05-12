inherit kernel siteinfo

DEPENDS += "coreutils-native"

EXTRA_OEMAKE += "${@oe.utils.ifelse(d.getVar('KERNEL_SIGN_ENABLE') == '1', 'INSTALL_MOD_STRIP=1','')}"

SRC_URI:append = " file://fragment-1-selinux.config "
SRC_URI:append = " file://fragment-2-module-signature.config "

KERNEL_CONFIG_FRAGMENTS:append = " ${WORKDIR}/fragment-1-selinux.config "
KERNEL_CONFIG_FRAGMENTS:append = " ${@oe.utils.ifelse(d.getVar('KERNEL_SIGN_ENABLE') == '1', '${WORKDIR}/fragment-2-module-signature.config','')} "

do_configure_append() {
    if [ ! -z "${KERNEL_CONFIG_FRAGMENTS}" ]; then
        for f in ${KERNEL_CONFIG_FRAGMENTS}
        do
            # Check if the config fragment was copied into the WORKDIR from
            # the OE meta data
            if [ ! -e "$f" ]; then
                echo "Could not find kernel config fragment $f"
                exit 1
            fi
        done

        bbnote "${S}/scripts/kconfig/merge_config.sh -m -r -O ${B} ${B}/.config ${KERNEL_CONFIG_FRAGMENTS} 1>&2"
        # Now that all the fragments are located merge them.
        (${S}/scripts/kconfig/merge_config.sh -m -r -O ${B} ${B}/.config ${KERNEL_CONFIG_FRAGMENTS} 1>&2 )
    fi

    yes '' | oe_runmake -C ${S} O=${B} CC="${KERNEL_CC}" LD="${KERNEL_LD}" oldconfig
    #oe_runmake -C ${S} O=${B} savedefconfig && cp ${B}/defconfig ${WORKDIR}/defconfig.saved

    bbplain "Saving defconfig to:\n${B}/defconfig"
    oe_runmake -C ${B} savedefconfig
    cp -a ${B}/defconfig ${DEPLOYDIR}
}


do_install_append() {
    if [ ! -d ${D}/boot/dtb ]; then
        # force the creation of dtb directory on boot to have
        install -d ${D}/boot/dtb
        echo "Empty content on case there is no devicetree" > ${D}/boot/dtb/.emtpy
    fi

    #rename device tree
    for dtb in ${DTB_RENAMING}
    do
        dtb_orignal=$(echo $dtb | cut -d':' -f 1 )
        dtb_renamed=$(echo $dtb | cut -d':' -f 2 )

        if [ -f ${D}/boot/$dtb_orignal ]; then
            cd ${D}/boot/
            ln -s $dtb_orignal $dtb_renamed
           cd -
        fi
        if [ -f ${D}/boot/dtb/$dtb_orignal ]; then
            cd ${D}/boot/dtb/
            ln -s $dtb_orignal $dtb_renamed
            cd -
        fi
    done
}

do_deploy_append() {
	mkdir -p ${DEPLOYDIR}/dtb
    if [ -d ${WORKDIR}/package/boot/dtb ];then
        cp -rf ${WORKDIR}/package/boot/dtb ${DEPLOYDIR}/
    fi
}

# FILES_${KERNEL_PACKAGE_NAME}-devicetree += "/${KERNEL_IMAGEDEST}/dtb"
FILES_${KERNEL_PACKAGE_NAME}-base += "/${KERNEL_IMAGEDEST}/dtb"
FILES_${KERNEL_PACKAGE_NAME}-base += "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo "
FILES_${KERNEL_PACKAGE_NAME}-base += "${base_libdir}/modprobe.d"
