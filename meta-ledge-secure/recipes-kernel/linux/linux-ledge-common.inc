inherit kernel siteinfo

DEPENDS += "coreutils-native"

# strip kernel modules before signing to reduce module size
EXTRA_OEMAKE += "INSTALL_MOD_STRIP=1"

FILESEXTRAPATHS:prepend:ewaol := "${THISDIR}:${THISDIR}/linux-yocto:"

SRC_URI:append = " file://ledge-kmeta;type=kmeta;name=ledge-kmeta;destsuffix=ledge-kmeta"

# linux-yocto way of enabling module signing
KERNEL_FEATURES:append = " features/module-signing/force-signing.scc "

KERNEL_FEATURES:append = " fragment-1-selinux.cfg "
KERNEL_FEATURES:append = " fragment-3-secure.cfg "
KERNEL_FEATURES:append = " fragment-rockchip-media.cfg"
KERNEL_FEATURES:append = " fragment-ava.cfg"
KERNEL_FEATURES:append = " defconfig "

SRC_URI += " \
    file://0003-rk3399-rock-pi-4.dtsi-enable-imx219-isp.patch \
"

do_compile:append:aarch64() {
    oe_runmake -C ${B} dtbs
}

do_install:append:aarch64() {
    oe_runmake -C ${B} DEPMOD=echo INSTALL_DTBS_PATH=${D}/boot/dtb dtbs_install
}

do_install:append() {
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

do_deploy:append() {
	mkdir -p ${DEPLOYDIR}/dtb
    if [ -d ${WORKDIR}/package/boot/dtb ];then
        cp -rf ${WORKDIR}/package/boot/dtb ${DEPLOYDIR}/
    fi
}

FILES:${KERNEL_PACKAGE_NAME}-base += "/${KERNEL_IMAGEDEST}/dtb"
FILES:${KERNEL_PACKAGE_NAME}-base += "${nonarch_base_libdir}/modules/${KERNEL_VERSION}/modules.builtin.modinfo "
FILES:${KERNEL_PACKAGE_NAME}-base += "${base_libdir}/modprobe.d"
