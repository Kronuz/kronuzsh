#!/usr/bin/env bash
#
# kronuzsh installer. Symlinks the runcoms into $HOME, backs up anything it
# replaces, and inits the plugin submodules. Idempotent: safe
# to re-run.
#
#   ./install.sh              install / refresh
#   ./install.sh --uninstall  remove our symlinks and restore the backups
#
set -euo pipefail

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
runcoms=(zshenv zprofile zshrc zlogin zlogout)
stamp="$(date +%Y%m%d%H%M%S)"

# shellcheck source=install.lib.sh
source "$here/install.lib.sh"

install() {
  kz_title "KronuZSH"

  kz_head "Plugins" "🧩"
  if git -C "$here" submodule update --init --recursive --quiet; then
    kz_ok "plugin submodules" "initialized / up to date"
  else
    kz_info "submodule update skipped (no git, or offline)"
  fi

  kz_head "Shell config" "🔗"
  local rc target link
  for rc in "${runcoms[@]}"; do
    target="$here/runcoms/$rc"
    link="$HOME/.$rc"
    if [[ -L "$link" && "$(readlink "$link")" == "$target" ]]; then
      kz_skip "~/.$rc" "already linked"
      continue
    fi
    if [[ -e "$link" || -L "$link" ]]; then
      mv "$link" "$link.kronuzsh-bak.$stamp"
      kz_info "backed up ~/.$rc -> ~/.$rc.kronuzsh-bak.$stamp"
    fi
    ln -s "$target" "$link"
    kz_ok "~/.$rc" "linked"
  done

  # External-tool integrations' install-time setup (theme caches, opt-in wiring). Lives
  # in integrations/setup.sh (prints its own "Tool integrations" heading), guarded +
  # idempotent. shellcheck source=integrations/setup.sh
  source "$here/integrations/setup.sh"

  kz_done "Done. Start a fresh shell:  exec zsh"
  kz_info "Personal tweaks (optional):  cp $here/zshrc.local.example ~/.zshrc.local"
}

uninstall() {
  kz_title "KronuZSH — uninstall"
  local rc link bak orig
  for rc in "${runcoms[@]}"; do
    link="$HOME/.$rc"
    if [[ -L "$link" && "$(readlink "$link")" == "$here/runcoms/$rc" ]]; then
      rm -f "$link"
      kz_ok "removed ~/.$rc"
    fi
  done
  for bak in "$HOME"/.z*.kronuzsh-bak.*; do
    [[ -e "$bak" ]] || continue
    orig="${bak%.kronuzsh-bak.*}"
    mv -f "$bak" "$orig"
    kz_ok "restored $orig"
  done
  kz_done "Uninstalled. Open a new shell."
}

case "${1:-}" in
  --uninstall|-u) uninstall ;;
  -h|--help) sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//' ;;
  *) install ;;
esac
