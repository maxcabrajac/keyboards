{ lib, layout, config, ... }: let
	p = config.parts;
in {
	keyboards.generic = {
		parts = {
			center = [
				(p.qwerty "qwerty")
				(p.numbers "numbers")
			];
		}
		|> lib.mapAttrs (_: lib.foldl (layout.mergeWith (a: b: lib.mkMerge [ a b ])) null);

		# This is not a real keyboard just an IR-keyboard
		layouter = _: layout.unit { layer = "KC_NO"; };
	};
}
