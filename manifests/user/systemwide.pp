# == Definition: googleauthenticator::user::systemwide
#
# Setup Google-authenticator two-step verification for a user, systemwide.
#
# This is especially useful for users with encrypted homes,
# where the Google-authenticator file cannot be stored in the
# encrypted home directory.
#
# This definition is a wrapper around googleauthenticator::user.
#
# Parameters:
#
# - *ensure*: present/absent;
# - *secret_key*: the secret key for the TOTP verification;
# - *user*: optionally, force the user name
#     (otherwise, $name is used)
# - *rate_limit*: optionally, set rate limit;
# - *window_size*: optionally, set window size;
# - *disallow_reuse*: optionally, set disallow reuse;
# - *scrach_codes*: specify scratch codes.
#
# Example usage:
#
#     googleauthenticator::user::systemwide {'root':
#       secret_key    => 'C6SSDFBBH6P76EDM',
#       scratch_codes => ['78905638', '14036415', '77983530',
#                         '22071921', '19861182'],
#     }
#
define googleauthenticator::user::systemwide(
  $secret_key,
  $ensure='present',
  $user=undef,
  $rate_limit='3 30',
  $window_size='17',
  $disallow_reuse=true,
  $scratch_codes=[],
) {

  include ::googleauthenticator::user::systemwide::common

  # $real_user defaults to $name
  # it can be forced by specifying $user
  $real_user = $user ? {
    undef   => $name,
    default => $user,
  }

  $user_directory = "/etc/google-authenticator/${real_user}"
  $user_file = "${user_directory}/google_authenticator"

  $_ensure = $ensure ? {
    'present' => directory,
    default   => $ensure,
  }

  file {$user_directory:
    ensure  => $_ensure,
    owner   => $real_user,
    group   => $real_user,
    mode    => '0700',
    # From googleauthenticator::user::systemwide::common
    require => File['/etc/google-authenticator'],
  }

  googleauthenticator::user {$name:
    ensure         => $ensure,
    secret_key     => $secret_key,
    user           => $real_user,
    file           => $user_file,
    rate_limit     => $rate_limit,
    window_size    => $window_size,
    disallow_reuse => $disallow_reuse,
    scratch_codes  => $scratch_codes,
    require        => File[$user_directory],
  }
}
