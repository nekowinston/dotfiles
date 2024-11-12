{
  dbus,
  gnugrep,
  lib,
  stdenvNoCC,
  writeShellApplication,
}:
let
  inherit (stdenvNoCC) isDarwin isLinux;

  queryCommand =
    if isLinux then
      "dbus-send --session --print-reply=literal --reply-timeout=5 --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop org.freedesktop.portal.Settings.Read string:'org.freedesktop.appearance' string:'color-scheme' 2>/dev/null | grep -q 'uint32 1'"
    else if isDarwin then
      "defaults read -g AppleInterfaceStyle &>/dev/null"
    else
      throw "Unsupported platform";
in
writeShellApplication {
  name = "dark-mode-ternary";
  runtimeInputs = lib.optionals isLinux [
    dbus
    gnugrep
  ];
  text = # bash
    ''
      [[ -z "''${1-}" ]] && [[ -z "''${2-}" ]] && echo "Usage: $0 <dark> <light>" && exit 1

      if ${queryCommand}; then
        echo "$1"
      else
        echo "$2"
      fi
    '';
}
