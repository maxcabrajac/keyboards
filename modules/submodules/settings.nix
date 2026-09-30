{ lib, dag, ... }: {
	submodules = { config, ... }: {
		options.settings = lib.mkOption {
			type = lib.types.attrsOf lib.types.str;
			default = {};
		};

		config.files."config.h" = {
			pragma = "# pragma once";
			settings = dag.entryAfter [ "pragma" ] (config.settings
				|> lib.mapAttrsToList (name: value: "#define ${name} ${value}")
				|> lib.concatLines
			);
		};
	};
}
