# macos-host-kevin

Kevin's Mac, as a downstream of [nix-dev-macos](https://github.com/Avunu/nix-dev-macos).
It inherits everything there (toolchain, nix settings, daily auto-upgrade) and adds
Inkscape and xca from nixpkgs, and GIMP as a Homebrew cask (nixpkgs has no macOS
build of GIMP; Homebrew is installed declaratively through nix-homebrew).

## Apply

```bash
sudo nix run nix-darwin/master#darwin-rebuild -- switch \
  --flake github:Avunu/macos-host-kevin#default --refresh --impure
```

If this Mac already runs nix-dev-macos, `sudo darwin-rebuild switch --flake github:Avunu/macos-host-kevin#default --refresh --impure` does the same.

## Updates

Dependabot moves `flake.lock` here (including the `nix-dev-macos` input, so base
changes arrive as a PR). The daily `system-upgrade` job rebuilds from this
repository when its revision differs from the running system's. Run
`system-upgrade` to pull sooner.

## Changing what's installed

Edit `devHost.extraPackages`, `brews` and `casks` in `flake.nix`; any other
nix-darwin option can go in the same module.
