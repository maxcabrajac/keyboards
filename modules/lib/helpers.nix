{ lib, layout, ... }: {
	_module.args.helpers = rec {
		mkSimpleLayer = keys:
			keys
			|> layout.matrix
			|> layout.map ({ key, ... }: "KC_${key}")
		;
	};
}
