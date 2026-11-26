# A real certificate for print.free-side.us on the CUPS server (modules/nixos/printing.nix), and the password of bedwards for its web pages.
# Let's Encrypt, by the DNS challenge through Cloudflare, so the Pi needs no port open to the internet. The Cloudflare token is its own: it may only
# edit DNS records of free-side.us. Both secrets are in secrets/print.yaml, encrypted to the YubiKey keys and to the Pi's own key (its SSH host key,
# see .sops.yaml), so this module is added to modules/hosts/print.nix only after that file exists:
#
#   cloudflare-dns-token: <the token, and nothing else>
#   bedwards-password: <a hash made with  mkpasswd -m yescrypt>
{ ... }:
{
  flake.modules.nixos.print-tls =
    { config, ... }:
    let
      name = "print.free-side.us";
      acmeDir = "/var/lib/acme/${name}";
      sopsFile = ../../secrets/print.yaml;
    in
    {
      sops.secrets."cloudflare-dns-token" = {
        inherit sopsFile;
      };

      # The CUPS web pages sign in with a system account (the wheel group), and bedwards has no password otherwise (SSH is key-only)
      sops.secrets."bedwards-password" = {
        inherit sopsFile;
        neededForUsers = true;
      };
      users.users.bedwards.hashedPasswordFile = config.sops.secrets."bedwards-password".path;

      security.acme = {
        acceptTerms = true;
        defaults.email = "brian@edwardstx.us";
        certs.${name} = {
          dnsProvider = "cloudflare";
          # lego reads the token from the file the _FILE variable names
          credentialFiles.CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets."cloudflare-dns-token".path;
          # The record is checked at Cloudflare's own resolver: the local DNS (the UDM) answers for free-side.us with local addresses
          dnsResolver = "1.1.1.1:53";
          # CUPS reads the certificate when it starts
          reloadServices = [ "cups.service" ];
        };
      };

      # CUPS looks for <ServerName>.crt and .key in its ssl directory (/var/lib/cups/ssl) and makes a self-signed one when they are not there
      systemd.tmpfiles.rules = [
        "L+ /var/lib/cups/ssl/${name}.crt - - - - ${acmeDir}/fullchain.pem"
        "L+ /var/lib/cups/ssl/${name}.key - - - - ${acmeDir}/key.pem"
      ];
      # And is started only once the certificate is there, so it never serves the self-signed one
      systemd.services.cups = {
        wants = [ "acme-finished-${name}.target" ];
        after = [ "acme-finished-${name}.target" ];
      };
    };
}
