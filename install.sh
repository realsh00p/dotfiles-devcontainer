#!/bin/sh
set -e

sudo apt update > /dev/null 2>&1
sudo apt install -y fish > /dev/null 2>&1

cd "$HOME/.dotfiles"
git submodule sync --recursive
git submodule update --init --recursive

mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/tmux" "$HOME/.config"
ln -sf "$HOME/.dotfiles/vim" "$HOME/.config"
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config"
