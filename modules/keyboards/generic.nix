{ lib, layout, helpers, config, dag, ... }: let
	p = config.parts;
	asLayer = layer: lib.mapAttrs (_: values: { ${layer} = values; });
in {
	keyboards.generic = {
		parts = lib.mkMerge [
			(asLayer "qwerty" {
				numberRow = helpers.mkSimpleLayer [
					[ "NO" "NO" "NO" "NO" "NO" "NO" "LEFT" "DOWN" "UP" "RIGHT" "NO" "PSCR" ]
				];
				center = p.qwerty |> p.modtap_row 2 [ "S" "C" "A" "M" ];
				rightThumb = layout.matrix [
					[ "KC_ENT" (p.modtap "G" "KC_SPC") "KC_UNDS" ]
				];
				numberRow = helpers.mkSimpleLayer [
					[ "NO" "NO" "NO" "NO" "NO" "NO" "LEFT" "DOWN" "UP" "RIGHT" "NO" "PSCR" ]
				];
				leftThumb = helpers.mkSimpleLayer [
					[ "TAB" "BSPC" "ESC" ]
				];
				leftSide = layout.column [
					"KC_GRV"
					(p.layerOrCapsword "numbers")
					(p.layerHold "navigation")
				];
				rightSide = layout.column [
					"KC_QUOT"
					(p.layerOrCapsword "numbers")
					(p.layerHold "navigation")
				];
			})
			(asLayer "numbers" {
				center = helpers.mkSimpleLayer [
					[ "LCBR" "AMPR" "LABK" "RABK" "RCBR" "SLSH" "7" "8" "9" "ASTR" ]
					[ "LPRN" "DLR"  "PERC" "CIRC" "RPRN" "EQL"  "4" "5" "6" "0"    ]
					[ "LBRC" "EXLM" "AT"   "HASH" "RBRC" "PIPE" "1" "2" "3" "BSLS" ]
				];
				rightThumb = helpers.mkSimpleLayer [
					[ "PLUS" "TRANSPARENT" "MINS" ]
				];
				numberRow = helpers.mkSimpleLayer [
					[ "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" ]
				];
			})
			(asLayer "navigation" {
				center = let x = "KC_NO"; in layout.matrix [
					[ x         "MS_UP"   x         "MS_WHLU" x x         x         x       x          x ]
					[ "MS_LEFT" "MS_DOWN" "MS_LEFT" "MS_WHLD" x "KC_LEFT" "KC_DOWN" "KC_UP" "KC_RIGHT" x ]
					[ x         x         x         x         x x         x         x       x          x ]
				];
			})
		];

		submodule = {
			layers.qwerty = dag.entryBefore [ "defaultLayers" ] true;
			capsword.shifted = [
				# P is colemak's ; so we ommit it
				"KC_A ... KC_O" /* KC_P */ "KC_Q ... KC_Z"
				# ; is colemak's O so we add it
				"KC_SCLN"
			];
		};

		# This is not a real keyboard just an IR-keyboard
		layouter = _: layout.unit { layer = "KC_NO"; };
	};
}
