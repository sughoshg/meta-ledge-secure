DEPENDS:append = " e2fsprogs-native  efitools-native  coreutils-native "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://grub-initial.cfg \
            file://grub.cfg \
            file://0001-verifiers-Don-t-return-error-for-deferred-image.patch"

SRC_URI += "file://uefi-certificates/db.key"
SRC_URI += "file://uefi-certificates/db.crt"

GRUB_BUILDIN = "part_gpt fat ext2 configfile pgp gcry_sha512 gcry_rsa \
                password_pbkdf2 echo normal linux all_video \
                search search_fs_uuid reboot sleep"

do_mkimage() {
        cd ${B}

        grub-mkstandalone --disable-shim-lock \
            --format=arm64-efi \
            --locale-directory=/usr/share/locale/ \
            --directory=./grub-core/ \
            --modules="${GRUB_BUILDIN}" \
            --output=./${GRUB_IMAGE_PREFIX}${GRUB_IMAGE} \
            "boot/grub/grub.cfg=${WORKDIR}/grub-initial.cfg"

	${STAGING_BINDIR_NATIVE}/sbsign \
            --key ${WORKDIR}/uefi-certificates/db.key \
            --cert ${WORKDIR}/uefi-certificates/db.crt \
            ${GRUB_IMAGE_PREFIX}${GRUB_IMAGE} \
            --output ${GRUB_IMAGE_PREFIX}${GRUB_IMAGE}.signed
	cp ${GRUB_IMAGE_PREFIX}${GRUB_IMAGE}.signed ${GRUB_IMAGE_PREFIX}${GRUB_IMAGE}
}

do_install() {
        install -d ${D}${EFI_FILES_PATH}
        install -m 644 ${B}/${GRUB_IMAGE_PREFIX}${GRUB_IMAGE} ${D}${EFI_FILES_PATH}/${GRUB_IMAGE}
}

do_deploy() {
        install -m 644 ${B}/${GRUB_IMAGE_PREFIX}${GRUB_IMAGE} ${DEPLOYDIR}
}
