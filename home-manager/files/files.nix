{ ... }:

let
  nixshellTemplateDir = ./files/_nixshell_templates;
  nixshellTemplates = builtins.listToAttrs (map
    (name: {
      name = "_nixshell_templates/${name}";
      value = {
        source = "${nixshellTemplateDir}/${name}";
      };
    })
    (builtins.attrNames (builtins.readDir nixshellTemplateDir))
  );

  flakeTemplateDir = ./files/_flake_templates;
  flakeTemplates = builtins.listToAttrs (map
    (name: {
      name = "_flake_templates/${name}";
      value = {
        source = "${flakeTemplateDir}/${name}";
      };
    })
    (builtins.attrNames (builtins.readDir flakeTemplateDir))
  );

  justfileTemplateDir = ./files/_justfile_templates;
  justfileTemplates = builtins.listToAttrs (map
    (name: {
      name = "_justfile_templates/${name}";
      value = {
        source = "${justfileTemplateDir}/${name}";
      };
    })
    (builtins.attrNames (builtins.readDir justfileTemplateDir))
  );

  globalJustfile = {
    "justfile".source = ./justfile;
  };

  allTemplates = flakeTemplates // nixshellTemplates // justfileTemplates;
in
{
  home.file = allTemplates // globalJustfile;
}
