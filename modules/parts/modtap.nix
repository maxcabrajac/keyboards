{ layout, lib, ... }: {
	parts = rec {
		modtap = mod: key: let
			mods = {
				S = "MOD_LSFT";
				C = "MOD_LCTL";
				M = "MOD_LGUI";
				A = "MOD_LALT";
				G = "MOD_RALT";
			};
		in
			if isNull mod
			then key
			else "MT(${mods.${mod}}, ${key})"
		;

		modtap_row = r: mods:
			layout.map ({ key, row, column, width, ... }:
				 let
					handIndex = lib.min column (width - column - 1);
					mod = if handIndex < (lib.length mods)
						then lib.elemAt mods handIndex
						else null
					;
				in
					if (row != r)
					then key
					else modtap mod key
			)
		;
	};
}
