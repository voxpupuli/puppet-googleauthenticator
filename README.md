puppet-googleauthenticator
===========================

Google-authenticator module for Puppet.

This module allows to easily deploy google-authenticator two-step authentication for users via login, su and sshd, using the PAM google-authenticator module.

For now, the module is meant to do the following:

For login/su:

* Normal users are never prompted for a token;
* root is prompted for a token.

For SSH:

* All users must provide a token for password authentication.


Example:

    googleauthenticator {'root':
      secret_key => 'C6SSDFBBH6P76EDM',
      scratch_codes => ['78905638', '14036415', '77983530', '22071921', '19861182'],
    }
