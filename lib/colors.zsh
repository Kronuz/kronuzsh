# Canonical Kronuz file colours. One $LS_COLORS, shared by everything that paints
# filenames: GNU/BSD `ls`, `fd`, `eza` (it reads $LS_COLORS / $EZA_COLORS), and the
# zsh completion menu (lib/completion.zsh feeds this into its list-colors). Sourced
# before lib/completion so the menu captures it, and tool-independent so the colours
# don't vanish when a given tool isn't installed.
#
# dir blue, link green, exec orange, archives red, images gold, media tan. Guarded with
# ${LS_COLORS:-...} so your own exported $LS_COLORS (or a dircolors db) wins; override
# per-extension for eza via $EZA_COLORS in ~/.zshrc.local.
export LS_COLORS="${LS_COLORS:-di=38;2;110;156;190:ln=38;2;165;194;97:so=38;2;202;164;115:pi=38;2;202;164;115:ex=01;38;2;204;120;51:bd=38;2;232;191;106:cd=38;2;232;191;106:or=01;38;2;218;73;57:mi=01;38;2;218;73;57:*.tar=38;2;218;73;57:*.tgz=38;2;218;73;57:*.gz=38;2;218;73;57:*.bz2=38;2;218;73;57:*.xz=38;2;218;73;57:*.zip=38;2;218;73;57:*.7z=38;2;218;73;57:*.jpg=38;2;232;191;106:*.jpeg=38;2;232;191;106:*.png=38;2;232;191;106:*.gif=38;2;232;191;106:*.svg=38;2;232;191;106:*.mp3=38;2;202;164;115:*.flac=38;2;202;164;115:*.mp4=38;2;202;164;115:*.mkv=38;2;202;164;115:*.pdf=38;2;218;73;57:*.md=38;2;165;194;97}"
