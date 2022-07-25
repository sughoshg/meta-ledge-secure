SUMMARY = "OP-TEE related packages"

inherit packagegroup

RDEPENDS:packagegroup-ledge-optee = "\
    optee-client\
    optee-test \
    ${@bb.utils.contains("MACHINE_FEATURES", "ftpm", "optee-ftpm", "", d)} \
    "
