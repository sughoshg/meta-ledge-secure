# cryptsetup in zeus branch has higher version then
# cryptsetup-tpm-incubator that leads to not replacement
# of package. Remove it from build for now.
#
RDEPENDS:packagegroup-security-tpm2:remove = " \
    cryptsetup-tpm-incubator \
    "

RDEPENDS:packagegroup-security-tpm2:append = " \
    parsec-service \
    parsec-tool \
    "
