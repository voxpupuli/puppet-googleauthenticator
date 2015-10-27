# == Class: googleauthenticator::pam::common
#
# Common PAM requirements for googleauthenticator.
#
# It shouldn't be necessary to directly include this class.
#
class googleauthenticator::pam::common {
  $package = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'libpam-google-authenticator',
    /RedHat|CentOS/ => 'google-authenticator',
    default         => '',
  }
  $service = $::operatingsystem ? {
    /RedHat|CentOS/ => 'sshd',
    default         => 'ssh',
  }

  package {'pam-google-authenticator':
    name => $package,
  }

  # Setup the three basic PAM modes
  googleauthenticator::pam::mode {
    'all-users':;

    'root-only':
      succeed_if => 'uid > 0';

    'systemwide-users':
      secret => "/etc/google-authenticator/\${USER}/google_authenticator";
  }
}
