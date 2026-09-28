{ lib, layout, ... }: {
	_module.args.helpers = {
		mkSimpleLayer = keys:
			keys
			|> layout.matrix
			|> layout.map ({ key, ... }: "KC_${key}")
		;

		# Is this how to do this?
		evalAs = type: value:
			lib.evalModules {
				modules = [{
					options.out = lib.mkOption {
						inherit type;
					};
					config.out = value;
				}];
			}
			|> (x: x.config.out)
		;
	};
}
