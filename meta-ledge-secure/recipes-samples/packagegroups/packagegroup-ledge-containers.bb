SUMMARY = "Containers related packages"

inherit packagegroup

PREFERRED_PROVIDER_virtual/runc = "runc-docker"

# contains basic dependencies for network tools
RDEPENDS:packagegroup-ledge-containers = " \
    docker \
    virtual/runc \
    "
