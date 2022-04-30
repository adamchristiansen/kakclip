# KakClip

This [Kakoune](https://kakoune.org/) plugin provides yanking and pasting from
the system clipboard. This plugin provides commands which implement the
yanking and pasting, but does not install any hooks/mapping/etc. You should
use these functions however you see fit (see [configuration](#configuration)).

The following clipboard backends are supported:

- `pbcopy`/`pbpaste` (macOS)
- `wl-copy`/`wl-paste` (Wayland)
- `xclip`
- `xsel`

By default, an appropriate program is automatically discovered.

An alternate solution is [kakboard](https://github.com/lePerdu/kakboard), which
syncs the system clipboard with Kakoune registers. Check it out if that sounds
like a better solution for you.

## Install

### With [plug.kak](https://github.com/andreyorst/plug.kak)

Add this to your `kakrc`:

```kak
plug "AdamChristiansen/kakclip" config %{
    kakclip-enable
}
```

### Without a Plugin Manager

Use one of the following options:

1. Clone this repository to your `autoload` directory
2. Source `kakclip.kak` from your `kakrc`

## Configuration

A useful configuration is to add user key bindings which behave the same as
`p`, `P`, `R`, and `y` do in normal mode, except they use the system clipboard
instead of a register.

```kak
map global user p -docstring 'paste from clipboard after' ':kakclip-paste-after<ret>'
map global user P -docstring 'paste from clipboard before' ':kakclip-paste-before<ret>'
map global user R -docstring 'replace from clipboard' ':kakclip-replace<ret>'
map global user y -docstring 'yank selection to clipboard' ':kakclip-yank-selection<ret>'
map global user Y -docstring 'yank entire buffer to clipboard' ':kakclip-yank-buffer<ret>'
```

The following options can be set:

- `kakclip_cmd_yank` is the command to execute to yank a selection to the
  clipboard. This overrides automatic command detection.
- `kakclip_cmd_paste` is the command to execute to paste from the clipboard.
  This overrides automatic command detection.

The following commands are provided:

- `kakclip-enable` enables integration with the system clipboard.
- `kakclip-disable` disables integration with the system clipboard.
- `kakclip-toggle` toggles integration with the system clipboard.
- `kakclip-paste-after` pastes the contents of the system clipboard after the
  current selection.
- `kakclip-paste-before` pastes the contents of the system clipboard before the
  current selection.
- `kakclip-replace` replaces the current selection with the contents of the
  system clipboard.
- `kakclip-yank-buffer` yanks the entire buffer into the system clipboard.
- `kakclip-yank-selection` yanks the primary selection into the system
  clipboard.

When `kakclip` is disabled, the `kakclip-paste-*`, `kakclip-replace`, and
`kakclip-yank-*` commands do not modify the buffer or the system clipboard.
