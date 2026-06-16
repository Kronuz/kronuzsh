# Key bindings (emacs, matching prezto's default editor keymap).

bindkey -e

# Sane terminal keys (home/end/delete/word nav).
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# German's bindings.
bindkey '^U'      backward-kill-line   # Ctrl-U kills to start of line, not whole line.
bindkey '^[^[[D'  backward-word        # Alt+Left
bindkey '^[^[[C'  forward-word         # Alt+Right

# Edit the current command line in $EDITOR with Ctrl-X Ctrl-E.
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
