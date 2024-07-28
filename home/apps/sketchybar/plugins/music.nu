#!/usr/bin/env nu

if (pgrep -x Music | is-empty) {
  (sketchybar
    --set $env.NAME
      label=""
    --set $"($env.NAME)-progress"
      slider.percentage=0
      slider.width=0
  )
  return
}

let appleScript = '
tell application "Music"
  -- set to a fixed string
  if player state is playing then
    set _state to "playing"
  else
    set _state to "paused"
  end if

  set _albumArtist to ""
  set _trackArtist to ""
  set _name to ""
  set _duration to ""
  set _progress to "0,0"

  -- allow this to fail when Music hasnt played a track yet
  try
    set _albumArtist to album artist of current track
    set _trackArtist to artist of current track
    set _name to name of current track
    set _duration to duration of current track
  end try

  if _albumArtist is "" or _albumArtist is "Various Artists" then
    set _artist to _trackArtist
  else
    set _artist to _albumArtist
  end if

  -- wrap the progress in a try to handle division by zero
  try
    set _progress to player position / _duration
  end try


  set songData to {_state, _artist, _name, _progress}

  set output to ""
  repeat with _item in songData
    set output to output & _item & "\n"
  end repeat
end tell'

let cachePath = ($env.XDG_CACHE_HOME? | default $"($env.HOME)/.cache") | path join "apple-music-status.scpt"

# for debugging
let alwaysCompile = false

if (not ($cachePath | path exists) or $alwaysCompile) {
  osacompile -o $cachePath -e $appleScript
}

let result = osascript $cachePath
  | lines
  | {
    state: ($in.0?),
    artist: ($in.1?)
    track: ($in.2?)
    progress: (
      $in.3?
        | str replace "," "."
        | into float
        | $in * 100.0
    )
  }

let label = if ($result.state == "playing") {
  $"($result.artist) - ($result.track)"
} else ""

sketchybar --set $env.NAME $"label=($label)"

let width = if ($result.state == "playing") {
  (sketchybar --query $env.NAME | from json).bounding_rects?.display-1?.size?.0? | default 0
} else 0

(sketchybar
  --set $"($env.NAME)_progress"
    $"padding_left=-($width - 7)"
    $"slider.percentage=($result.progress)"
    $"slider.width=($width - 20)"
)
