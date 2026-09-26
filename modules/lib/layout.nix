{ lib, ... }: let
	assertSame = key: a: b: lib.throwIfNot (a.${key} == b.${key}) "Values must have the same ${key}: ${toString a.${key}}, ${toString b.${key}}";
	shortCircuitNulls = a: b: merge:
		if isNull a
		then b
		else if isNull b
		then a
		else merge
	;
in {
	# TODO: test this code
	_module.args.layout = rec {
		Of = x: lib.types.submodule {
			options = {
				width = lib.mkOption {
					type = lib.types.int;
				};
				height = lib.mkOption {
					type = lib.types.int;
				};
				values = lib.mkOption {
					type = lib.types.listOf x;
				};
			};
		};

		unit = x: {
			width = 1;
			height = 1;
			values = [ x ];
		};

		row = x: {
			width = lib.length x;
			height = 1;
			values = x;
		};

		column = x: {
			width = 1;
			height = lib.length x;
			values = x;
		};

		matrix = x: x
			|> map row
			|> (r: lib.foldl stack null r);

		stack = top: bottom: shortCircuitNulls top bottom <| assertSame "width" top bottom {
			inherit (top) width;
			height = top.height + bottom.height;
			values = top.values ++ bottom.values;
		};

		toNestedArray = l: let
				batch = x: l:
					if (lib.length l) <= x
					then [l]
					else [(lib.take x l)] ++ (batch x (lib.drop x l))
				;
		in batch l.width l.values;

		concat = left: right: shortCircuitNulls left right <| assertSame "height" left right {
			width = left.width + right.width;
			inherit (left) height;
			values = lib.flatten (lib.zipListsWith (l: r: [ l r ]) (toNestedArray left) (toNestedArray right));
		};

		mergeWith = f: over: under: shortCircuitNulls over under <| assertSame "width" over under <| assertSame "height" over under {
			inherit (over) width height;
			values = lib.zipListsWith f over.values under.values;
		};

		overlay = mergeWith (o: u: if isNull o then u else o);
	};

	imports = [({ layout, ... }: {
		flake.testLayoutLib = {
			twoCols = let
				c1 = layout.column [ 1 2 3 ];
				c2 = layout.column [ 4 5 6 ];
			in {
				stack = layout.stack c1 c2;
				concat = layout.concat c1 c2;
			};
			twoRows = let
				r1 = layout.row [ 1 2 3 ];
				r2 = layout.row [ 4 5 6 ];
			in {
				stack = layout.stack r1 r2;
				concat = layout.concat r1 r2;
			};
			matrix = layout.matrix [
				[ 1 2 3 ]
				[ 4 5 6 ]
				[ 7 8 9 ]
			];
		};
	})];
}
