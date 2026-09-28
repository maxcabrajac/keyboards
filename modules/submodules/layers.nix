{ lib, config, entryAt, dag, ... }: let
	fConfig = config;
in {
	submodules = { config, ... }: {
		options.layers = lib.mkOption {
			type = dag.of lib.types.bool;
			apply = d: d
				|> dag.topoSort
				|> (x: lib.throwIfNot (x ? "result") "Failed to sort layers: ${toString x}" x.result)
				|> lib.filter (x: x.data)
				|> map (x: x.name)
				|> lib.filter (x: lib.elem x config.usedLayers)
			;
		};

		config = {
			layers = lib.mkMerge [
				(lib.genAttrs config.usedLayers (_: true))
				{
					defaultLayers = false;
				}
			];

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
