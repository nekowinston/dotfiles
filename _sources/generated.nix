# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  catppuccin-bat = {
    pname = "catppuccin-bat";
    version = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "bat";
      rev = "d3feec47b16a8e99eabb34cdfbaa115541d374fc";
      fetchSubmodules = false;
      sha256 = "sha256-s0CHTihXlBMCKmbBBb8dUhfgOOQu9PBCQ+uviy7o47w=";
    };
    date = "2024-08-05";
  };
  milspec = {
    pname = "milspec";
    version = "3988464c4514e441b4f81599507bdf2815b2f9e2";
    src = fetchFromGitHub {
      owner = "nekowinston";
      repo = "milspec.nvim";
      rev = "3988464c4514e441b4f81599507bdf2815b2f9e2";
      fetchSubmodules = false;
      sha256 = "sha256-2U8yqLqTnal0CAZOD8bWrv/bprl7Tusg1H5gnasbfVY=";
    };
    date = "2024-06-08";
  };
  nekowinston-wezterm-bar = {
    pname = "nekowinston-wezterm-bar";
    version = "e96b81460b3ad11a7461934dcb7889ce5079f97f";
    src = fetchFromGitHub {
      owner = "nekowinston";
      repo = "wezterm-bar";
      rev = "e96b81460b3ad11a7461934dcb7889ce5079f97f";
      fetchSubmodules = false;
      sha256 = "sha256-3acxqJ9HMA5hASWq/sVL9QQjfEw5Xrh2fT9nFuGjzHM=";
    };
    date = "2023-05-10";
  };
  yabai = {
    pname = "yabai";
    version = "v7.1.3";
    src = fetchurl {
      url = "https://github.com/koekeishiya/yabai/releases/download/v7.1.3/yabai-v7.1.3.tar.gz";
      sha256 = "sha256-eq7nUb/a8fjXiyy+tRmAr+gv1JYNCB5MYjualCL6JaU=";
    };
  };
  zsh-fast-syntax-highlighting = {
    pname = "zsh-fast-syntax-highlighting";
    version = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
    src = fetchFromGitHub {
      owner = "zdharma-continuum";
      repo = "fast-syntax-highlighting";
      rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
      fetchSubmodules = false;
      sha256 = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
    };
    date = "2023-07-05";
  };
}
