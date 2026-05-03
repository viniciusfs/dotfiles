#
# ~/.config/qtile/config.py
#
# Void Space — qtile configuration
# Depends: python3-psutil, rofi, picom, nm-applet, blueman-applet, dunst

import subprocess
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule
from libqtile.lazy import lazy

# ── Modifier ──────────────────────────────────────────────────────────────────
MOD = "mod4"  # Super / Windows key

# ── Applications ──────────────────────────────────────────────────────────────
TERMINAL = "kitty"
BROWSER = 'google-chrome --new-window --profile-directory="Profile 3"'
BROWSER_PERSONAL = 'google-chrome --new-window --profile-directory="Profile 2"'
LAUNCHER = "rofi -show combi -combi-modes 'drun,run' -show-icons"

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
    "purple": "#9b88d0",
    "cyan": "#4ab5c4",
    "orange": "#ba8873",
    "white": "#ffffff",
}

# ── Fonts ─────────────────────────────────────────────────────────────────────
FONT = "Ubuntu Mono Nerd Font Mono"
FONT_SIZE = 12
ICON_SIZE = 14


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
    Key([MOD, "shift"], "b", lazy.spawn(BROWSER_PERSONAL), desc="Browser"),
    Key([MOD], "r", lazy.spawn(LAUNCHER), desc="App launcher"),
    Key([MOD], "a", lazy.spawn("rofi -show window"), desc="Window switcher"),
    Key([MOD], "p", lazy.spawn("scrot")),
    Key([MOD, "shift"], "p", lazy.spawn("scrot -s")),
    # Notifications (dunst)
    Key(
        [MOD],
        "grave",
        lazy.spawn("dunstctl history-pop"),
        desc="Show last notification",
    ),
    Key(
        [MOD, "shift"],
        "grave",
        lazy.spawn("dunstctl close-all"),
        desc="Dismiss all notifications",
    ),
    # Volume (PipeWire / pactl)
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioMute",
        lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
        desc="Mute toggle",
    ),
    Key(
        [],
        "XF86AudioMicMute",
        lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle"),
        desc="Mic mute toggle",
    ),
    # Qtile control
    Key([MOD, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([MOD, "control"], "q", lazy.shutdown(), desc="Quit qtile"),
]


# ── Workspaces ────────────────────────────────────────────────────────────────
groups = [
    Group(
        "1",
        label="1",
        layout="max",
        matches=[
            Match(wm_class="Slack"),
            Match(wm_class="FortiClient"),
            Match(wm_class="Fortitray"),
        ],
    ),
    Group("2", label="2", layout="monadtall"),
    Group("3", label="3", layout="max"),
    Group("4", label="4", layout="monadtall"),
]

_screen_map = {"1": 0, "2": 1, "3": 0, "4": 1}

for g in groups:
    _s = _screen_map[g.name]
    keys += [
        Key(
            [MOD],
            g.name,
            lazy.group[g.name].toscreen(screen=_s),
            desc=f"Switch to group {g.name}",
        ),
        Key(
            [MOD, "shift"],
            g.name,
            lazy.window.togroup(g.name, switch_group=False),
            desc=f"Move window to group {g.name}",
        ),
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
    border_normal=C["bg"],
    border_width=2,
    margin=5,
)

layouts = [
    layout.MonadTall(
        **_layout,
        ratio=0.55,
        single_border_width=0,
        single_margin=0,
    ),
    layout.Max(**_layout),
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
        Match(wm_class="forticlient"),  # FortiClient VPN
        Match(wm_class="FortiClient"),  # FortiClient VPN
        Match(wm_class="fortitray"),  # FortiClient confirmation popup
        Match(wm_class="Fortitray"),  # FortiClient confirmation popup
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
            font=FONT + " Bold",
            fontsize=FONT_SIZE,
            active=C["fg"],
            inactive=C["dim"],
            highlight_method="block",
            block_highlight_text_color=C["white"],
            this_current_screen_border=C["blue"],
            this_screen_border=C["bg_sel"],
            other_current_screen_border=C["purple"],
            other_screen_border=C["bg_alt"],
            urgent_border=C["red"],
            rounded=True,
            padding_x=10,
            padding_y=4,
            borderwidth=3,
            disable_drag=True,
            use_mouse_wheel=False,
        ),
        _sep(),
        widget.CurrentLayout(foreground=C["fg"], padding=8),
        widget.WindowName(foreground=C["fg"], max_chars=70, padding=8),
    ]

    right = []

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
        _icon("󰕾", C["cyan"]),
        widget.Volume(
            foreground=C["cyan"],
            mute_foreground=C["dim"],
            volume_up_command="pactl set-sink-volume @DEFAULT_SINK@ +5%",
            volume_down_command="pactl set-sink-volume @DEFAULT_SINK@ -5%",
            mute_command="pactl set-sink-mute @DEFAULT_SINK@ toggle",
            get_volume_command="pactl get-sink-volume @DEFAULT_SINK@",
            check_mute_command="pactl get-sink-mute @DEFAULT_SINK@",
            check_mute_string="yes",
        ),
        _sep(),
        widget.Clock(format="%a %d/%m  %H:%M", foreground=C["fg"]),
    ]

    if primary:
        right += [
            _sep(),
            widget.Systray(padding=6, icon_size=16),
        ]

    right += [
        _sep(),
        widget.TextBox(
            text="⏻",
            font=FONT,
            fontsize=ICON_SIZE,
            foreground=C["red"],
            padding=6,
            mouse_callbacks={"Button1": lazy.shutdown()},
        ),
    ]

    right.append(widget.Spacer(length=8))

    return bar.Bar(
        left + [widget.Spacer()] + right,
        30,
        background=C["bg"],
        margin=[4, 6, 0, 6],
        border_width=[0, 0, 0, 0],
    )


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

# ── Screens ───────────────────────────────────────────────────────────────────
_WALLPAPER = "~/ownCloud/Pictures/wallpapers/nebulosa.jpg"

screens = [
    Screen(top=make_bar(primary=True), wallpaper=_WALLPAPER, wallpaper_mode="fill"),
    Screen(top=make_bar(primary=False), wallpaper=_WALLPAPER, wallpaper_mode="fill"),
]


# ── Display configuration ──────────────────────────────────────────────────────
def _configure_displays():
    xrandr = subprocess.run(["xrandr"], capture_output=True, text=True).stdout
    if "DP-1 connected" in xrandr:
        subprocess.run(
            [
                "xrandr",
                "--output",
                "DP-1",
                "--auto",
                "--left-of",
                "eDP-1",
                "--output",
                "eDP-1",
                "--auto",
            ]
        )
    else:
        subprocess.run(["xrandr", "--output", "eDP-1", "--auto"])


@hook.subscribe.screen_change
def on_screen_change(_event):
    _configure_displays()


# ── Autostart ─────────────────────────────────────────────────────────────────
@hook.subscribe.startup_once
def autostart():
    _configure_displays()
    subprocess.run(["setxkbmap", "-layout", "us", "-variant", "intl"])
    procs = [
        ["nm-applet"],  # ícone de rede na systray
        ["blueman-applet"],  # ícone de bluetooth
        ["pasystray"],  # ícone de volume na systray
        ["picom", "--daemon"],
        ["/opt/forticlient/fortitray"],  # FortiClient systray (popup de certificado)
        ["dunst"],
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
wmname = "LG3D"  # necessário para compatibilidade com apps Java
