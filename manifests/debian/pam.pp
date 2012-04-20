define googleauthenticator::debian::pam (
$ensure='present',
$mode='all-users'
) {
  $ga_chain = $mode ? {
    'root-only' => 'google-authenticator-root-only',
    default     => 'google-authenticator',
  }

  $lastauth = '*[type = "auth" or label() = "include" and . = "common-auth"][last()]'

  augeas {"add google-authenticator to ${name}":
    context => "/files/etc/pam.d/${name}",
    changes => [
      "ins include after ${lastauth}",
      "set include[. = ''] '${ga_chain}'",
      ],
    onlyif  => "match include[. = '${ga_chain}'] size == 0",
    notify => Service['ssh'],
  }
}
