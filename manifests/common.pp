class googleauthenticator::common {
  file {'/etc/pam.d/google-authenticator-root-only':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/google-authenticator/pam.d/google-authenticator-root-only',
    notify => Service['ssh'],
  }

  file {'/etc/pam.d/google-authenticator':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/google-authenticator/pam.d/google-authenticator',
    notify => Service['ssh'],
  }

  case $::operatingsystem {
    /Debian|Ubuntu/ : { include googleauthenticator::debian }
    default         : { fail("not supported on ${::operatingsystem}") }
  }
}
