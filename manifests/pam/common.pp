/*

== Class: googleauthenticator::pam::common

Common PAM requirements for googleauthenticator.

It shouldn't be necessary to directly include this class.

*/

class googleauthenticator::pam::common {
  $package = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'libpam-google-authenticator',
    /RedHat|CentOS/ => 'google-authenticator',
    default         => '',
  }

  package {'pam-google-authenticator':
    name => $package,
  }

  # Setup the two basic PAM rules
  googleauthenticator::pam::rule {'root-only':
    succeed_if => 'uid > 0',
  }

  googleauthenticator::pam::rule {'all-users': }
}
