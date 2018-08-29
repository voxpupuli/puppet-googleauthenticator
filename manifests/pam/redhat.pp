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
#     ('root-only', 'all-users' and 'systemwide-users' are supported right now).
#
define googleauthenticator::pam::redhat(
  $mode,
  $ensure='present',
) {
  $rule = "google-authenticator-${mode}"

  $lastauth = '*[type = "auth" or label() = "include" and . = "common-auth"][last()]'

  case $ensure {
    'present': {
      if ($::facts['os']['release']['major'] >= 7) {
        augeas {"Add google-authenticator to sshd":
          context => '/files/etc/pam.d/sshd',
          changes => [
            # Purge existing entries
            'rm   *[module =~ regexp("google-authenticator.*")]',
            'ins 01 after *[type = "auth" or label() = "include" and . = "common-auth"][last()]',
            'set 01/type auth',
            'set 01/control include',
            "set 01/module $rule",
            ],
          onlyif => "match *[type = 'auth'][control = 'include'][module = \"$rule\"] size == 0",
          require => File["/etc/pam.d/${rule}"],
          notify  => Service['sshd'],
        }
      } else {
        augeas {"Add google-authenticator to ${name}":
          context => "/files/etc/pam.d/${name}",
          changes => [
            # Purge existing entries
            'rm include[. =~ regexp("google-authenticator.*")]',
            "ins include after ${lastauth}",
            "set include[. = ''] '${rule}'",
            ],
          require => File["/etc/pam.d/${rule}"],
          notify  => Service['sshd'],
        }
      }
    }
    'absent': {
      augeas {"Purge existing google-authenticator from ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => 'rm include[. =~ regexp("google-authenticator.*")]',
        notify  => Service['sshd'],
      }
    }
    default: { fail("Wrong ensure value ${ensure}") }
  }
}
