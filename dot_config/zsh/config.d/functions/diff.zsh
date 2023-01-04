if [ -x "$(command -v colordiff)" ] && [ -x "$(command -v diff-so-fancy)" ]; then
  function diff() {
    colordiff -N -u "$@" | diff-so-fancy
  }

  function kdiff() {
    KUBECTL_EXTERNAL_DIFF="colordiff -N -u"
    kubectl diff "$@" | diff-so-fancy
  }
fi
