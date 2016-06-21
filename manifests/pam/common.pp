# == Class: googleauthenticator::pam::common
#
# Common PAM requirements for googleauthenticator.
#
# It shouldn't be necessary to directly include this class.
#
define googleauthenticator::pam::common
  ( $servicename='ssh' ) {
  $package = $::operatingsystem ? {
    /Debian|Ubuntu/ => 'libpam-google-authenticator',
    /RedHat|CentOS/ => 'google-authenticator',
    default         => '',
  }

  package {'pam-google-authenticator':
    name => $package,
  }

  # Setup the three basic PAM modes
  googleauthenticator::pam::mode {
    'all-users': servicename => $servicename;

    'root-only':
      succeed_if  => 'uid > 0',
      servicename => $servicename;

    'systemwide-users':
      secret      => "/etc/google-authenticator/\${USER}/google_authenticator",
      servicename => $servicename;
  }
}
