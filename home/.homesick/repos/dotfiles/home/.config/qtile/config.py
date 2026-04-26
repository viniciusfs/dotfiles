# ~/.config/qtile/config.py
#
# Void Space — qtile configuration
# Depends: python3-psutil, rofi, picom, nm-applet, blueman-applet

import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

# ── Modifier ──────────────────────────────────────────────────────────────────
MOD = "mod4"  # Super / Windows key

# ── Applications ──────────────────────────────────────────────────────────────
TERMINAL = "kitty"
BROWSER = "firefox"
LAUNCHER = "rofi -show drun -show-icons"

# ── Void Space palette ────────────────────────────────────────────────────────
C = {
    "bg": "#1a1f28",
    "bg_alt": "#232936",
    "bg_sel": "#323c4d",
    "fg": "#99a7be",
    "dim": "#5f7090",
    "red": "#c68b8f",
    "green": "#8fb98c",
    "yellow": "#b39b64",
    "blue": "#618bc2",
    "magenta": "#9b88d0",
    "cyan": "#4ab5c4",
    "orange": "#ba8873",
}

# ── Fonts ─────────────────────────────────────────────────────────────────────
FONT = "Ubuntu Mono Nerd Font Mono"
FONT_SIZE = 13
ICON_SIZE = 15


# ── Keybindings ───────────────────────────────────────────────────────────────
keys = [
    # Focus (vim-style)
    Key([MOD], "h", lazy.layout.left(), desc="Focus left"),
    Key([MOD], "l", lazy.layout.right(), desc="Focus right"),
    Key([MOD], "j", lazy.layout.down(), desc="Focus down"),
    Key([MOD], "k", lazy.layout.up(), desc="Focus up"),
    Key([MOD], "Tab", lazy.layout.next(), desc="Cycle focus forward"),
    Key([MOD, "shift"], "Tab", lazy.layout.previous(), desc="Cycle focus backward"),
    # Move windows
    Key([MOD, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([MOD, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window right"),
    Key([MOD, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([MOD, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Resize — main pane (MonadTall)
    Key([MOD], "i", lazy.layout.grow_main(), desc="Grow main pane"),
    Key([MOD], "d", lazy.layout.shrink_main(), desc="Shrink main pane"),
    Key([MOD], "n", lazy.layout.normalize(), desc="Reset window sizes"),
    # Fullscreen / floating
    Key([MOD], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([MOD, "shift"], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    # Layouts
    Key([MOD], "space", lazy.next_layout(), desc="Next layout"),
    Key([MOD, "shift"], "space", lazy.prev_layout(), desc="Prev layout"),
    # Close window
    Key([MOD], "w", lazy.window.kill(), desc="Kill focused window"),
    # Move focus between screens
    Key([MOD], "comma", lazy.prev_screen(), desc="Focus previous screen"),
    Key([MOD], "period", lazy.next_screen(), desc="Focus next screen"),
    # Move window to other screen
    Key(
        [MOD, "shift"], "comma", lazy.window.toscreen(0), desc="Move window to screen 0"
    ),
    Key(
        [MOD, "shift"],
        "period",
        lazy.window.toscreen(1),
        desc="Move window to screen 1",
    ),
    # Launch apps
    Key([MOD], "Return", lazy.spawn(TERMINAL), desc="Terminal"),
    Key([MOD], "b", lazy.spawn(BROWSER), desc="Browser"),
    Key([MOD], "r", lazy.spawn(LAUNCHER), desc="App launcher"),
    # Qtile control
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Quit qtile"),
]


# ── Workspaces ────────────────────────────────────────────────────────────────
#
# Grupos 1–5: contexto de trabalho   (tela de trabalho)
# Grupos 6–9: contexto de lazer      (tela suporte)
#
groups = [
    # Trabalho
    Group("1", label="  DEV", layout="monadtall"),  # terminal + editor
    Group("2", label="  WEB", layout="monadtall"),  # browser + terminal
    Group("3", label="  CHAT", layout="max"),  # slack, discord, email
    Group("4", label="  DOCS", layout="monadtall"),  # documentação
    Group("5", label="  OPS", layout="monadtall"),  # devops, ssh, logs
    # Lazer
    Group("6", label="  MEDIA", layout="max"),  # youtube, spotify, etc.
    Group("7", label="  SOCIAL", layout="max"),  # redes sociais
    Group("8", label="  MISC", layout="columns"),  # miscelânea
]

for g in groups:
    keys += [
        Key(
            [MOD],
            g.name,
            lazy.group[g.name].toscreen(),
            desc=f"Switch to group {g.name}",
        ),
        Key(
            [MOD, "shift"],
            g.name,
            lazy.window.togroup(g.name, switch_group=False),
            desc=f"Move window to group {g.name}",
        ),
        # Shift+Ctrl move AND follow
        Key(
            [MOD, "control"],
            g.name,
            lazy.window.togroup(g.name, switch_group=True),
            desc=f"Move window and switch to group {g.name}",
        ),
    ]


# ── Layouts ───────────────────────────────────────────────────────────────────
_layout = dict(
    border_focus=C["blue"],
    border_normal=C["bg_sel"],
    border_width=2,
    margin=6,
)

layouts = [
    # Principal: janela grande à esquerda + stack à direita
    layout.MonadTall(
        **_layout,
        ratio=0.55,
        single_border_width=0,
        single_margin=0,
    ),
    # Full screen — para browser / apps de comunicação
    layout.Max(**_layout),
    # Colunas — alternativa mais flexível
    layout.Columns(
        **_layout,
        border_on_single=False,
        num_columns=2,
    ),
]

floating_layout = layout.Floating(
    border_focus=C["blue"],
    border_normal=C["bg_sel"],
    border_width=2,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="Nm-connection-editor"),
        Match(wm_class="pavucontrol"),
        Match(wm_class="blueman-manager"),
        Match(wm_class="1Password"),
        Match(wm_class="gnome-calculator"),
    ],
)


# ── Widget defaults ───────────────────────────────────────────────────────────
widget_defaults = dict(
    font=FONT,
    fontsize=FONT_SIZE,
    padding=4,
    background=C["bg"],
    foreground=C["fg"],
)
extension_defaults = widget_defaults.copy()


# ── Bar helpers ───────────────────────────────────────────────────────────────
def _sep():
    return widget.Sep(linewidth=1, padding=10, foreground=C["bg_sel"])


def _icon(text, color):
    return widget.TextBox(
        text=text,
        font=FONT,
        fontsize=ICON_SIZE,
        foreground=color,
        padding=6,
    )


def make_bar(primary=False):
    """Build the top bar. primary=True adds systray and battery widget."""

    left = [
        widget.Spacer(length=6),
        widget.GroupBox(
            font=FONT,
            fontsize=FONT_SIZE,
            active=C["fg"],
            inactive=C["dim"],
            highlight_method="block",
            block_highlight_text_color=C["fg"],
            this_current_screen_border=C["blue"],
            this_screen_border=C["bg_sel"],
            other_current_screen_border=C["magenta"],
            other_screen_border=C["bg_alt"],
            urgent_border=C["red"],
            rounded=False,
            padding_x=10,
            padding_y=4,
            borderwidth=3,
            disable_drag=True,
            use_mouse_wheel=False,
        ),
        _sep(),
        widget.CurrentLayoutIcon(scale=0.6),
        widget.WindowName(foreground=C["fg"], max_chars=70, padding=8),
    ]

    right = [
        _sep(),
        _icon("", C["cyan"]),
        widget.CPU(
            format="{load_percent:4.1f}%",
            foreground=C["cyan"],
            update_interval=3,
        ),
        _sep(),
        _icon("󰍛", C["green"]),
        widget.Memory(
            format="{MemUsed:.1f}{mm}",
            measure_mem="G",
            foreground=C["green"],
            update_interval=3,
        ),
        _sep(),
    ]

    if primary:
        right += [
            widget.Battery(
                format="{char} {percent:2.0%}",
                charge_char="󰂄",
                discharge_char="󰁹",
                full_char="󰁹",
                unknown_char="󰂑",
                empty_char="󰂎",
                low_foreground=C["red"],
                foreground=C["yellow"],
                low_percentage=0.2,
                update_interval=30,
                notify_below=20,
            ),
            _sep(),
        ]

    right += [
        _icon("", C["blue"]),
        widget.Clock(format="%a %d/%m  %H:%M", foreground=C["fg"]),
    ]

    if primary:
        right += [
            _sep(),
            widget.Systray(padding=6, icon_size=16),
        ]

    right.append(widget.Spacer(length=8))

    return bar.Bar(
        left + [widget.Spacer()] + right,
        30,
        background=C["bg"],
        margin=[4, 6, 0, 6],
        border_width=[0, 0, 0, 0],
    )


# ── Screens ───────────────────────────────────────────────────────────────────
#
# screens[0] → monitor principal (laptop ou tela de trabalho)
# screens[1] → segundo monitor (tela suporte)
#
# Ajuste a ordem conforme seu setup físico.
#
screens = [
    Screen(top=make_bar(primary=True)),
    Screen(top=make_bar(primary=False)),
]


# ── Mouse ─────────────────────────────────────────────────────────────────────
mouse = [
    # Mod + botão esquerdo: mover janela floating
    Drag(
        [MOD],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    # Mod + botão direito: redimensionar janela floating
    Drag(
        [MOD],
        "Button3",
        lazy.window.set_resize_floating(),
        start=lazy.window.get_size(),
    ),
    # Mod + clique do meio: trazer para frente
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]


# ── Autostart ─────────────────────────────────────────────────────────────────
@hook.subscribe.startup_once
def autostart():
    procs = [
        ["nm-applet"],  # ícone de rede na systray
        ["blueman-applet"],  # ícone de bluetooth
        ["picom", "--daemon"],  # compositor (sombras, transparência)
        # ["dunst"],                      # notificações (descomente se usar)
        # ["flameshot"],                  # screenshots (descomente se usar)
    ]
    for p in procs:
        try:
            subprocess.Popen(p)
        except FileNotFoundError:
            pass  # ignora se o programa não estiver instalado


# ── Global settings ───────────────────────────────────────────────────────────
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = False
reconfigure_screens = True
auto_fullscreen = True
focus_on_window_activation = "smart"
wmname = "LG3D"  # necessário para compatibilidade com apps Java (ex: IntelliJ)
