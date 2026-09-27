{ lib, layout, config, ... }: let
	t = lib.types;
	key = t.submodule {
		freeformType = t.attrsOf t.str;
		options = {
			_m = lib.mkOption {
				type = t.deferredModuleWith {};
				default = {};
			};
		};
	};
in {
	options = {
		parts = lib.mkOption {
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

	config.flake = { inherit (config) keyboards parts; };
}
