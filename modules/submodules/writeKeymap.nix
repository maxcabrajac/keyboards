{ lib, layout, entryAt, config, ... }: let
	p = config.parts;
in {
	submodules = { config, ... }: {
		files."keymap.c".keymap = let
			asArray = layout.toNestedArray config.keymap;
			layoutFor = layer:
				asArray
				|> map (lib.filter (x: ! isNull x))
				|> map (map (lib.getAttr layer))
				|> map (lib.concatStringsSep ", ")
				|> lib.concatStringsSep ",\n"
				|> (x: "LAYOUT(\n${x}\n)")
			;
		in
			config.layers
			|> map (layer: "[${p.layerVar layer}] = ${layoutFor layer},")
			|> lib.concatLines
			|> (x: "const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {\n${x}\n};")
			|> entryAt "keymap"
		;
	};
}
