SUMMARY = "TPM related packages for testing on Lava"

inherit packagegroup

RDEPENDS:packagegroup-ledge-tpm-lava = "\
    git \
    python3-pyyaml \
    vim \
    perl \
    openssl-bin \
    "
