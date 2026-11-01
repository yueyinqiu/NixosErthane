{ config, lib, pkgs, ... }:
let
  yaml = pkgs.formats.yaml { };

  socketDirectory = "/run/user-tun";
  controllerDirectory = "${socketDirectory}/controller";
  controllerGroup = "user-tun-controller";

  mihomoSocksPort = 53077;

  ports = {
    yueyinqiu = 43007;
  };

  users = lib.mapAttrsToList (name: port:
    let
      uid = toString config.users.users.${name}.uid;
    in
    {
      name = name;
      port = port;
      uid = uid;
      socketDirectory = "${socketDirectory}/${uid}";
    }
  ) ports;

  mihomoConfig = yaml.generate "mihomo-config.yaml" {
    mode = "rule";
    log-level = "info";
    listeners = [
      {
        name = "tun-in";
        type = "tun";
        stack = "system";
        auto-route = true;
        auto-detect-interface = true;
        find-process-mode = "strict";
      }
      {
        name = "mixed-in";
        type = "mixed";
        port = mihomoSocksPort;
        listen = "127.0.0.1";
      }
    ];
    proxies = map (u: {
      name = "user-${u.uid}";
      type = "socks5";
      server = "127.0.0.1";
      port = u.port;
    }) users;
    proxy-groups = [
      {
        name = "others";
        type = "select";
        proxies = [ "REJECT" "DIRECT" ] ++ (map (u: "user-${u.uid}") users);
      }
    ];
    rules =
      [ "IN-NAME,mixed-in,DIRECT" ]
      ++ map (u: "UID,${u.uid},user-${u.uid}") users
      ++ [ "MATCH,others" ];
  };

  gostSystemConfig = yaml.generate "gost-system.yaml" {
    services = map (u: {
      name = "user-${u.uid}";
      addr = "127.0.0.1:${toString u.port}";
      handler = { type = "tcp"; chain = "to-${u.uid}"; };
      listener = { type = "tcp"; };
    }) users;
    chains = map (u: {
      name = "to-${u.uid}";
      hops = [
        {
          name = "hop-0";
          nodes = [
            {
              name = "user-sock";
              addr = u.socketDirectory;
              connector = { type = "unix"; };
              dialer = { type = "unix"; };
            }
          ];
        }
      ];
    }) users;
  };
in
{
  assertions = lib.mapAttrsToList (name: _: {
    assertion = config.users.users.${name}.uid != null;
    message = "user-tun: Cannot obtain UID for `${name}`.";
  }) ports;

  users.groups.${controllerGroup} = { };
  systemd.services.mihomo.serviceConfig.SupplementaryGroups = [ controllerGroup ];

  services.mihomo = {
    enable = true;
    tunMode = true;
    processesInfo = true;
    configFile = mihomoConfig;
    extraOpts = "-ext-ctl-unix ${controllerDirectory}/mihomo.sock";
  };

  systemd.services.user-tun-gost = {
    wantedBy = [ "multi-user.target" ];
    after = [ "mihomo.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.gost}/bin/gost -C ${gostSystemConfig}";
      Restart = "on-failure";
      RestartSec = 3;
      DynamicUser = true;
      SupplementaryGroups = [ controllerGroup ];
    };
  };

  systemd.tmpfiles.rules =
    [ "d ${socketDirectory} 0755 root ${controllerGroup} -"
      "d ${controllerDirectory} 0770 root ${controllerGroup} -" ]
    ++ map (u: "d ${u.socketDirectory} 0770 ${u.name} ${controllerGroup} -") users;
}