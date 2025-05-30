{
  description = "MelonLoader Mod Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
              "dotnet-sdk-6.0.428"
              "dotnet-runtime-6.0.36"
            ];
          };
        };

        dotnet-sdk = pkgs.dotnetCorePackages.sdk_6_0;
        dotnet-runtime = pkgs.dotnet-runtime_6;
      in {
        devShells.default = pkgs.mkShell {
          name = "melonloader-dev-shell";

          nativeBuildInputs = with pkgs; [
            dotnet-sdk
            git
            nuget
            omnisharp-roslyn
            vscode
          ];

          DOTNET_NOLOGO = "1";
          DOTNET_CLI_TELEMETRY_OPTOUT = "1";
          NUGET_PACKAGES = "${toString ./.}/.nuget/packages";


          shellHook = ''
            export NUGET_PACKAGES="$PWD/.nuget/packages"
            mkdir -p "$NUGET_PACKAGES"
            echo "💡 NuGet packages will be stored in: $NUGET_PACKAGES"
            echo "🧃 MelonLoader modding shell ready."
          '';
        };
      }
    );
}
