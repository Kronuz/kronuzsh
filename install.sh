#!/usr/bin/env bash
#
# kronuzsh installer. Symlinks the runcoms into $HOME, backs up anything it
# replaces, inits the plugin submodules, and seeds local.zsh. Idempotent: safe
# to re-run.
#
#   ./install.sh              install / refresh
#   ./install.sh --uninstall  remove our symlinks and restore the backups
#
set -euo pipefail

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
runcoms=(zshenv zprofile zshrc zlogin zlogout)
stamp="$(date +%Y%m%d%H%M%S)"

install() {
  git -C "$here" submodule update --init --recursive --quiet || true

  if [[ ! -e "$here/local.zsh" && -e "$here/local.zsh.example" ]]; then
    cp "$here/local.zsh.example" "$here/local.zsh"
    echo "seeded local.zsh from the example"
  fi

  local rc target link
  for rc in "${runcoms[@]}"; do
    target="$here/runcoms/$rc"
    link="$HOME/.$rc"
    if [[ -L "$link" && "$(readlink "$link")" == "$target" ]]; then
      continue  # already ours
    fi
    if [[ -e "$link" || -L "$link" ]]; then
      mv "$link" "$link.kronuzsh-bak.$stamp"
      echo "backed up $link -> .${rc}.kronuzsh-bak.$stamp"
    fi
    ln -s "$target" "$link"
    echo "linked  ~/.$rc -> $target"
  done

  echo
  echo "done. start a fresh shell:  exec zsh"
}

uninstall() {
  local rc link bak orig
  for rc in "${runcoms[@]}"; do
    link="$HOME/.$rc"
    if [[ -L "$link" && "$(readlink "$link")" == "$here/runcoms/$rc" ]]; then
      rm -f "$link"
      echo "removed ~/.$rc"
    fi
  done
  for bak in "$HOME"/.z*.kronuzsh-bak.*; do
    [[ -e "$bak" ]] || continue
    orig="${bak%.kronuzsh-bak.*}"
    mv -f "$bak" "$orig"
    echo "restored $orig"
  done
  echo "uninstalled. open a new shell."
}

case "${1:-}" in
  --uninstall|-u) uninstall ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//' ;;
  *) install ;;
esac
