# == Definition: googleauthenticator::pam
#
# Setup a PAM module to use Google-authenticator.
#
# Parameters:
# - *ensure*: present/absent;
# - *mode*: optionally, set the mode to use
#     ('root-only' or 'all-users' are supported right now).
#
# Example usage:
#
#     googleauthenticator::pam {'su':
#       mode => 'root-only',
#     }
#
define googleauthenticator::pam (
  $mode='all-users',
  $ensure='present',
) {
  include googleauthenticator::pam::common

  if ($name == 'sshd') {
    include googleauthenticator::sshd
  }

  case $facts['os']['name'] {
    /Debian|Ubuntu/ : {
      googleauthenticator::pam::debian { $name:
        ensure => $ensure,
        mode   => $mode,
      }
    }
    /RedHat|CentOS/ : {
      googleauthenticator::pam::redhat { $name:
        ensure => $ensure,
        mode   => $mode,
      }
    }
    default         : { fail("not supported on ${facts['os']['name']}") }
  }
}
