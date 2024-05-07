{
  imports = [ ../common/wsl ];

  i18n.defaultLocale = "en_US.UTF-8";
  location = {
    latitude = 48.210033;
    longitude = 16.363449;
  };
  time.timeZone = "Europe/Vienna";

  wsl = {
    enable = true;
    defaultUser = "winston";
    startMenuLaunchers = true;
    useWindowsDriver = true;
  };
}
