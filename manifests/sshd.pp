# == Class: googleauthenticator::sshd
#
# Setup sshd to use Google-authenticator two-step verification.
#
# It shouldn't be necessary to directly include this class.
#
# It might be better to use some ssh::config definition
class googleauthenticator::sshd {
  augeas { 'Setup sshd for google-authenticator':
    context => '/files/etc/ssh/sshd_config',
    changes => [
      'set PasswordAuthentication yes',
      'set ChallengeResponseAuthentication yes',
      'set UsePAM yes',
    ],
  }
}
