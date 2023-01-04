local MAPPINGS='
video/3gpp,3gp
video/3gpp2,3g2
video/MP2T,mpegts
video/MP2T,mpegtsraw
video/mp4,mp4
video/mpeg,mpeg
video/ogg,ogv
video/quicktime,mov
video/webm,webm
'
# format=$(echo "$MAPPINGS" | grep "$headers" | cut -d "," -f2-)

function icat() {
  function display() {
    if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
      cat - | wezterm imgcat
    elif [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
      cat - | $(alias imgcat | cut -d "=" -f2-)
    elif [[ "$TERM" = "xterm-kitty" ]]; then
      cat - | kitty +kitten icat
    else
      echo "No image viewer defined for this terminal" && return 1
    fi
    return 0
  }
  function displaySVG() {
    [[ ! -x "$(command -v convert)" ]] && echo "convert not found, install imagemagick" && return 1
    convert -background none -density 192 - png:- | display
  }
  function displayVID() {
    ffmpeg -loglevel fatal -hide_banner -i "$1" -vf scale=720:-1 -r 10 -f image2pipe -vcodec ppm pipe:1 | \
      convert -delay 10 -loop 1 - gif:- | \
      display
  }

  if [ ! -t 0 ]; then
    input="$(cat - | base64)"
    headers="$(echo "$input" | base64 -d | file - --mime-type | cut -d " " -f2-)"

    case $headers in
      *svg*) echo "$input" | base64 -d | displaySVG ;;
      *video*) echo "haven't figured this part out yet" && return 1;;
      *image*) echo "$input" | base64 -d | display ;;
      *) echo "Unknown file type" && return 1 ;;
    esac
  elif [[ "$1" == http* ]]; then
    case "$(curl -sSLI "$1" | grep -i "^content-type:")" in
      *svg*) curl -fsSL "$1" | displaySVG ;;
      *video*) echo "haven't figured this part out yet" && return 1;;
      *image*) curl -fsSL "$1" | display ;;
      *) echo "Unknown file type" && return 1 ;;
    esac
  else
    [[ -z "$1" ]] && echo "Usage: icat <file|url>" && return 1
    [[ ! -f "$1" ]] && echo "File not found: $1" && return 1
    case "$(file -b --mime-type "$1")" in
      *svg*) cat "$1" | displaySVG ;;
      *video*) displayVID $1 ;;
      *image*) cat "$1" | display ;;
      *) echo "Unknown file type" && return 1 ;;
    esac
  fi
}
