if [ -x "$(command -v lsd)" ]; then
  # add a bit more space between the file icon & name
  alias ls='lsd'
  alias l='lsd'
  alias ll='lsd -l'
  alias la='lsd -la'
  alias lt='lsd -l --total-size' alias lat='lsd -lA --total-size'
  alias tree='lsd --tree'
else
  alias l='ls'
  alias ll='ls -l'
  alias la='ls -lA'
fi
