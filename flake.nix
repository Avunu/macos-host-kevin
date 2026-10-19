{
  description = "Kevin's Mac: nix-dev-macos plus design and PKI apps";

  inputs = {
    nix-dev-macos.url = "github:Avunu/nix-dev-macos";
    # One nixpkgs for the whole system: the base flake's.
    nixpkgs.follows = "nix-dev-macos/nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-dev-macos,
      ...
    }:
    let
      host = nix-dev-macos.lib.mkHost {
        inherit self;
        # The Mac rebuilds straight from this repository; nothing local.
        upgradeFlake = "github:Avunu/macos-host-kevin#default";
        modules = [
          (
            { pkgs, ... }:
            {
              devHost = {
                extraPackages = with pkgs; [
                  inkscape
                  xca
                ];
                # GIMP has no nixpkgs build for macOS; the base flake installs
                # Homebrew declaratively (nix-homebrew) when a cask is listed.
                casks = [ "gimp" ];
              };
            }
          )
        ];
      };
    in
    {
      inherit (host) darwinConfigurations packages;

      formatter = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt
      );

      checks = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-darwin" ] (system: {
        # Full evaluation, no build. Needs --impure (user and architecture are
        # read from the environment).
        eval = nixpkgs.legacyPackages.${system}.runCommand "darwin-eval-check" { } ''
          echo "${builtins.unsafeDiscardStringContext self.darwinConfigurations.default.system.drvPath}" > "$out"
        '';
      });
    };
}
