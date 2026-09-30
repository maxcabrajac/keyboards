{ layout, helpers, config, dag, ... }: let
	p = config.parts;
in {
	keyboards.generic = {
		parts = {
			center = {
				qwerty = p.qwerty |> p.modtap_row 2 [ "S" "C" "A" "M" ];
				numbers = helpers.mkSimpleLayer [
					[ "LCBR" "AMPR" "LABK" "RABK" "RCBR" "SLSH" "7" "8" "9" "ASTR" ]
					[ "LPRN" "DLR"  "PERC" "CIRC" "RPRN" "EQL"  "4" "5" "6" "0"    ]
					[ "LBRC" "EXLM" "AT"   "HASH" "RBRC" "PIPE" "1" "2" "3" "BSLS" ]
				];
				navigation = let x = "KC_NO"; in layout.matrix [
					[ x         "MS_UP"   x         "MS_WHLU" x x         x         x       x          x ]
					[ "MS_LEFT" "MS_DOWN" "MS_LEFT" "MS_WHLD" x "KC_LEFT" "KC_DOWN" "KC_UP" "KC_RIGHT" x ]
					[ x         x         x         x         x x         x         x       x          x ]
				];
			};
			rightThumb = {
				qwerty = layout.matrix [
					[ "KC_ENT" (p.modtap "G" "KC_SPC") "KC_UNDS" ]
				];
				numbers = helpers.mkSimpleLayer [
					[ "PLUS" "TRANSPARENT" "MINS" ]
				];
			};
			numberRow = {
				qwerty = helpers.mkSimpleLayer [
					[ "NO" "NO" "NO" "NO" "NO" "NO" "LEFT" "DOWN" "UP" "RIGHT" "NO" "PSCR" ]
				];
				numbers = helpers.mkSimpleLayer [
					[ "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10" "F11" "F12" ]
				];
			};
			leftThumb.qwerty = helpers.mkSimpleLayer [
				[ "TAB" "BSPC" "ESC" ]
			];
			leftSide.qwerty = layout.column [
				"KC_GRV"
				(p.layerOrCapsword "numbers")
				(p.layerHold "navigation")
			];
			rightSide.qwerty = layout.column [
				"KC_QUOT"
				(p.layerOrCapsword "numbers")
				(p.layerHold "navigation")
			];
		};

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
