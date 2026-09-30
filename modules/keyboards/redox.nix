{ lib, layout, helpers, config, ... }: let
	l = layout;
	p = config.parts;
in {
	keyboards.redox = lib.mkMerge [ config.keyboards.generic {
		parts = {
			leftLowerRow = {
				qwerty = helpers.mkSimpleLayer [[ "MPLY" "MPRV" "MNXT" ]];
				navigation = l.row ["QK_BOOT" "QK_RBT" "KC_NO" ];
				gaming = helpers.mkSimpleLayer [[ "Y" "M" "LALT" ]];
			};
			rightLowerRow.qwerty = layout.row [ "KC_NO" "KC_NO" p.layerStash ];
			# INFO: the two columns zigzag from the top to the thumb clusters
			centerColumns = {
				qwerty = layout.matrix [
					[ "KC_VOLD"                                  "KC_VOLU" ]
					[ "KC_NO"                                    "KC_NO"   ]
					[ "KC_NO"                                    "KC_NO"   ]
					[           (p.layerToggle "gaming") "KC_NO"           ]
					[           "KC_NO"                  "KC_NO"           ]
				];
				# TODO: define this gaming layer as <qwerty native gaming layer> |> p.emulatedOn p.colemak
				gaming = layout.matrix [
					[ "KC_O"                                      (p.layerToggle "gaming") ]
					[ "KC_H"                                      (p.layerToggle "gaming") ]
					[ "KC_L"                                      (p.layerToggle "gaming") ]
					[           "KC_ESC" (p.layerToggle "gaming")                          ]
					[           "KC_N"   (p.layerToggle "gaming")                          ]
				];
			};
		};

		# TODO: Move these somewhere else
		submodule = {
			settings = {
				SPLIT_USB_DETECT = "";
				SPLIT_USB_TIMEOUT = "10000";
				MASTER_LEFT = "";
			};
			rules = {
				RGBLIGHT_ENABLE = false;
				AUDIO_ENABLE = false;
				COMMAND_ENABLE = false;
			};
		};

		layouter = lib.mkForce (p: let
			ommit = l.unit null;
			concatAll = lib.foldr l.concat null;
			stackAll = lib.foldr l.stack null;

			nonCenterColumns = stackAll [
				p.numberRow
				(concatAll [ p.leftSide p.center p.rightSide ])
				(concatAll [ p.leftLowerRow p.leftThumb p.rightThumb p.rightLowerRow ])
			] |> l.splitHands;

			ccAsNested = p.centerColumns |> l.toNestedArray;
			ommitRow = concatAll [ ommit ommit ];
			ccUpper = ccAsNested
				|> lib.take 3
				|> l.matrix
				|> (x: stackAll [
					ommitRow
					x
					ommitRow
				]) |> l.splitHands
			;
			ccLower = ccAsNested
				|> lib.drop 3
				|> l.matrix
				|> (x: stackAll [
					ommitRow
					ommitRow
					ommitRow
					x
				])
			;

			cc = concatAll [ ccUpper.left ccLower ccUpper.right ];
		in
			concatAll [ nonCenterColumns.left cc nonCenterColumns.right ]
		);
	}];
}
