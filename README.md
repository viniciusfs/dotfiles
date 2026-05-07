# dotfiles

Personal dotfiles managed with [homeshick](https://github.com/andsens/homeshick) on Ubuntu.
Built around a tiling workflow, vim-style navigation everywhere, and a consistent dark palette called **Void Space**.

## What's inside

**Desktop**
- [Qtile](https://qtile.org) — tiling window manager, Void Space theme, vim-key focus/resize
- [Picom](https://github.com/yshui/picom) — compositor
- [Rofi](https://github.com/davatorium/rofi) — launcher
- [Dunst](https://dunst-project.org) — notifications

**Terminal & shell**
- [Kitty](https://sw.kovidgoyal.net/kitty/) — primary terminal
- [Alacritty](https://alacritty.org) — secondary terminal
- [Tmux](https://github.com/tmux/tmux) — multiplexer with TPM and seamless vim-tmux navigation
- Bash — custom prompt, aliases, and functions

**Editor**
- [Neovim](https://neovim.io) — [LazyVim](https://lazyvim.org) distribution, fzf/telescope, LSP, Treesitter

**Dev tooling**
- [mise](https://mise.jdx.dev) — runtime manager for Go, Python, Terraform, kubectl, Helm, kind, AWS CLI, lazygit, fzf, jq, and more

**Theme & fonts**
- Void Space — custom dark palette (`#1a1f28` base)
- [Ubuntu Mono Nerd Font](https://www.nerdfonts.com) — terminals and status bars
- Courier Prime — document reading

## Install

```bash
homeshick clone git@github.com:viniciusfs/dotfiles.git
homeshick link
./install.sh
```

`install.sh` runs modular setup scripts for apt packages, fonts, Neovim, Rust, mise tools, Tmux plugins, and Qtile dependencies.

## Testing

Run the full install in a clean Ubuntu 24.04 Docker container:

```bash
./test/run.sh
```

First run downloads all tools (~2 GB). Subsequent runs reuse the cache and complete in 2–5 minutes.

To clear the mise tool cache:

```bash
docker volume rm dotfiles-mise-cache
```
