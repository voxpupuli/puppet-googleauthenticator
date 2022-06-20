# @summary Setup Google-authenticator two-step verification for a user.
#
# @param name The name of the user
# @param secret_key The secret key for the TOTP verification.
# @param ensure present/absent
# @param user Optionally, force the user name. Otherwise, $name is used.
# @param group Optionally, force the group name. Otherwise, $name is used.
# @param file Optionally, force the configuration file. Otherwise, ~/.google_authenticator is used.
# @param rate_limit Optionally, set rate limit.
# @param window_size Optionally, set window size
# @param disallow_reuse Optionally, set disallow reuse
# @param scratch_codes Specify scratch codes.
#
# @example Setup Google authenticator for the 'root' user
#  googleauthenticator::user {'root':
#    secret_key    => 'C6SSDFBBH6P76EDM',
#    scratch_codes => ['78905638', '14036415', '77983530',
#                      '22071921', '19861182'],
#  }
define googleauthenticator::user (
  $secret_key,
  $ensure='present',
  $user=undef,
  $group=undef,
  $file=undef,
  $rate_limit='3 30',
  $window_size='17',
  $disallow_reuse=true,
  $scratch_codes=[],
) {
  # $real_user defaults to $name
  # it can be forced by specifying $user
  $real_user = $user ? {
    undef   => $name,
    default => $user,
  }

  $real_group = $group ? {
    undef   => $name,
    default => $user,
  }

  # $real_file can be forced by specifying $file
  if $file {
    $real_file = $file
  } else {
    $real_file = $real_user ? {
      'root'  => '/root/.google_authenticator',
      default => "/home/${real_user}/.google_authenticator",
    }
  }

  file { $real_file:
    ensure    => $ensure,
    owner     => $real_user,
    group     => $real_group,
    mode      => '0400',
    content   => template('googleauthenticator/google-authenticator.erb'),
    show_diff => false,
  }
}
