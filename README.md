# My personal nix config

I used this to easily setup and maintain my linux (ubuntu) systems. Per-system changes must be made if

- the primary graphics cards is not an NVIDIA one, or when wanting to use offload gpu config with PRIME
- The system is not `x86_64-linux` (see flake.nix)

## Usage

First, clone this folder to `~/.nixconfig`.
Make sure to install nix as a multi-user installation, then, you should be able to run `nix run home-manager/master switch --impure --flake ~/.nixconfig/.#default`.

This will

- Fetch the home-manager module
- execute the switch command to activate the environment
  - using the `impure` flag to allow nvidia GPU drivers with NixGL and
  - pointing to the flake you previously pulled from git

Note: You might need to add flex for experimental features `nix-command` and `flakes`

When that worked, you can now use `home-manager` or the `switch` command directly
