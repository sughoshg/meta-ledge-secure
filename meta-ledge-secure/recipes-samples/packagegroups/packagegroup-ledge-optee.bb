SUMMARY = "OP-TEE related packages"

inherit packagegroup

RDEPENDS:packagegroup-ledge-optee = "\
    optee-client\
    ${@bb.utils.contains("MACHINE_FEATURES", "ftpm", "optee-ftpm", "", d)} \
    "
