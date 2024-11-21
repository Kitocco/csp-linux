# CSP Linux
This is a script to install Clip Studio Paint on Linux using the help of Valve's Proton (fork GE-Proton was used).

## Dependencies
- wget
- pv

Arch Linux users can install them with `pacman -S wget pv`

## Installation (It's that easy!)
```bash
git clone https://github.com/minsiam/csp-linux
cd csp-linux
chmod +x csp-installer.sh
./csp-installer.sh
```

Once it's installed, you can start CSP by running `csp-linux` in your terminal.

## Uninstallation
To uninstall CSP, simply remove `~/.local/share/csp-linux` & `~/.config/csprc`. Future plans include an uninstaller.

## Made with love ❤️ by minsiam