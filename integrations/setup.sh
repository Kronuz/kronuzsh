# integrations/setup.sh: install-time setup for the external-tool integrations.
#
# The runtime half is init.zsh (sourced by every interactive shell); this is the
# one-off, install-time half: it builds bat's theme cache and wires git-delta
# into the global gitconfig. install.sh sources it, but it's also safe to run on
# its own (`sh integrations/setup.sh`) to re-apply just the tool config without
# re-linking the runcoms. Both steps are guarded on the tool being present and
# are idempotent.
#
# Plain POSIX sh (not zsh) so install.sh (bash) can source it; it self-locates
# its own directory to find the bundled themes.

# Where this file lives, whether sourced from bash (install.sh) or run directly.
_kronuz_setup_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" && pwd -P)"

# bat / delta share one syntax theme: build bat's cache so the bundled Kronuz
# theme (integrations/bat/themes/Kronuz.tmTheme) registers. delta reads the same
# cache, so both pick it up. Debian ships bat as `batcat`; accept either.
_kronuz_bat=""
command -v bat    >/dev/null 2>&1 && _kronuz_bat=bat
[ -z "$_kronuz_bat" ] && command -v batcat >/dev/null 2>&1 && _kronuz_bat=batcat
if [ -n "$_kronuz_bat" ]; then
  if BAT_CONFIG_DIR="$_kronuz_setup_dir/bat" "$_kronuz_bat" cache --build >/dev/null 2>&1; then
    echo "built bat cache (Kronuz theme registered for bat + delta)"
  fi
fi

# git-delta: use it as git's diff pager and `git add -p` highlighter, guarded
# with `command -v delta` so a box without delta falls back to less/cat. Set in
# the global gitconfig (the env can't carry interactive.diffFilter), and
# idempotent: re-running just re-sets the same keys.
if command -v git >/dev/null 2>&1; then
  git config --global core.pager \
    'if command -v delta >/dev/null 2>&1; then delta; else less; fi'
  git config --global interactive.diffFilter \
    'if command -v delta >/dev/null 2>&1; then delta --color-only; else cat; fi'
  git config --global delta.navigate true
  git config --global delta.line-numbers true
  # Kronuz diff colors: warm-tinted add/remove backgrounds to match the theme.
  git config --global delta.plus-style        'syntax #26331a'
  git config --global delta.minus-style       'syntax #3a1d1d'
  git config --global delta.plus-emph-style    'syntax #34471f'
  git config --global delta.minus-emph-style   'syntax #57231f'
  # Kronuz syntax highlighting in diffs, but only if bat built that theme.
  [ -n "$_kronuz_bat" ] && git config --global delta.syntax-theme Kronuz
  echo "configured git to use delta when available (falls back to less)"
fi

unset _kronuz_bat _kronuz_setup_dir
