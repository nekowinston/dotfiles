{ config, lib, ... }:
let
  cfg = config.hardware.keyboard.keychron-k6;
  inherit (lib) mkEnableOption mkIf;
in

{
  options.hardware.keyboard.keychron-k6 = {
    enable = mkEnableOption ''
      Kanata to apply my custom mappings for the Keychron K6
    '';
  };

  config = mkIf cfg.enable {
    hardware.keyboard.qmk.enable = true;

    services.kanata = {
      enable = true;
      keyboards.keychron-k6 = {
        devices = [ "/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd" ];
        config = # scheme
          ''
            (defsrc
              esc   1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab   q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps  a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft  z    x    c    v    b    n    m    ,    .    /    rsft
              lctl  lmet lalt           spc            ralt rmet rctl)

            (deflayer qwerty
              @sesc 1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab   q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps  a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft  z    x    c    v    b    n    m    ,    .    /    rsft
              lctl  lmet lalt           spc            ralt rmet rctl)

            (defalias sesc (fork esc grv (lsft rsft)))
          '';
      };
    };
  };
}
