define googleauthenticator::pam::rule (
$ensure='present',
$succeed_if=false,
$condition=false,
$nullok=false
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
