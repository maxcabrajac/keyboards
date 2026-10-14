{ lib, ... }: let
	t = lib.types;
in {
	options.keyboards' = lib.mkOption {
		type = t.lazyAttrsOf <| t.submodule ({ config, ... }: {
			config.submodule = config.layouterOutput
				|> lib.attrValues
				|> map (x:
					x.values
					|> lib.filter (x: !isNull x)
					|> map (x: x._m)
				)
				|> lib.flatten
				|> lib.mkMerge
			;
		});
	};
}
