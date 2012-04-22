puppet-googleauthenticator
===========================

Google-authenticator module for Puppet.

This module allows to easily deploy google-authenticator two-step authentication for users via login, su and sshd, using the PAM google-authenticator module.

In order to use the module, you have to setup each PAM module using googleauthenticator::pam. Two values are currently available by default for the mode:

* root-only: Only root will be prompted for a token for this PAM module;
* all-users: All users will be prompted for a token for this PAM module.

In the second case, users who have not configured google-authenticator on their account will not be able to authenticate using the given module.

You can setup new modes by adding googleauthenticator::pam::mode definitions, for example:

    googleauthenticator::pam::mode {'sysadmin':
      # Only ask for a token if users are in the sysadmin group
      condition => 'user ingroup sysadmin',
    }

    googleauthenticator::pam::mode {'optional-users':
      # Users with a UID above 1000 don't need a token
      succeed_if => 'uid > 1000',
      # It's ok to not have a ~/.google_authenticator file
      nullok     => true,
    }

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
    googleauthenticator::user {'root':
      secret_key => 'C6SSDFBBH6P76EDM',
      scratch_codes => ['78905638', '14036415', '77983530', '22071921', '19861182'],
    }

Note:

Because the PAM module for Google-authenticator currently uses only one file for both configuration and living data (see [ticket #167](http://code.google.com/p/google-authenticator/issues/detail?id=167)), scratch codes that are used get redeployed every time, and current values stored in the ~/.google_authenticator file (such as timestamps for rate limit) get overridden. The cleanest way to handle this would be for the PAM module to use two different files for configuration and living data, but this is currently not possible.
