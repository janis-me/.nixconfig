# My personal nix config

I used this to easily setup and maintain my linux (ubuntu) systems. Per-system changes must be made if

- the primary graphics cards is not an NVIDIA one, or when wanting to use offload gpu config with PRIME
- The system is not `x86_64-linux` (see flake.nix)

## setup

First, clone this folder to `~/.nixconfig`.
Make sure to install nix as a multi-user installation, then, you should be able to run `nix run home-manager/master switch -- --impure --flake ~/.nixconfig/.#default`.

This will

- Fetch the home-manager module
- execute the switch command to activate the environment
  - using the `impure` flag to allow nvidia GPU drivers with NixGL and
  - pointing to the flake you previously pulled from git

Note: You might need to add flex for experimental features `nix-command` and `flakes` to both the nix run command, and the `switch` one, so both flags two times.

So, the whole command would be something like

```bash
nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes switch -- --impure --flake ~/.nixconfig/.#default --extra-experimental-features nix-command --extra-experimental-features flakes
```

When that worked, you can now use `home-manager` or the `switch` command directly

## Additional config

Now, to allow apps to run with Nvidia driver support, you may need to disable some AppArmor flags, as all GUI apps will be sandboxed.
Consider adding the folloing flag to a `/etc/sysctl.d` file, like `99-sysctl.conf`

```sh
kernel.apparmor_restrict_unprivileged_userns=0
```

Also, to set the default shell to zsh, set the output of `which zsh` (something in the `.nix-profile` folder) as a valid shell in /etc/shells, and then set it as default with `chsh -s $(which zsh)`

## Notes:

- Docker is not supported/installed. Install it the usual way!
