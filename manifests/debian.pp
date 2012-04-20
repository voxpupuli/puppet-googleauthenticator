class googleauthenticator::debian {
  package {'libpam-google-authenticator':
    ensure => installed,
    notify => Service['ssh'],
  }

  include googleauthenticator::params

  googleauthenticator::debian::pam {
    'login': mode => $googleauthenticator::params::login_mode;
    'su':    mode => $googleauthenticator::params::su_mode;
    'sshd':  mode => $googleauthenticator::params::sshd_mode;
  }
}
