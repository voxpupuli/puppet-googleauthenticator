/*

== Definition: googleauthenticator::pam::mode

Add a mode for googleauthenticator::pam.

This adds a file in /etc/pam.d/ which can then be used by googleauthenticator::pam resources.

Parameters:
- *ensure*: present/absent;
- *succeed_if*: optionally, add a condition where the module is ignored;
- *condition*: optionally, add a condition where the module is not ignored;
- *nullok*: make module optional (users without a ~/.google_authenticator file will still be able to log in);
- *secret*: optionally, specify the location of the secret file (you may use ${HOME}, ${USER} and ~);
- *noskewadj*: optionally, set the noskewadj option.

Example usage:

    googleauthenticator::pam::mode {'optional-users':
      # Users with a UID above 1000 don't need a token
      succeed_if => 'uid > 1000',
      # It's ok to not have a ~/.google_authenticator file
      nullok     => true,
    }

*/

define googleauthenticator::pam::mode (
$ensure='present',
$succeed_if=false,
$condition=false,
$nullok=false,
$secret=false,
$noskewadj=false
) {
  file {"/etc/pam.d/google-authenticator-${name}":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('googleauthenticator/pam-rule.erb'),
    notify  => Service['ssh'],
  }
}
