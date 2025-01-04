{ ... }:

{
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      {
        name = "ghostty";
        greedy = true;
      }
    ];
  };
}
