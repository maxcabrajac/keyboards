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
					[ "MS_LEFT" "MS_DOWN" "MS_RGHT" "MS_WHLD" x "KC_LEFT" "KC_DOWN" "KC_UP" "KC_RIGHT" x ]
					[ x         x         x         x         x x         x         x       x          x ]
				];
				leftThumb = layout.row [ "KC_NO" "MS_BTN1" "MS_BTN2" ];
			})
			# WARN: generic gaming layer does *not* have access to ALT or ESC
			#       they MUST be added by keyboard specific configuration
			(asLayer "gaming" ({
				inherit (p) numberRow;
				center = p.qwerty |> p.emulatedOn p.colemak;
			} |> lib.mapAttrs (_: x: x
				|> layout.splitHands
				|> ({ left, right }: layout.concat left (right |> layout.map (_: p.layerToggle "gaming")))
			)))
			(asLayer "gaming" {
				# INFO: J and I are here for retrocompatibility reasons.
				# TODO: Change J and I for less random keys
				leftThumb = helpers.mkSimpleLayer [
					[ "LCTL" "SPC" "J" ]
				];
				leftSide = helpers.mkSimpleLayer [
					[ "TAB" ]
					[ "I" ]
					[ "LSFT" ]
				];
				rightThumb = layout.row <| lib.genList (_: p.layerToggle "gaming") 3;
				rightSide = layout.column <| lib.genList (_: p.layerToggle "gaming") 3;
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

			settings = {
				TAPPING_TERM = "200";
				PERMISSIVE_HOLD = "";
			};

			rules = {
				AUDIO_ENABLE = false;
				COMMAND_ENABLE = false;
			};
		};

		# This is not a real keyboard just an IR-keyboard
		layouter = _: layout.unit { layer = "KC_NO"; };
	};
}
