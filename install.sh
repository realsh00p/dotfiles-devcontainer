#!/bin/sh
set -e

cd "$HOME/.dotfiles"
git submodule sync --recursive
git submodule update --init --recursive

mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/tmux" "$HOME/.config"
ln -sf "$HOME/.dotfiles/vim" "$HOME/.config"
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config"
