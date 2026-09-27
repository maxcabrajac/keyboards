{ lib, layout, ... }: {
	_module.args.helpers = rec {
		mkLayer = keys: layer:
			layout.map ({ key, ... }: { ${layer} = key; }) keys
		;

		mkSimpleLayer = keys:
			keys
			|> layout.matrix
			|> layout.map ({ key, ... }: "KC_${key}")
			|> mkLayer
		;

		mapLayer = layer: f: key: key // { ${layer} = f key.${layer}; };
	};
}
