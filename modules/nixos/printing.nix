# A CUPS print server for one USB label printer, the Brother TD-4210D (modules/hosts/print.nix). Two queues for it:
#
#   td4210d-raw   nothing is changed: what a client sends goes to the printer as it is. The printer recognises ZPL II, CPCL, ESC/P, Brother Raster and
#                 P-touch Template by itself, so a script or label program writes the language it likes:  lp -d td4210d-raw -o raw label.zpl
#   td4210d       documents (a PDF, a page from any program) as labels: CUPS turns the page into a bitmap and writes it as ZPL II (CUPS's own rastertolabel
#                 filter and its stock "Zebra ZPL" PPD, drv:///sample.drv/zebra.ppd). Label sizes are the PageSize option, 4 x 2 in is the default:
#                   w288h144  4 x 2 in     w216h144  3 x 2 in     w144h72  2 x 1 in      lp -d td4210d -o PageSize=w216h144 file.pdf
#
# Clients find it by name (print.free-side.us) or by mDNS (Avahi). Access is the local network only. The USB address is the one `lpinfo -v` shows
# with the printer plugged in; without a serial number it is the first Brother TD-4210D.
{ ... }:
{
  flake.modules.nixos.printing =
    { pkgs, ... }:
    let
      usbPrinter = "usb://Brother/TD-4210D";
    in
    {
      services.printing = {
        enable = true;
        # Every address, but only the local network is let in (allowFrom), and the firewall opens the port
        listenAddresses = [ "*:631" ];
        allowFrom = [ "@LOCAL" ];
        openFirewall = true;
        defaultShared = true;
        browsing = true;
        webInterface = true;

        # CUPS answers a request whose Host is not its ServerName or an alias with "Bad Request": the DNS name, the mDNS name and the short name
        extraConf = ''
          ServerName print.free-side.us
          ServerAlias print.local
          ServerAlias print
        '';

        # A job sent as application/octet-stream (what a program that does not know the printer sends) is let through to a raw queue as raw data:
        # CUPS ships that conversion switched off. Only a queue without a driver passes it on.
        drivers = [ (pkgs.writeTextDir "share/cups/mime/raw-labels.convs" "application/octet-stream application/vnd.cups-raw 0 -\n") ];
      };

      # The printer queues, made when CUPS starts: `lpadmin` is not needed, and a queue taken out here is removed
      hardware.printers = {
        ensureDefaultPrinter = "td4210d";
        ensurePrinters = [
          {
            name = "td4210d-raw";
            description = "Brother TD-4210D, raw (ZPL II, CPCL, ESC/P, Brother Raster: sent as it is)";
            location = "print.free-side.us";
            deviceUri = usbPrinter;
            model = "raw";
          }
          {
            name = "td4210d";
            description = "Brother TD-4210D, documents as labels (ZPL II)";
            location = "print.free-side.us";
            deviceUri = usbPrinter;
            model = "drv:///sample.drv/zebra.ppd";
            ppdOptions = {
              PageSize = "w288h144";
              Resolution = "203dpi";
              zeMediaTracking = "Web";
            };
          }
        ];
      };

      # Printers are announced on the network (DNS-SD), and the name print.local resolves (Avahi)
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        # Publish the printers (DNS-SD) and the addresses (print.local)
        settings.publish = {
          "disable-publishing" = false;
          "disable-user-service-publishing" = false;
          "publish-addresses" = true;
        };
      };
    };
}
