# if we're not on mac, exit
[[ "$(uname)" != "Darwin" ]] && exit 0

function twm() {
  case "$1" in
    "start")
      brew services start skhd
      brew services start yabai
      ;;
    "stop")
      brew services stop skhd
      brew services stop yabai
      ;;
    "restart")
      launchctl kickstart -k "gui/${UID}/homebrew.mxcl.skhd"
      launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"
      ;;
    *)
      echo "Usage: twm <start|restart|stop>"
      return 1
      ;;
  esac
}

alias sbks='launchctl kickstart -k "gui/${UID}/homebrew.mxcl.sketchybar"'
