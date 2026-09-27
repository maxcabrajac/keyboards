{ lib, dag, config, ... }: let
	t = lib.types;
in {
	submodules = {
		options = {
			files = lib.mkOption {
				type = t.attrsOf <| dag.of t.str;
				default = {};
				apply = lib.mapAttrs (_: entries: dag.render { inherit entries; });
			};
		};
	};
}
