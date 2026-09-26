{ layout, config, ... }: {
	keyboards.sofle.keymap = config.layouts.modtap_row 2 [ "S" "C" "A" "M" ] config.layouts.qwerty;
}
