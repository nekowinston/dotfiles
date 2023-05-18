{
  hardware.keyboard.qmk.enable = true;
  services.kanata = {
    enable = true;
    keyboards.keychron-k6 = {
      devices = ["/dev/input/by-id/usb-Keychron_Keychron_K6-event-kbd"];
      config = ''
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

        (defalias
          sesc (fork esc grv (lsft rsft))
        )
      '';
    };
  };
}
