{ ... }: {
  
  programs.nixvim = {

    plugins.godot = {
      enable = true;
      godotPackage = null;
    };

  };

}

