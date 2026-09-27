{ layout, config, ... }: {
	keyboards.sofle.keymap = config.layouts.modtap_row "qwerty" 2 [ "S" "C" "A" "M" ] <| config.layouts.qwerty "qwerty";
}
