# @summary Setup a PAM module for Google-authenticator on Debian/Ubuntu.
#
# @param name The name of the PAM module
# @param mode Set the mode to use. 'root-only' or 'all-users' are supported right now.
# @param ensure present/absent
define googleauthenticator::pam::debian (
  $mode,
  $ensure='present',
) {
  $rule = "google-authenticator-${mode}"

  $lastauth = '*[type = "auth" or label() = "include" and . = "common-auth"][last()]'

  case $ensure {
    'present': {
      augeas { "Add google-authenticator to ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => [
          # Purge existing entries
          'rm include[. =~ regexp("google-authenticator.*")]',
          "ins include after ${lastauth}",
          "set include[. = ''] '${rule}'",
        ],
        require => File["/etc/pam.d/${rule}"],
        notify  => Service['ssh'],
      }
    }
    'absent': {
      augeas { "Purge existing google-authenticator from ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => 'rm include[. =~ regexp("google-authenticator.*")]',
        notify  => Service['ssh'],
      }
    }
    default: { fail("Wrong ensure value ${ensure}") }
  }
}
