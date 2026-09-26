{ lib, layout, config, ... }: let
	t = lib.types;
	key = t.str;
in {
	options = {
		layouts = lib.mkOption {
			type = t.attrsOf <| t.anything;
		};
		keyboards = lib.mkOption {
			type = t.attrsOf <| t.submodule {
				options.keymap = lib.mkOption {
					type = layout.Of key;
				};
			};
		};
	};

	config.flake = { inherit (config) keyboards layouts; };
}
