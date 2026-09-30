{ lib, ... }: {
	submodules = { config, ... }: {
		options.rules = lib.mkOption {
			type = lib.types.attrsOf lib.types.bool;
		};
		config.files."rules.mk".all = config.rules
			|> lib.mapAttrs (_: v: if v then "yes" else "no")
			|> lib.mapAttrsToList (name: value: "${name} = ${value}")
			|> lib.concatLines
		;
	};
}
