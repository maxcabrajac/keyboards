{ lib, config, ... }: let
	t = lib.types;
in {
	options.keyboards' = lib.mkOption {
		type = t.lazyAttrsOf <| t.submodule {
			config.submodule = config.submodules;
		};
	};
}
