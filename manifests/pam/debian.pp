/*

== Definition: googleauthenticator::pam::debian

Set a kernel module as blacklisted.
Setup a PAM module for Google-authenticator on Debian/Ubuntu.

This module is meant to be called from the googleauthenticator::pam wrapper module.

Parameters:
- *ensure*: present/absent;
- *mode*: Set the mode to use ('root-only' or 'all-users' are supported right now).

*/

define googleauthenticator::pam::debian (
$mode,
$ensure='present'
) {
  $file = $mode ? {
    'root-only' => 'google-authenticator-root-only',
    default     => 'google-authenticator',
  }

  $lastauth = '*[type = "auth" or label() = "include" and . = "common-auth"][last()]'

  case $ensure {
    present: {
      augeas {"Add google-authenticator to ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => [
          "rm include[. =~ regexp('google-authenticator.*')]", # Purge existing entries
          "ins include after ${lastauth}",
          "set include[. = ''] '${file}'",
          ],
        require => File["/etc/pam.d/${file}"],
        notify => Service['ssh'],
      }
    }
    absent: {
      augeas {"Purge existing google-authenticator from ${name}":
        context => "/files/etc/pam.d/${name}",
        changes => "rm include[. =~ regexp('google-authenticator.*')]",
        notify => Service['ssh'],
      }
    }
  }
}
