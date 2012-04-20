/*

== Class: googleauthenticator::pam::common

Common PAM requirements for googleauthenticator.

It shouldn't be necessary to directly include this class.

*/

class googleauthenticator::pam::common {
  package {'pam-google-authenticator':
    name   => $::operatingsystem ? {
     /Debian|Ubuntu/ => 'libpam-google-authenticator',
     default         => '',
    },
    ensure => $ensure,
  }

  file {'/etc/pam.d/google-authenticator-root-only':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/googleauthenticator/pam.d/google-authenticator-root-only',
    require => Package['pam-google-authenticator'],
    notify  => Service['ssh'],
  }

  file {'/etc/pam.d/google-authenticator':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/googleauthenticator/pam.d/google-authenticator',
    require => Package['pam-google-authenticator'],
    notify  => Service['ssh'],
  }
}
