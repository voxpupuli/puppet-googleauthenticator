/*

== Class: googleauthenticator::pam::common

Common PAM requirements for googleauthenticator.

It shouldn't be necessary to directly include this class.

*/

class googleauthenticator::pam::common {
  file {'/etc/pam.d/google-authenticator-root-only':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/googleauthenticator/pam.d/google-authenticator-root-only',
    notify => Service['ssh'],
  }

  file {'/etc/pam.d/google-authenticator':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/googleauthenticator/pam.d/google-authenticator',
    notify => Service['ssh'],
  }
}
