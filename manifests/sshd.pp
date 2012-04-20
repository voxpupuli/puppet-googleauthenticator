class googleauthenticator::sshd {
  augeas {'Setup sshd for google-authenticator':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set PasswordAuthentication yes',
      'set ChallengeResponseAuthentication yes',
      'set UsePAM yes',
      ],
  }
}
