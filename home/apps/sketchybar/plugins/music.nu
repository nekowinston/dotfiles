#!/usr/bin/env nu

if (pgrep -x Music | is-not-empty) {
  let result = osascript -l JavaScript -e "
    var music = Application("Music");
    JSON.stringify({
      albumArtist: music.currentTrack.albumArtist(),
      artist: music.currentTrack.artist(),
      state: music.playerState(),
      track: music.currentTrack.name(),
    });" | from json

  let artist = if (($result.albumArtist | is-empty) or ($result.albumArtist == "Various Artists")) {
    $result.artist
  } else $result.albumArtist

  let label = if ($result.state == "playing") {
    $"($artist) - ($result.track)"
  } else ""

  (sketchybar
    --set $env.NAME $"label=($label)"
    icon.font="Symbols Nerd Font:2048-em:18.0"
    label.font="Berkeley Mono:Bold:16.0" y_offset="3")
} else (sketchybar --set $env.NAME label="")
