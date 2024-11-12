#!/usr/bin/env nu

def main [workspace?: string ] {
  let state = if ($workspace == ($env.FOCUSED_WORKSPACE? | default "")) { "on" } else { "off" }

  sketchybar --set $env.NAME $"icon.highlight=($state)" $"background.drawing=($state)"
}
