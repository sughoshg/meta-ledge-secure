# Linaro Edge Secure meta layer
 
meta-ledge-secure is the layer that implements additional security level for
Open Embedded based builds.

List of integrated security features:
 * UEFI secure boot
 * Measured boot
 * LUKS with passphrase sealed to TPM PCRs
 * fTPM support
 * Parsec TPM integration
 * SELinux support

meta-ledge-secure is commonly used in conjunction with the Trusted Substrate project to build
secure OS. More information can be found
<http://trustedsubstrate.org/> and <https://gitlab.com/Linaro/trustedsubstrate/meta-ts.git>

## Dependency

  meta-arm:
    url: git://git.yoctoproject.org/meta-arm
  meta-secure-core:
    url: https://github.com/jiazhang0/meta-secure-core
  meta-security:
    url: http://git.yoctoproject.org/git/meta-security
  meta-selinux:
    url: http://git.yoctoproject.org/git/meta-selinux
  meta-openembedded:
    url: https://git.openembedded.org/meta-openembedded

## Git URL

  https://gitlab.com/Linaro/trustedsubstrate/meta-ledge-secure.git

## Mailing list

  team-ledge@linaro.org

