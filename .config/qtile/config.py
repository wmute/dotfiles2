#     _                      _ _ _        ___  _   _ _
### IMPORTS ###
import os
import re
import socket
import subprocess
import logging
from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List  # noqa: F401

### VARIABLES ###
mod = "mod1"  # Sets mod key to ALT
term = "kitty"  # My terminal of choice
myConfig = "/home/wintermute/.config/qtile/config.py"  # The Qtile config file location

### MISC FUNCTIONS ###
# Brings all floating windows to the front
@lazy.function
def float_to_front(qtile):
    logging.info("bring floating windows to front")
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()


### KEYBINDS ###
keys = [
    # General Keybinds
    Key([mod], "Return", lazy.spawn(term)),
    Key([mod], "d", lazy.spawn("rofi -show drun")),
    Key([mod], "q", lazy.spawn("nautilus")),
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "shift"], "r", lazy.restart()),
    Key([mod, "shift"], "e", lazy.shutdown()),
    # Window Controls
    Key([mod], "k", lazy.layout.down(), desc="Move focus down in current stack pane"),
    Key([mod], "j", lazy.layout.up(), desc="Move focus up in current stack pane"),
    Key([mod], "h", lazy.layout.left(),),
    Key([mod], "l", lazy.layout.right(),),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_down(),
        desc="Move windows down in current stack",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_up(),
        desc="Move windows up in current stack",
    ),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(),),
    Key([mod], "f", lazy.window.toggle_fullscreen(),),
    Key([mod, "shift"], "Tab", lazy.layout.flip(),),
    Key([mod], "r", float_to_front),
    # Screenshot Tool
    Key([], "Print", lazy.spawn("flameshot gui"),),
    Key(["shift"], "Print", lazy.spawn("flameshot screen"),),
    Key([mod, "shift"], "Print", lazy.spawn("flameshot full")),
    # Turn off screen(s)
    Key([mod], "o", lazy.spawn("xset dpms force off")),
    # Media controls
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +10%"),
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -10%"),
    ),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"),),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"),),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"),),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"),),
]


### GROUPS ###
group_names = [
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
    (" ", {"layout": "monadtall"}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.append(
        Key([mod], str(i), lazy.group[name].toscreen())
    )  # Switch to another group
    keys.append(
        Key([mod, "shift"], str(i), lazy.window.togroup(name))
    )  # Send current window to another group

### DEFAULT THEME SETTINGS FOR LAYOUTS ###
layout_theme = {
    "border_width": 3,
    "margin": 10,
    "single_margin": 0,
    "single_border_width": 0,
    "border_focus": "#5e81ac",
    "border_normal": "#3b4252",
}

### LAYOUTS ###
layouts = [layout.MonadTall(**layout_theme), layout.Floating(**layout_theme)]

# Tomorrow Night Theme
colors = [
    ["#1d1f21", "#1d1f21"],
    ["#373b41", "#373b41"],
    ["#c5c8c6", "#c5c8c6"],
    ["#de935f", "#de935f"],
]

### PROMPT ###
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

### DEFAULT WIDGET SETTINGS ###
widget_defaults = dict(
    font="Ubuntu Medium", fontsize=16, padding=2, background=colors[0]
)
extension_defaults = widget_defaults.copy()

### WIDGETS ###


def make_arrow(fg, bg):
    "helper function to generate arrow textbox with different colors"
    return widget.TextBox(
        text="", background=bg, foreground=fg, padding=0, fontsize=37,
    )


def init_widgets_list():
    widgets_list = [
        widget.Sep(linewidth=0, padding=6, foreground=colors[2], background=colors[0]),
        widget.GroupBox(
            font="Ubuntu Medium",
            fontsize=16,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=5,
            borderwidth=3,
            active=colors[3],
            inactive=colors[2],
            rounded=True,
            highlight_color=colors[3],
            highlight_method="text",
            this_current_screen_border=colors[3],
            this_screen_border=colors[0],
            other_current_screen_border=colors[0],
            other_screen_border=colors[0],
            foreground=colors[2],
            background=colors[0],
        ),
        widget.Sep(linewidth=0, padding=40,),
        widget.WindowName(foreground=colors[3], background=colors[0], padding=0),
        make_arrow(colors[1], colors[0]),
        widget.CPU(
            format="CPU {freq_current}GHz {load_percent}%",
            update_interval=1.0,
            foreground=colors[2],
            background=colors[1],
            padding=5,
        ),
        make_arrow(colors[0], colors[1]),
        widget.TextBox(
            text=" 🌡",
            padding=2,
            foreground=colors[2],
            background=colors[0],
            fontsize=11,
        ),
        widget.ThermalSensor(foreground=colors[2], background=colors[0], padding=5,),
        make_arrow(colors[1], colors[0]),
        widget.TextBox(
            text="", foreground=colors[2], background=colors[1], padding=0, fontsize=14
        ),
        widget.Memory(foreground=colors[2], background=colors[1], padding=5),
        make_arrow(colors[0], colors[1]),
        widget.TextBox(text="", foreground=colors[2], background=colors[0], padding=0),
        widget.Volume(foreground=colors[2], background=colors[0], padding=5),
        make_arrow(colors[1], colors[0]),
        widget.CurrentLayout(foreground=colors[2], background=colors[1], padding=5),
        make_arrow(colors[0], colors[1]),
        widget.Clock(
            foreground=colors[2], background=colors[0], format="%A, %B %d  [ %I:%M %p ]"
        ),
        widget.Systray(background=colors[0], icon_size=20, padding=10),
    ]
    return widgets_list


### SCREENS ### (TRIPLE MONITOR SETUP)


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2  # Monitor 2 will display all widgets in widgets_list


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=0.95, size=20))]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen2 = init_widgets_screen2()

### DRAG FLOATING WINDOWS ###
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False

### FLOATING WINDOWS ###
floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "nautilus"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "confirmreset"},  # gitk
        {"wmclass": "makebranch"},  # gitk
        {"wmclass": "maketag"},  # gitk
        {"wname": "branchdialog"},  # gitk
        {"wname": "pinentry"},  # GPG key password entry
        {"wmclass": "ssh-askpass"},  # ssh-askpass
        {"wmclass": "Lxappearance"},
        {"wmclass": "Pavucontrol"},
        {"wmclass": "VirtualBox Manager"},
        {"wmclass": "feh"},
        {"wmclass": "Timeshift-gtk"},
    ]
)

# Steam specific floating settings
@hook.subscribe.client_new
def float_steam(window):
    wm_class = window.window.get_wm_class()
    w_name = window.window.get_name()
    if wm_class == ("Steam", "Steam") and (
        w_name != "Steam"
        # w_name == "Friends List"
        # or w_name == "Screenshot Uploader"
        # or w_name.startswith("Steam - News")
        or "PMaxSize" in window.window.get_wm_normal_hints().get("flags", ())
    ):
        window.floating = True


auto_fullscreen = True
focus_on_window_activation = "smart"

### STARTUP APPLICATIONS ###
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])


# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
