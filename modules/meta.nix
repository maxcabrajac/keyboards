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
			type = t.attrsOf <| t.submodule ({ config, ... }: {
				options = {
					parts = lib.mkOption {
						type = t.attrsOf <| t.attrsOf <| t.functionTo key;
					};

					layouter = lib.mkOption {
						type = t.functionTo <| layout.Of key;
					};

					keymap = lib.mkOption {
						type = layout.Of key;
					};
				};

				config.keymap = config.layouter config.parts;
			});
		};
	};

	config.flake = { inherit (config) keyboards parts; };
}
