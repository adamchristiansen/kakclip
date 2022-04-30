declare-option -hidden bool kakclip_enabled false

declare-option -docstring 'yank to clipboard command' str kakclip_cmd_yank

declare-option -docstring 'paste from clipboard command' str kakclip_cmd_paste

define-command -docstring "enable clipboard" kakclip-enable %{
    set-option global kakclip_enabled true

    # Detect the yank and paste commands if they are not explicitly set
    evaluate-commands %sh{
        exists() {
            command -v "$1" > /dev/null 2>&1
        }
        if [ -z "$kak_opt_kakclip_cmd_yank" ]; then
            cmd_yank="echo > /dev/null 2>&1"
            if exists pbcopy; then
                cmd_yank=pbcopy
            elif [ -n "$WAYLAND_DISPLAY" ] && exists wl-copy; then
                cmd_yank="wl-copy --foreground"
            elif [ -n "$DISPLAY" ] && exists xclip; then
                cmd_yank="xclip -in -selection clipboard"
            elif [ -n "$DISPLAY" ] && exists xsel; then
                cmd_yank="xsel --input --clipboard"
            else
                echo "echo -debug 'kakclip: unable to detect kakclip_cmd_yank'"
            fi
            echo "set-option global kakclip_cmd_yank '$cmd_yank'"
        fi
        if [ -z "$kak_opt_kakclip_cmd_paste" ]; then
            cmd_paste="echo > /dev/null 2>&1"
            if exists pbpaste; then
                cmd_paste=pbpaste
            elif [ -n "$WAYLAND_DISPLAY" ] && exists wl-paste; then
                cmd_paste="wl-paste --no-newline"
            elif [ -n "$DISPLAY" ] && exists xclip; then
                cmd_paste="xclip -out -selection clipboard"
            elif [ -n "$DISPLAY" ] && exists xsel; then
                cmd_paste="xsel --output --clipboard"
            else
                echo "echo -debug 'kakclip: unable to detect kakclip_cmd_paste'"
            fi
            echo "set-option global kakclip_cmd_paste '$cmd_paste'"
        fi
    }
}

define-command -docstring "disable clipboard" kakclip-disable %{
    set-option global kakclip_enabled false
}

define-command -docstring "toggle clipboard" kakclip-toggle %{
    evaluate-commands %sh{
        if [ "$kak_opt_kakclip_enabled" = true ]; then
            echo "kakclip-disable"
        else
            echo "kakclip-enable"
        fi
    }
}

define-command -docstring "paste from clipboard (after)" \
        kakclip-paste-after %{
    evaluate-commands %sh{
        if [ "$kak_opt_kakclip_enabled" = true ]; then
            echo "execute-keys -draft '<a-!>$kak_opt_kakclip_cmd_paste<ret>'"
        fi
    }
}

define-command -docstring "paste from clipboard (before)" \
        kakclip-paste-before %{
    evaluate-commands %sh{
        if [ "$kak_opt_kakclip_enabled" = true ]; then
            echo "execute-keys -draft '!$kak_opt_kakclip_cmd_paste<ret>'"
        fi
    }
}

define-command -docstring "replace from clipboard" \
        kakclip-replace %{
    evaluate-commands %sh{
        if [ "$kak_opt_kakclip_enabled" = true ]; then
            # The echo to /dev/null is so that nothing is piped into stdin of
            # the paste command
            printf "%s '|%s; %s<ret>'\n" \
                "execute-keys -draft" \
                "echo > /dev/null 2>&1" \
                "$kak_opt_kakclip_cmd_paste"
        fi
    }
}

define-command -docstring "yank entire buffer to clipboard" \
        kakclip-yank-buffer %{
    execute-keys -draft '%:kakclip-yank-selection<ret>'
}

define-command -docstring "yank primary selection to clipboard" \
        kakclip-yank-selection %{
    nop %sh{
        if [ "$kak_opt_kakclip_enabled" = true ]; then
            printf "%s" "$kak_main_reg_dot" \
                | $kak_opt_kakclip_cmd_yank > /dev/null 2>&1 &
        fi
    }
}
