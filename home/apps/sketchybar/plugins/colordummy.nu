#!/usr/bin/env nu
# vim:fdm=marker

# color definitions {{{
const variants = {
  dark: {
    fg: 0xffffff
    bg: 0x1c2127
    gray: 0xc5cbd3
    bgGray: 0x404854
    fgGray: 0xd3d8de
    core: 0x111418
    blue: 0x8abbff
    green: 0x72ca9b
    orange: 0xfbb360
    red: 0xfa999c
    vermilion: 0xff9980
    rose: 0xff66a1
    violet: 0xd69fd6
    indigo: 0xbdadff
    cerulean: 0x68c1ee
    turquoise: 0x7ae1d8
    forest: 0x62d96b
    lime: 0xd4f17e
    gold: 0xfbd065
    sepia: 0xd0b090
  }
  light: {
    fg: 0x111418
    bg: 0xf6f7f9
    gray: 0x5f6b7c
    bgGray: 0xd3d8de
    fgGray: 0x404854
    core: 0xffffff
    blue: 0x2d72d2
    green: 0x238551
    orange: 0xc87619
    red: 0xcd4246
    vermilion: 0xd33d17
    rose: 0xdb2c6f
    violet: 0x9d3f9d
    indigo: 0x7961db
    cerulean: 0x147eb3
    turquoise: 0x00a396
    forest: 0x29a634
    lime: 0x8eb125
    gold: 0xd1980b
    sepia: 0x946638
  }
}
# }}}

# check whether or not macOS is in dark mode
let theme = if ((defaults read -g AppleInterfaceStyle err>/dev/null) != "Dark") {
  "light"
} else {
  "dark"
}

def color [name: string, alpha: float = 1.0] {
  let color = ($variants) | get -i $theme | get -i $name | default null
  let alpha = [0.0 ([$alpha 1.0] | math min)] | math max
    | $in * 255
    | math round
    | bits shl 24 -n 4

  if $color == null {
    error make {
      msg: "Error formatting color"
      label: {
        text: "Color name not found"
        span: (metadata $name).span
      }
      help: $"Expected one of: ($variants | get $theme | columns | str join ', ')"
    }
  }

  $alpha bit-or $color
    | fmt
    | get lowerhex
    | str replace "0x" ""
    | fill --alignment "right" --character "0" --width 8
    | "0x" + $in
}

(sketchybar
  --bar
    $"color=(color bg)"
  --default
    $"icon.color=(color fg)"
    $"label.color=(color fg)"
  --set /space/
    $"icon.color=(color bgGray)"
    $"icon.highlight_color=(color blue)"
  --set music
    $"icon.color=(color fgGray)"
    $"label.color=(color fgGray)"
  --set music_progress
    $"slider.highlight_color=(color blue)"
    $"slider.background.color=(color bgGray)"
  --set "Mullvad VPN"
    $"alias.color=(color orange)"
  --set "Control Center,Battery"
    $"alias.color=(color gold)"
  --set clock
    $"icon.color=(color violet)"
    $"label.color=(color violet)")

# set the jankyborders colors as well
if ((which borders).type?.0? == "external") {
  (borders
    $"active_color=(color blue)"
    $"inactive_color=(color gray)"
    width=5.0)
}
