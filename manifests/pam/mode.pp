# @summary Add a mode for googleauthenticator::pam. This adds a file in /etc/pam.d/ which can then be used by googleauthenticator::pam resources.
#
# @param name The name of the PAM module
# @param ensure present/absent.
# @param succeed_if Optionally, add a condition where the module is ignored.
# @param condition Optionally, add a condition where the module is not ignored.
# @param nullok Make module optional (users without a ~/.google_authenticator file will still be able to log in.
# @param secret Optionally, specify the location of the secret file (you may use ${HOME}, ${USER} and ~)
# @param noskewadj Optionally, set the noskewadj option.
# @param service A service which should be notified.
#
# @example Enforce Google authenticator for all users with a UID > 1000
#  googleauthenticator::pam::mode {'optional-users':
#    # Users with a UID above 1000 don't need a token
#    succeed_if => 'uid > 1000',
#    # It's ok to not have a ~/.google_authenticator file
#    nullok     => true,
#  }
define googleauthenticator::pam::mode (
  $ensure='present',
  $succeed_if=false,
  $condition=false,
  $nullok=false,
  $secret=false,
  $noskewadj=false,
  $service='ssh',
) {
  file { "/etc/pam.d/google-authenticator-${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('googleauthenticator/pam-rule.erb'),
    notify  => Service[$service],
  }
}
