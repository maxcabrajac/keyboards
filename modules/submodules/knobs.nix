{ lib, layout, entryAt, config, ... }: let
	p = config.parts;
	t = lib.types;
in {
	submodules = { config, ... }: {
		options.knobs = lib.mkOption {
			type = t.uniq <| t.listOf <| layout.Of <| t.attrsOf <| t.str;
			default = config.layouterOutput.knobs or [];
		};

		config = lib.mkIf (lib.length config.knobs != 0) {
			# TODO: Add this so it fails during eval instead of at compile time
			# assertions = [
			# 	{
			# 		assertion = config.knobs |> lib.all (k: k.height == 1 && k.width == 2);
			# 		message = "All knobs must be a layout with size { height = 1; width = 2; }";
			# 	}
			# ];

			rules.ENCODER_MAP_ENABLE = true;
			files."keymap.c".knobs = let
				knobsFor = layer:
					config.knobs
					|> map (k:
						k.values
						|> map (x: x.${layer})
						|> lib.concatStringsSep ","
						|> (x: "ENCODER_CCW_CW(${x})")
					)
					|> lib.concatStringsSep ","
					|> (x: "{${x}}")
				;
			in
				config.layers
				|> map (layer: "[${p.layerVar layer}] = ${knobsFor layer},")
				|> lib.concatLines
				|> (x: "const uint16_t PROGMEM encoder_map[][NUM_ENCODERS][NUM_DIRECTIONS] = {\n${x}\n};")
				|> entryAt "keymap"
			;
		};
	};
}
