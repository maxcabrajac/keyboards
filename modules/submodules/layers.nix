{ lib, config, dag, layout, ... }: let
	fConfig = config;
in {
	submodules = { config, ... }: let
		usedLayers = config.layouterOutput
			|> lib.attrValues
			|> map layout.toNestedArray
			|> lib.flatten
			|> lib.filter (x: !isNull x)
			|> map lib.attrNames
			|> lib.flatten
			|> lib.uniqueStrings
		;
	in {
		options = {
			layers = lib.mkOption {
				type = dag.of lib.types.bool;
				apply = d: d
					|> dag.topoSort
					|> (x: lib.throwIfNot (x ? "result") "Failed to sort layers: ${toString x}" x.result)
					|> lib.filter (x: x.data)
					|> map (x: x.name)
					|> lib.filter (x: lib.elem x usedLayers)
				;
			};
		};

		config = {
			layers = lib.mkMerge [
				(lib.genAttrs usedLayers (_: true))
				{
					defaultLayers = false;
				}
			];

			enums.layers = config.layers
				|> map fConfig.parts.layerVar
			;
		};
	};

	parts = {
		layerVar = x: "LAYER_${x}";
		layerHold = x: "MO(${config.parts.layerVar x})";
		layerToggle = x: "TG(${config.parts.layerVar x})";
	};
}
