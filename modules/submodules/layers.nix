{ lib, config, entryAt, ... }: let
	fConfig = config;
in {
	submodules = { config, ... }: {
		config = {
			files."keymap.c".layerEnum = config.layers
				|> map fConfig.parts.layerVar
				|> lib.concatStringsSep ", "
				|> (x: entryAt "definitions" ''enum layers { ${x} };'');
		};
	};

	parts = {
		layerVar = x: "LAYER_${x}";
		layerHold = x: "TO(${config.parts.layerVar x})";
	};
}
