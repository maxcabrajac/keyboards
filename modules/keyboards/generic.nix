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
				(p.layerHold "numbers")
				"KC_NO"
			];
			rightSide.qwerty = layout.column [
				"KC_QUOT"
				(p.layerHold "numbers")
				"KC_NO"
			];
		};

		submodule = {
			layers.qwerty = dag.entryBefore [ "defaultLayers" ] true;
		};

		# This is not a real keyboard just an IR-keyboard
		layouter = _: layout.unit { layer = "KC_NO"; };
	};
}
