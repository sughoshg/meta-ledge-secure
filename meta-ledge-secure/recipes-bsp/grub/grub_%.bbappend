# Overwrite poky side SRC_URI to remove all security etc patches
# since we update to a newer version anyway and the patches don't apply
SRC_URI = "git://git.savannah.gnu.org/git/grub.git;protocol=https;branch=master"

SRCREV = "7259d55ffcf124e32eafb61aa381f9856e98a708"
PV = "2.06+git${SRCPV}"
S = "${WORKDIR}/git"

SRC_URI[sha256sum] = "a52e73e42dabbda0f9032ef30a5afae00e80abb745cc5c356e3b56fda0048e1d"

do_configure[depends] += "gnulib-native:do_populate_sysroot \
                          ${MLPREFIX}gnulib:do_populate_sysroot"

do_configure:prepend() {
        cd ${S}

        rm -rf ${S}/gnulib
        cp -rf ${STAGING_DATADIR}/gnulib ${S}/gnulib

        ./bootstrap --gnulib-srcdir=./gnulib
        cd -
}
