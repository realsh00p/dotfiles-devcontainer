#!/bin/sh
set -e

sudo apt update && \
sudo apt install -y bubblewrap ca-certificates curl

nvm_version="0.40.6"
node_version="24.19.0"
npm_version="11.9.0"
codex_version="0.147.0"

export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR/.git" ]; then
    git -C "$NVM_DIR" fetch --depth 1 --force origin \
        "refs/tags/v${nvm_version}:refs/tags/v${nvm_version}"
    git -C "$NVM_DIR" checkout --detach "v${nvm_version}"
else
    git clone --depth 1 --branch "v${nvm_version}" --single-branch \
        https://github.com/nvm-sh/nvm.git "$NVM_DIR"
fi
# shellcheck source=/dev/null
. "$NVM_DIR/nvm.sh"

nvm install "$node_version"
nvm alias default "$node_version"
nvm use "$node_version"
npm install --global "npm@${npm_version}"
npm install --global "@openai/codex@${codex_version}"

cd "$HOME/.dotfiles"
git submodule sync --recursive
git submodule update --init --recursive

mkdir -p "$HOME/.dotfiles/bin" "$HOME/.local/bin"

gitlab_cli_version="1.22.0"
case "$(uname -m)" in
    x86_64|amd64)
        gitlab_cli_arch="x86_64"
        gitlab_cli_sha256="7d70af94648cd7720899315ddd9efdf981769f636b3cf6976508a939d5248a5f"
        ;;
    aarch64|arm64)
        gitlab_cli_arch="arm64"
        gitlab_cli_sha256="72b83d99c9fb99ed5ba04cc50f5acf90e1d4bedbc7c0d950eae7eb8375d0068b"
        ;;
    *)
        echo "Unsupported architecture for glab: $(uname -m)" >&2
        exit 1
        ;;
esac

gitlab_cli_archive="$(mktemp)"
trap 'rm -f "$gitlab_cli_archive"' EXIT HUP INT TERM
curl -fsSL \
    -o "$gitlab_cli_archive" \
    "https://github.com/profclems/glab/releases/download/v${gitlab_cli_version}/glab_${gitlab_cli_version}_Linux_${gitlab_cli_arch}.tar.gz"
echo "$gitlab_cli_sha256  $gitlab_cli_archive" | sha256sum -c -
tar -xzf "$gitlab_cli_archive" -C "$HOME/.dotfiles" bin/glab

for file in "$HOME/.dotfiles/bin"/*; do
    [ -f "$file" ] || continue
    ln -sf "$file" "$HOME/.local/bin/$(basename "$file")"
done

rm -f "$gitlab_cli_archive"
trap - EXIT HUP INT TERM

mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/tmux" "$HOME/.config"
ln -sf "$HOME/.dotfiles/vim" "$HOME/.config"
ln -sf "$HOME/.dotfiles/fish" "$HOME/.config"
