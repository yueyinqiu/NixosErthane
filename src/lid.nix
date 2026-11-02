{
  ...
}:
{
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
  };
  services.upower.ignoreLid = true;
}
