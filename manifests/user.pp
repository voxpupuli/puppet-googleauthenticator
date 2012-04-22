/*

== Definition: googleauthenticator

Setup Google-authenticator two-step verification for a user.

Parameters:

- *ensure*: present/absent;
- *secret_key*: the secret key for the TOTP verification;
- *user*: optionally, force the user name
    (otherwise, $name is used)
- *file*: optionally, force the configuration file
    (otherwise, ~/.google_authenticator is used);
- *rate_limit*: optionally, set rate limit
    (defaults to '3 30');
- *window_size*: optionally, set window size
    (defaults to '17');
- *disallow_reuse*: optionally, set disallow reuse
    (defaults to true);
- *scrach_codes*: specify scratch codes.

You should also setup at least one googleauthenticator::pam resource
in order to use this module.

Example usage:

    googleauthenticator::user {'root':
      secret_key    => 'C6SSDFBBH6P76EDM',
      scratch_codes => ['78905638', '14036415', '77983530',
                        '22071921', '19861182'],
    }
*/

define googleauthenticator::user (
$secret_key,
$ensure='present',
$user='',
$file='',
$rate_limit='3 30',
$window_size='17',
$disallow_reuse=true,
$scratch_codes=[]
) {

  # $real_user defaults to $name
  # it can be forced by specifying $user
  $real_user = $user ? {
    ''      => $name,
    default => $user,
  }

  # $real_file can be forced by specifying $file
  if ($file == '') {
    $real_file = $real_user ? {
      'root'  => '/root/.google_authenticator',
      default => "/home/${real_user}/.google_authenticator",
    }
  } else {
    $real_file = $file
  }

  file {$real_file:
    ensure  => $ensure,
    owner   => $real_user,
    group   => $real_user,
    mode    => '0400',
    content => template('googleauthenticator/google-authenticator.erb'),
  }
}
