puppet-googleauthenticator
===========================

Google-authenticator module for Puppet.

This module allows to easily deploy google-authenticator two-step authentication for users via login, su and sshd, using the PAM google-authenticator module.

In order to use the module, you have to setup each PAM module using googleauthenticator::pam. Two values are currently possible for the mode:

* root-only: Only root will be prompted for a token for a this PAM module;
* all-users: All users will be prompted for a token for this PAM module.

In the second case, users who have not configured google-authenticator on their account will not be able to authenticate using the given module.

Requirements:

* Service['ssh'] must be managed for the node.

Example:

    # Setup PAM
    # Only root uses tokens locally, all users need one through SSH
    # Note that key authentication with SSH never requires a token
    googleauthenticator::pam {
      'login': mode => 'root-only';
      'su':    mode => 'root-only';
      'sshd':  mode => 'all-users';
    }

    # Add 2 step verification for a user
    googleauthenticator {'root':
      secret_key => 'C6SSDFBBH6P76EDM',
      scratch_codes => ['78905638', '14036415', '77983530', '22071921', '19861182'],
    }
