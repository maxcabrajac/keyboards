{ lib, ... }: let
	t = lib.types;
in {
	options.keyboards' = lib.mkOption {
		type = t.lazyAttrsOf <| t.submodule ({ config, ... }: {
			options.evaluated = lib.mkOption {
				type = t.attrsOf t.anything;
				readOnly = true;
			};

			config.evaluated = lib.evalModules {
				modules = [config.submodule];
			} |> (x: x.config);
		});
	};
}
