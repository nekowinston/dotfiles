#!/usr/bin/env nu

let appleScript = {|it| '
tell application "Music"
  set _duration to duration of current track

	set player position to (' + ($it | into string) + ' * _duration)
end tell'}

if ($env.PERCENTAGE? != null) {
  osascript -e (do $appleScript (($env.PERCENTAGE | into int) / 100.0))
}
