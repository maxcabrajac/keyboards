{ lib, layout, ... }: let
	t = lib.types;
in {
	options.keyboards' = lib.mkOption {
		type = t.lazyAttrsOf <| t.submodule ({ config, ... }: {
			config.submodule = {
				options.layouterOutput = lib.mkOption {
					type = t.raw;
				};
				config.layouterOutput = config.layouterOutput
					|> lib.mapAttrs (_: layout.map ({ key, ... }: key |> lib.mapNullable (k: removeAttrs k [ "_m" ])))
				;
			};
		});
	};
}
