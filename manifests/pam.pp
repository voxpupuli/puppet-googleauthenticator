define googleauthenticator::pam (
$mode='all-users',
$ensure='present'
) {
  
  case $::operatingsystem {
    /Debian|Ubuntu/ : {
        googleauthenticator::pam::debian {$name:
          ensure => $ensure,
          mode   => $mode,
        }
      }
    default         : { fail("not supported on ${::operatingsystem}") }
  }
}
