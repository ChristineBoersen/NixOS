# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, options, ... }:



{

    imports = [
    (builtins.fetchTarball {
      # Pick a commit from the branch you are interested in
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/e47f3719f1db3e0961a4358d4cb234a0acaa7baf/nixos-mailserver-e47f3719f1db3e0961a4358d4cb234a0acaa7baf.tar.gz";
      # And set its hash
      sha256 = "6983B9DCC71FEFF20EC7462078D44C19CAC3CF6C36F98A4C5DDEFFFEA732454F";
    })
  ];

  mailserver = {
    enable = true;
    #extraVirtualAliases = {};
    fqdn = "mail2.mclsystems.com";
    #forwards = {};
    domains = [ "mclsystems.com" ];
    hierarchySeparator = "/";

    # Alternative, we could just configure LDAP and have the accounts set themselves up, they will auto-create the unix user id if done correctly
    ldap = {
        bind = {
            dn = "cn=mail,ou=users,dc=mclsystems,dc=com",
            passwordFile = "",
            doc
        };
    };

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    #loginAccounts = {
    #    "user1@example.com" = {
    #        hashedPasswordFile = "/a/file/containing/a/hashed/password";
    #        aliases = ["postmaster@example.com"];
    #    };
    #    "user2@example.com" = { ... };
    #};

    #certificateFile = "/root/mclsystems.com.crt"
    certificateScheme = "manual";
  };


}
