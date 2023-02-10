{
  buildGoModule,
  fetchFromGitHub,
  lib,
  ...
}:
buildGoModule rec {
  pname = "discord-applemusic-rich-presence";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "discord-applemusic-rich-presence";
    rev = "v${version}";
    sha256 = "sha256-PCA0Thzng1C08NwBTh3Hl4yW2qvYXra6EZHrJxoCgIU=";
  };

  vendorSha256 = "sha256-RFJTBfsfEyKn9OSvE2HLgjKiJC3Hs90+P9rm5GlIseo=";

  meta = with lib; {
    description = "Discord's Rich Presence from Apple Music";
    homepage = "https://github.com/caarlos0/discord-applemusic-rich-presence";
    license = licenses.mit;
    maintainers = [maintainers.nekowinston];
    platforms = platforms.darwin;
  };
}
