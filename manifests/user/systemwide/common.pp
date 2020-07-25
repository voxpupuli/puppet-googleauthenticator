# == Class: googleauthenticator::user::systemwide::common
#
# Common class for googleauthenticator::user::systemwide
#
class googleauthenticator::user::systemwide::common {
  file { '/etc/google-authenticator':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
