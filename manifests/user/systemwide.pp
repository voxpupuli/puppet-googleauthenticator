# @summary Setup Google-authenticator two-step verification for a user, systemwide.
#
# @param name The name of the user
# @param secret_key The secret key for the TOTP verification.
# @param ensure present/absent
# @param user Optionally, force the user name. Otherwise, $name is used.
# @param rate_limit Optionally, set rate limit.
# @param window_size Optionally, set window size
# @param disallow_reuse Optionally, set disallow reuse
# @param scratch_codes Specify scratch codes.
#
# @example Setup systemwide Google authenticator for the 'root' user
#  googleauthenticator::user::systemwide {'root':
#    secret_key    => 'C6SSDFBBH6P76EDM',
#    scratch_codes => ['78905638', '14036415', '77983530',
#                      '22071921', '19861182'],
#  }
define googleauthenticator::user::systemwide (
  $secret_key,
  $ensure='present',
  $user=undef,
  $rate_limit='3 30',
  $window_size='17',
  $disallow_reuse=true,
  $scratch_codes=[],
) {
  include googleauthenticator::user::systemwide::common

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

  file { $user_directory:
    ensure  => $_ensure,
    owner   => $real_user,
    group   => $real_user,
    mode    => '0700',
    # From googleauthenticator::user::systemwide::common
    require => File['/etc/google-authenticator'],
  }

  googleauthenticator::user { $name:
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
