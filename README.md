# DOTFILES

[![Smoke Test](https://github.com/tallamjr/dotfiles/actions/workflows/smoke.yml/badge.svg)](https://github.com/tallamjr/dotfiles/actions/workflows/smoke.yml)

![Automation](http://imgs.xkcd.com/comics/automation.png)

## Installation

See my blog for an overview of my _dotfile_ story.

### Clean System Install

To provision a new machine, clone this repo and simply run:

```bash
bash install.sh
```

This will run a [*bootstrap*](https://github.com/tallamjr/dotfiles/blob/master/install.sh)
script to determine the operating system that is running, and then either install [Homebrew](https://brew.sh/)
or [Linuxbrew](http://linuxbrew.sh/).

After the respective package manager is installed and dotfiles in place, it will continue to install
all brew packages (_this will take a while_) found in `brew/.brewlist`:

Finally, when all is complete, an updated version of `vim` and `neovim` is installed, along with
`vim-plug` for plugin management. It _may_ be necessary to restart the \$SHELL and install VIM
plugins with:

```bash
source $HOME/.bashrc && vim +PluginInstall +qall
```

**NOTE**

It may be necessary to add the bash shell to `/etc/shells`, this can be done with:

```bash
$ echo /usr/local/bin/bash | sudo tee -a /etc/shells
```

Then one will need to "change shells" with:

```bash
$ chsh -s $(which bash)
```

If the above steps are not done, a common giveaway is `history` will not "work"

Refs: https://stackoverflow.com/a/49049781/4521950

### Temporary Configuration Install [WIP]

If only temporarily installing on another machine, run:

```bash
bash temp/temp-install.sh
```

This is certainly a much simpler task than provisioning a new machine. This
script clones this repo and symlinks the relevant configuration files.

Uninstalling, however, was definitely not as simple as hoped. Nonetheless, when
finished, one can run `./uninstall.sh` from the dotfile directory itself to
remove all settings.

🚧 **WARNING!** 🚧

Install and uninstall scripts have been tested but please use
with caution. Inspect files first!

*NOTE* : This repo is a work in progress and subject
to change. In it's current form, it has drawn inspiration from these sources:

https://github.com/skwp/dotfiles

https://github.com/ruslanosipov/dotfiles

..amongst many others..

## Screenshot

![screenshot](screenshot.png)
