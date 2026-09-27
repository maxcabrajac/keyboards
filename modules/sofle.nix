{ config, ... }: {
	keyboards.sofle.keymap = config.parts.modtap_row "qwerty" 2 [ "S" "C" "A" "M" ] <| config.parts.qwerty "qwerty";
}
