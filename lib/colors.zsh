# Canonical Kronuz colours for SYSTEM tools (ls, grep, man/less) and anything read by
# more than one tool. Per-tool integration colours (bat's theme, fzf's --color, the
# autosuggestions/history-search styles) stay with their integration; this file is only
# for shared, system-level knobs. Sourced before lib/completion (which feeds $LS_COLORS
# into the completion menu) and tool-independent, so colours don't vanish when a given
# tool isn't installed. Every value is guarded (${VAR:-...}) so your own export wins.
# All hues are the Kronuz palette (see kronuz-theme-vscode build.mjs).
#
# Cross-platform: works on Linux, macOS, and BSD. Each tool reads the var it understands
# and ignores the rest, so setting all of them unconditionally is safe everywhere — GNU
# ls uses $LS_COLORS while BSD/macOS ls uses $LSCOLORS/$CLICOLOR; GNU grep uses
# $GREP_COLORS (BSD grep ignores it); less/man use $LESS_TERMCAP on every platform.

# --- $LS_COLORS: GNU ls, fd, eza, and the zsh completion menu ------------------------
# IMPORTANT: eza reads $LS_COLORS and it OVERRIDES eza's theme.yml filekinds for the
# *filename* colour (precedence: $EZA_COLORS > $LS_COLORS > theme.yml > built-in). So
# these filekind colours are kept in lock-step with integrations/eza/theme.yml — change
# one, change the other, or eza and ls/fd/the menu disagree. Filekinds: di/ln blue,
# ex green, pipe/socket neutral, devices orange, orphan/missing red. Per-extension tints
# use hues NO filekind uses, so a file's type is never ambiguous (no green .md that looks
# executable): docs/prose pink, images gold, audio/video tan, archives red (regular vs the
# BOLD orphan red). eza honours these extension rules via $LS_COLORS too.
export LS_COLORS="${LS_COLORS:-fi=38;2;200;198;197:di=38;2;110;156;190:ln=38;2;126;164;204:ex=38;2;165;194;97:pi=38;2;122;119;117:so=38;2;122;119;117:bd=38;2;204;120;51:cd=38;2;204;120;51:or=01;38;2;218;73;57:mi=01;38;2;218;73;57:*.md=38;2;214;135;191:*.markdown=38;2;214;135;191:*.rst=38;2;214;135;191:*.txt=38;2;214;135;191:*.org=38;2;214;135;191:*.tex=38;2;214;135;191:*.pdf=38;2;214;135;191:*.epub=38;2;214;135;191:*.tar=38;2;218;73;57:*.tgz=38;2;218;73;57:*.gz=38;2;218;73;57:*.bz2=38;2;218;73;57:*.xz=38;2;218;73;57:*.zip=38;2;218;73;57:*.7z=38;2;218;73;57:*.rar=38;2;218;73;57:*.zst=38;2;218;73;57:*.jpg=38;2;232;191;106:*.jpeg=38;2;232;191;106:*.png=38;2;232;191;106:*.gif=38;2;232;191;106:*.svg=38;2;232;191;106:*.webp=38;2;232;191;106:*.bmp=38;2;232;191;106:*.ico=38;2;232;191;106:*.mp3=38;2;202;164;115:*.flac=38;2;202;164;115:*.wav=38;2;202;164;115:*.ogg=38;2;202;164;115:*.mp4=38;2;202;164;115:*.mkv=38;2;202;164;115:*.mov=38;2;202;164;115:*.avi=38;2;202;164;115:*.webm=38;2;202;164;115}"

# --- BSD / macOS native `ls` (used when eza is absent) -------------------------------
# BSD ls only speaks the 16 ANSI colours (no truecolor), so this is a coarse Kronuz-ish
# approximation of $LS_COLORS above: dir blue, symlink bright-blue, pipe/socket grey,
# exec green, devices brown. CLICOLOR turns colour on; LSCOLORS is 11 fg/bg letter pairs.
export CLICOLOR="${CLICOLOR:-1}"
export LSCOLORS="${LSCOLORS:-exExhxhxcxdxdxabagacad}"

# --- grep match highlighting (GNU grep; BSD grep ignores GREP_COLORS, harmless) ------
# match = heading orange (bold), filename = link blue, line/byte = comment, sep = dim.
export GREP_COLORS="${GREP_COLORS:-ms=01;38;2;253;151;31:mc=01;38;2;253;151;31:sl=:cx=:fn=38;2;96;137;180:ln=38;2;149;129;94:bn=38;2;149;129;94:se=38;2;122;119;117}"

# --- man / less pager colours --------------------------------------------------------
# `man` pipes through less; LESS_TERMCAP recolours its bold/underline/standout. Bold =
# keyword orange (headings, names), underline = string green (args), standout = heading
# orange on a dark bar (search/status). Needs less -R (set in runcoms/zshenv $LESS).
# Forces colour, so honour NO_COLOR (no-color.org). GROFF_NO_SGR makes Linux groff emit
# legacy overstrike so LESS_TERMCAP wins (harmless on macOS/BSD mandoc, which ignores it).
if [[ -z ${NO_COLOR:-} ]]; then
  export GROFF_NO_SGR=${GROFF_NO_SGR:-1}
  export LESS_TERMCAP_md=${LESS_TERMCAP_md:-$'\e[1;38;2;204;120;51m'}   # bold      -> keyword orange
  export LESS_TERMCAP_me=${LESS_TERMCAP_me:-$'\e[0m'}                    # reset bold
  export LESS_TERMCAP_us=${LESS_TERMCAP_us:-$'\e[4;38;2;165;194;97m'}   # underline -> string green
  export LESS_TERMCAP_ue=${LESS_TERMCAP_ue:-$'\e[0m'}                    # reset underline
  export LESS_TERMCAP_so=${LESS_TERMCAP_so:-$'\e[1;38;2;253;151;31;48;2;69;69;69m'}  # standout -> heading on dark
  export LESS_TERMCAP_se=${LESS_TERMCAP_se:-$'\e[0m'}                    # reset standout
  export LESS_TERMCAP_mb=${LESS_TERMCAP_mb:-$'\e[1;38;2;218;73;57m'}    # blink     -> type red
fi
