# == Definition: googleauthenticator::pam::redhat
#
# Setup a PAM module for Google-authenticator on RedHat/CentOS.
#
# This module is meant to be called from the googleauthenticator::pam
# wrapper module.
#
# Parameters:
# - *ensure*: present/absent;
# - *mode*: Set the mode to use
#     ('root-only' or 'all-users' are supported right now).
#
define googleauthenticator::pam::redhat(
  $mode,
  $ensure='present',
  $servicename,
) {
  $rule = "google-authenticator-${mode}"

  $lastauth = '*[type = "auth" or label() = "include" and . = "common-auth"][last()]'

  case $ensure {
    'present': {
      augeas {"Add google-authenticator to ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => [
          # Purge existing entries
          'rm include[. =~ regexp("google-authenticator.*")]',
          "ins include after ${lastauth}",
          "set include[. = ''] '${rule}'",
          ],
        require => File["/etc/pam.d/${rule}"],
        notify  => Service[$servicename],
      }
    }
    'absent': {
      augeas {"Purge existing google-authenticator from ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => 'rm include[. =~ regexp("google-authenticator.*")]',
        notify  => Service[$servicename],
      }
    }
    default: { fail("Wrong ensure value ${ensure}") }
  }
}
