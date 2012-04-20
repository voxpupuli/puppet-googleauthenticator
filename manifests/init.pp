define googleauthenticator (
$secret_key,
$ensure='present',
$user='',
$file='',
$rate_limit='3 30',
$window_size='17',
$disallow_reuse=true,
$scratch_codes=[]
) {

  include googleauthenticator::common
  include googleauthenticator::sshd

  # $real_user defaults to $name
  # it can be forced by specifying $user
  $real_user = $user ? {
    ''      => $name,
    default => $user,
  }

  # $real_file can be forced by specifying $file
  if ($file == '') {
    $real_file = $real_user ? {
      'root'  => '/root/.google-authenticator',
      default => "/home/${real_user}/.google-authenticator",
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
