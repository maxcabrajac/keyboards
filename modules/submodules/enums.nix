{ lib, entryAt, ... }: let
	t = lib.types;
in {
	submodules = { config, ... }: {
		options.enums = lib.mkOption {
			type = t.attrsOf <| t.listOf <| t.coercedTo t.str (name: { inherit name; }) <| t.submodule {
				options = {
					name = lib.mkOption {
						type = t.str;
					};
					value = lib.mkOption {
						type = t.nullOr t.str;
						default = null;
					};
				};
			};
		};

		config.files."keymap.c".enums = config.enums
			|> lib.mapAttrsToList (name: values:
				values
				|> map ({ name, value }: if isNull value then name else "${name} = ${value}")
				|> lib.concatStringsSep ", "
				|> (x: ''enum ${name} { ${x} };'')
			)
			|> lib.concatLines
			|> entryAt "definitions"
		;
	};
}
