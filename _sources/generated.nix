# This file was generated by nvfetcher, please do not modify it manually.
{ fetchgit, fetchurl, fetchFromGitHub, dockerTools }:
{
  milspec = {
    pname = "milspec";
    version = "11d492e7c3ef3b16a446415b303d239a26643f2b";
    src = fetchFromGitHub {
      owner = "nekowinston";
      repo = "milspec.nvim";
      rev = "11d492e7c3ef3b16a446415b303d239a26643f2b";
      fetchSubmodules = false;
      sha256 = "sha256-xk8gvWAuaBKjv2ZYMuE3NCozq6ahP7KA/BIoMd8tjmA=";
    };
    date = "2024-12-21";
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
  nu_scripts = {
    pname = "nu_scripts";
    version = "a31f8490fbe7f91925bc43b90ed535ea19daaeda";
    src = fetchFromGitHub {
      owner = "nushell";
      repo = "nu_scripts";
      rev = "a31f8490fbe7f91925bc43b90ed535ea19daaeda";
      fetchSubmodules = false;
      sha256 = "sha256-S080pwABIEp/ZT/gLyme7ozmWBiM37BbjHqftUieK3Y=";
    };
    date = "2025-02-09";
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
