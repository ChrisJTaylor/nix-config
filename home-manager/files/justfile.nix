{ ... }:

{
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    "justfile".text = ''
alias b := build-and-test
alias t := test
alias c := coverage
alias pre-test := clear-previous-results

test_results := "./test-results"
coverage_results := "./coverage-results"
artifacts := "./artifacts"
configuration := "Release"
project_test_result_name := "coverage.cobertura.xml"
test_filter := "FullyQualifiedName!~IntegrationTests&FullyQualifiedName!~StagingTests&FullyQualifiedName!~ContractTests"
solution_file := "*.sln"

[no-cd]
clean: 
  dotnet clean
  dotnet nuget locals all --clear

[no-cd]
restore:
  dotnet restore
  dotnet tool restore

[no-cd]
build:
  dotnet build --no-restore -c "{{configuration}}"

[no-cd]
clear-previous-results:
  find . -type f -name "{{project_test_result_name}}" -exec sh -c 'rm -r "$(dirname "{}")"' \;  

[no-cd]
test: clear-previous-results
  -dotnet test --filter "{{test_filter}}" --configuration "{{configuration}}" --collect "XPlat Code Coverage" --results-directory "{{test_results}}" 

[no-cd]
test-no-build: clear-previous-results
  -dotnet test --no-build --filter "{{test_filter}}" --configuration "{{configuration}}" --collect "XPlat Code Coverage" --results-directory "{{test_results}}" 

[no-cd]
coverage: 
  #!/usr/bin/env bash
  dotnet reportgenerator -reports:**/{{test_results}}/*/coverage.cobertura.xml -reporttypes:lcov -targetdir:{{test_results}} 

[no-cd]
package:
  dotnet pack --no-build --configuration "{{configuration}}" -o "{{artifacts}}"

[no-cd]
watch:
  dotnet watch --project {{solution_file}}

[no-cd]
sloc:
  @echo "`wc -l **/*.cs` lines of code"

[no-cd]
build-and-test: clean restore build test 
  just coverage
  @echo "Done."
    '';
  };

}
