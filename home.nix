{
  home.username = "nixbookpro";
  home.homeDirectory = "/home/nixbookpro";
  home.stateVersion = "25.05";

  home.file.".zshrc".text = ''
	export EDITOR=nano;
	export PATH=$HOME/bin:$PATH;

	bindkey -v;

	eval "$(starship init zsh)";

	y() {
		local tmp
		tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
		yazi "$@" --cwd-file="$tmp"
		local cwd
		cwd="$(<"$tmp")"
		[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && cd -- "$cwd"
		rm -f -- "$tmp"
	}	
  '';

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Backgrounds/powerlines.png
    wallpaper = eDP-1, ~/Backgrounds/powerlines.png
  '';

  home.file.".config/hypr/hypridle.conf".text = ''
	general {
	  lock_cmd = hyprlock
	  before_sleep_cmd = hyprlock
	  after_resume_cmd = notify-send "Welcome back!"
	}

	# Lock after 5 minutes (300 seconds)
	listener {
	  timeout = 300
	  on-timeout = hyprlock
	  on-resume = notify-send "Welcome back!"
	}

	# Suspend 5 minutes after lock (600 seconds total)
	listener {
	  timeout = 600
	  on-timeout = systemctl suspend
	  on-resume = notify-send "Welcome back!"
	}
  '';

  home.file.".config/hypr/hyprland.conf".text = ''
	################
	### MONITORS ###
	################

	monitor=,preferred,auto,auto

	###################
	### MY PROGRAMS ###
	###################

	$terminal = ghostty
	$fileManager = thunar
	$menu = rofi -show drun


	#################
	### AUTOSTART ###
	#################

	exec-once = waybar & hyprpaper
	exec-once = dunst
	exec-once = nm-applet &
	exec-once = hypridle &
	exec-once = cliphist daemon
	exec-once = systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
	exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
	exec-once = systemctl --user start xdg-desktop-portal xdg-desktop-portal-wayland
	exec-once = xwaylandvideobridge

	#############################
	### ENVIRONMENT VARIABLES ###
	#############################

	env = XCURSOR_SIZE,24
	env = HYPRCURSOR_SIZE,24


	###################
	### PERMISSIONS ###
	###################

	# See https://wiki.hyprland.org/Configuring/Permissions/
	# Please note permission changes here require a Hyprland restart and are not applied on-the-fly
	# for security reasons

	# ecosystem {
	#   enforce_permissions = 1
	# }

	# permission = /usr/(bin|local/bin)/grim, screencopy, allow
	# permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
	# permission = /usr/(bin|local/bin)/hyprpm, plugin, allow


	#####################
	### LOOK AND FEEL ###
	#####################

	general {
	    gaps_in = 5
	    gaps_out = 7

	    border_size = 2

	    # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
	    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
	    col.inactive_border = rgba(595959aa)

	    # Set to true enable resizing windows by clicking and dragging on borders and gaps
	    resize_on_border = false

	    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
	    allow_tearing = false

	    layout = dwindle
	}

	# https://wiki.hyprland.org/Configuring/Variables/#decoration
	decoration {
	    rounding = 10
	    rounding_power = 2

	    # Change transparency of focused and unfocused windows
	    active_opacity = 1.0
	    inactive_opacity = 0.9

	    shadow {
	        enabled = true
	        range = 4
	        render_power = 3
	        color = rgba(1a1a1aee)
	    }

	    # https://wiki.hyprland.org/Configuring/Variables/#blur
	    blur {
	        enabled = true
	        size = 3
	        passes = 1

	        vibrancy = 0.1696
	    }
	}

	# https://wiki.hyprland.org/Configuring/Variables/#animations
	animations {
	    enabled = yes, please :)

	    # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

	    bezier = easeOutQuint,0.23,1,0.32,1
	    bezier = easeInOutCubic,0.65,0.05,0.36,1
	    bezier = linear,0,0,1,1
	    bezier = almostLinear,0.5,0.5,0.75,1.0
	    bezier = quick,0.15,0,0.1,1

	    animation = global, 1, 10, default
	    animation = border, 1, 5.39, easeOutQuint
	    animation = windows, 1, 4.79, easeOutQuint
	    animation = windowsIn, 1, 4.1, easeOutQuint, popin 87%
	    animation = windowsOut, 1, 1.49, linear, popin 87%
	    animation = fadeIn, 1, 1.73, almostLinear
	    animation = fadeOut, 1, 1.46, almostLinear
	    animation = fade, 1, 3.03, quick
	    animation = layers, 1, 3.81, easeOutQuint
	    animation = layersIn, 1, 4, easeOutQuint, fade
	    animation = layersOut, 1, 1.5, linear, fade
	    animation = fadeLayersIn, 1, 1.79, almostLinear
	    animation = fadeLayersOut, 1, 1.39, almostLinear
	    animation = workspaces, 1, 1.94, almostLinear, fade
	    animation = workspacesIn, 1, 1.21, almostLinear, fade
	    animation = workspacesOut, 1, 1.94, almostLinear, fade
	}

	# Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
	# "Smart gaps" / "No gaps when only"
	# uncomment all if you wish to use that.
	# workspace = w[tv1], gapsout:0, gapsin:0
	# workspace = f[1], gapsout:0, gapsin:0
	# windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
	# windowrule = rounding 0, floating:0, onworkspace:w[tv1]
	# windowrule = bordersize 0, floating:0, onworkspace:f[1]
	# windowrule = rounding 0, floating:0, onworkspace:f[1]

	# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	dwindle {
	    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
	    preserve_split = true # You probably want this
	}

	# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	master {
	    new_status = master
	}

	# https://wiki.hyprland.org/Configuring/Variables/#misc
	misc {
	    force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
	    disable_hyprland_logo = false # If true disables the random hyprland logo / anime girl background. :(
	}


	#############
	### INPUT ###
	#############

	# https://wiki.hyprland.org/Configuring/Variables/#input
	input {
	    kb_layout = us
	    kb_variant =
	    kb_model =
	    kb_options =
	    kb_rules =

	    follow_mouse = 0

	    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

	    touchpad {
	        natural_scroll = true
	    }
	}

	# https://wiki.hyprland.org/Configuring/Variables/#gestures
	gestures {
	    workspace_swipe = yes
	}

	# Example per-device config
	# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
	device {
	    name = epic-mouse-v1
	    sensitivity = -0.5
	}


	###################
	### KEYBINDINGS ###
	###################

	# See https://wiki.hyprland.org/Configuring/Keywords/
	$mainMod = SUPER # Sets "Windows" key as main modifier

	# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	bind = $mainMod, RETURN, exec, $terminal
	bind = $mainMod, C, killactive,
	bind = $mainMod, M, exit,
	bind = $mainMod, E, exec, $fileManager
	bind = $mainMod, V, togglefloating,
	bind = $mainMod, SPACE, exec, $menu
	bind = $mainMod, P, exec, hyprpicker
	bind = $mainMod, J, togglesplit, # dwindle
	bind = $mainMod SHIFT, S, exec, hyprshot -m region
	bind = $mainMod, L, exec, hyprlock

	# Move focus with mainMod + arrow keys
	bind = $mainMod, left, movefocus, l
	bind = $mainMod, right, movefocus, r
	bind = $mainMod, up, movefocus, u
	bind = $mainMod, down, movefocus, d

	# Move current window with mainMod + SHIFT + arrow keys
	bind = $mainMod SHIFT, left, movewindow, l
	bind = $mainMod SHIFT, right, movewindow, r
	bind = $mainMod SHIFT, up, movewindow, u
	bind = $mainMod SHIFT, down, movewindow, d

	# Switch workspaces with mainMod + [0-9]
	bind = $mainMod, 1, workspace, 1
	bind = $mainMod, 2, workspace, 2
	bind = $mainMod, 3, workspace, 3
	bind = $mainMod, 4, workspace, 4
	bind = $mainMod, 5, workspace, 5
	bind = $mainMod, 6, workspace, 6
	bind = $mainMod, 7, workspace, 7
	bind = $mainMod, 8, workspace, 8
	bind = $mainMod, 9, workspace, 9
	bind = $mainMod, 0, workspace, 10

	# Move active window to a workspace with mainMod + SHIFT + [0-9]
	bind = $mainMod SHIFT, 1, movetoworkspace, 1
	bind = $mainMod SHIFT, 2, movetoworkspace, 2
	bind = $mainMod SHIFT, 3, movetoworkspace, 3
	bind = $mainMod SHIFT, 4, movetoworkspace, 4
	bind = $mainMod SHIFT, 5, movetoworkspace, 5
	bind = $mainMod SHIFT, 6, movetoworkspace, 6
	bind = $mainMod SHIFT, 7, movetoworkspace, 7
	bind = $mainMod SHIFT, 8, movetoworkspace, 8
	bind = $mainMod SHIFT, 9, movetoworkspace, 9
	bind = $mainMod SHIFT, 0, movetoworkspace, 10

	# Scroll through existing workspaces with mainMod + scroll
	bind = $mainMod, mouse_down, workspace, e+1
	bind = $mainMod, mouse_up, workspace, e-1

	# Move/resize windows with mainMod + LMB/RMB and dragging
	bindm = $mainMod, mouse:272, movewindow
	bindm = $mainMod, mouse:273, resizewindow

	# Laptop multimedia keys for volume and LCD brightness
	bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
	bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
	bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
	bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
	bindel = ,XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+
	bindel = ,XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-

	# Requires playerctl
	bindl = , XF86AudioNext, exec, playerctl next
	bindl = , XF86AudioPause, exec, playerctl play-pause
	bindl = , XF86AudioPlay, exec, playerctl play-pause
	bindl = , XF86AudioPrev, exec, playerctl previous

	##############################
	### WINDOWS AND WORKSPACES ###
	##############################

	# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
	# See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

	# Example windowrule
	# windowrule = float,class:^(kitty)$,title:^(kitty)$

	# Ignore maximize requests from apps. You'll probably like this.
	windowrule = suppressevent maximize, class:.*

	# Fix some dragging issues with XWayland
	windowrule = nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0

	# Screen share fix
	windowrule = opacity 0.0 override, class:^(xwaylandvideobridge)$
	windowrule = noanim, class:^(xwaylandvideobridge)$
	windowrule = noinitialfocus, class:^(xwaylandvideobridge)$
	windowrule = maxsize 1 1, class:^(xwaylandvideobridge)$
	windowrule = noblur, class:^(xwaylandvideobridge)$
	windowrule = nofocus, class:^(xwaylandvideobridge)$
  '';


  home.file.".config/ghostty/config".text = ''
	term = xterm-256color
	theme = tokyonight_moon

	font-family = "FiraMono Nerd Font"
	font-thicken = true
	font-size = 10

	mouse-hide-while-typing = true

	window-decoration = true
	window-save-state = default

	background = 000000
	background-opacity = 0.7
	background-blur-radius = 30
  '';

  home.file.".config/yazi/yazi.toml".text = ''
	[mgr]
	show_hidden = true
  '';

  home.file.".config/starship.toml".text = ''
	"$schema" = 'https://starship.rs/config-schema.json'

	format = """
	[](surface0)\
	$os\
	$username\
	[](bg:peach fg:surface0)\
	$directory\
	[](fg:peach bg:green)\
	$git_branch\
	$git_status\
	[](fg:green bg:teal)\
	$c\
	$rust\
	$golang\
	$nodejs\
	$php\
	$java\
	$kotlin\
	$haskell\
	$python\
	[](fg:teal bg:blue)\
	$docker_context\
	[](fg:blue bg:purple)\
	$time\
	[ ](fg:purple)\
	$line_break$character"""

	palette = 'catppuccin_mocha'

	[palettes.gruvbox_dark]
	color_fg0 = '#fbf1c7'
	color_bg1 = '#3c3836'
	color_bg3 = '#665c54'
	color_blue = '#458588'
	color_aqua = '#689d6a'
	color_green = '#98971a'
	color_orange = '#d65d0e'
	color_purple = '#b16286'
	color_red = '#cc241d'
	color_yellow = '#d79921'

	[palettes.catppuccin_mocha]
	rosewater = "#f5e0dc"
	flamingo = "#f2cdcd"
	pink = "#f5c2e7"
	orange = "#cba6f7"
	red = "#f38ba8"
	maroon = "#eba0ac"
	peach = "#fab387"
	yellow = "#f9e2af"
	green = "#a6e3a1"
	teal = "#94e2d5"
	sky = "#89dceb"
	sapphire = "#74c7ec"
	blue = "#89b4fa"
	lavender = "#b4befe"
	text = "#cdd6f4"
	subtext1 = "#bac2de"
	subtext0 = "#a6adc8"
	overlay2 = "#9399b2"
	overlay1 = "#7f849c"
	overlay0 = "#6c7086"
	surface2 = "#585b70"
	surface1 = "#45475a"
	surface0 = "#313244"
	base = "#1e1e2e"
	mantle = "#181825"
	crust = "#11111b"

	[os]
	disabled = false
	style = "bg:surface0 fg:text"

	[os.symbols]
	Windows = "󰍲"
	Ubuntu = "󰕈"
	SUSE = ""
	Raspbian = "󰐿"
	Mint = "󰣭"
	Macos = ""
	Manjaro = ""
	Linux = "󰌽"
	Gentoo = "󰣨"
	Fedora = "󰣛"
	Alpine = ""
	Amazon = ""
	Android = ""
	Arch = "󰣇"
	Artix = "󰣇"
	CentOS = ""
	Debian = "󰣚"
	Redhat = "󱄛"
	RedHatEnterprise = "󱄛"

	[username]
	show_always = true
	style_user = "bg:surface0 fg:text"
	style_root = "bg:surface0 fg:text"
	format = '[ $user ]($style)'

	[directory]
	style = "fg:mantle bg:peach"
	format = "[ $path ]($style)"
	truncation_length = 3
	truncation_symbol = "…/"

	[directory.substitutions]
	"Documents" = "󰈙 "
	"Downloads" = " "
	"Music" = "󰝚 "
	"Pictures" = " "
	"Developer" = "󰲋 "

	[git_branch]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol $branch ](fg:base bg:green)]($style)'

	[git_status]
	style = "bg:teal"
	format = '[[($all_status$ahead_behind )](fg:base bg:green)]($style)'

	[nodejs]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[c]
	symbol = " "
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[rust]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[golang]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[php]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[java]
	symbol = " "
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[kotlin]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[haskell]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[python]
	symbol = ""
	style = "bg:teal"
	format = '[[ $symbol( $version) ](fg:base bg:teal)]($style)'

	[docker_context]
	symbol = ""
	style = "bg:mantle"
	format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

	[time]
	disabled = false
	time_format = "%R"
	style = "bg:peach"
	format = '[[  $time ](fg:mantle bg:purple)]($style)'

	[line_break]
	disabled = false

	[character]
	disabled = false
	success_symbol = '[](bold fg:green)'
	error_symbol = '[](bold fg:red)'
	vimcmd_symbol = '[](bold fg:creen)'
	vimcmd_replace_one_symbol = '[](bold fg:purple)'
	vimcmd_replace_symbol = '[](bold fg:purple)'
	vimcmd_visual_symbol = '[](bold fg:lavender)'
  '';
}
