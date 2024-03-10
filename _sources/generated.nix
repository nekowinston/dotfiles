# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catppuccin-bat = {
    pname = "catppuccin-bat";
    version = "0ce3d34921ba1b544a4d82aa01352abd553d51ef";
    src = fetchgit {
      url = "https://github.com/catppuccin/bat";
      rev = "0ce3d34921ba1b544a4d82aa01352abd553d51ef";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-PLbTLj0qhsDj+xm+OML/AQsfRQVPXLYQNEPllgKcEx4=";
    };
    date = "2024-03-02";
  };
  catppuccin-wezterm = {
    pname = "catppuccin-wezterm";
    version = "b1a81bae74d66eaae16457f2d8f151b5bd4fe5da";
    src = fetchgit {
      url = "https://github.com/catppuccin/wezterm";
      rev = "b1a81bae74d66eaae16457f2d8f151b5bd4fe5da";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-McSWoZaJeK+oqdK/0vjiRxZGuLBpEB10Zg4+7p5dIGY=";
    };
    date = "2023-04-12";
  };
  catppuccin-zsh-fsh = {
    pname = "catppuccin-zsh-fsh";
    version = "d2a1ba1d4aa36edfa34ed687bd84ef1e2db481b7";
    src = fetchgit {
      url = "https://github.com/catppuccin/zsh-fsh";
      rev = "d2a1ba1d4aa36edfa34ed687bd84ef1e2db481b7";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-DYWpivDyhW9ZZD2tqpQgXFz7u947mKOUvvz+RQnVslU=";
    };
    date = "2024-03-10";
  };
  nekowinston-wezterm-bar = {
    pname = "nekowinston-wezterm-bar";
    version = "e96b81460b3ad11a7461934dcb7889ce5079f97f";
    src = fetchgit {
      url = "https://github.com/nekowinston/wezterm-bar";
      rev = "e96b81460b3ad11a7461934dcb7889ce5079f97f";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-3acxqJ9HMA5hASWq/sVL9QQjfEw5Xrh2fT9nFuGjzHM=";
    };
    date = "2023-05-10";
  };
  yabai = {
    pname = "yabai";
    version = "v6.0.12";
    src = fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v6.0.12/yabai-v6.0.12.tar.gz";
      sha256 = "sha256-0YJN7XRpseXZnVXDcsv/8w8pen0sE52qQmS+xFni6V0=";
    };
  };
  zsh-fast-syntax-highlighting = {
    pname = "zsh-fast-syntax-highlighting";
    version = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
    src = fetchgit {
      url = "https://github.com/zdharma-continuum/fast-syntax-highlighting";
      rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
      fetchSubmodules = false;
      deepClone = false;
      leaveDotGit = false;
      sha256 = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
    };
    date = "2023-07-05";
  };
}
