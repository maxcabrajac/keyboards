{ layout, config, helpers, ... }: {
	parts = {
		RThumb = helpers.mkLayer <| layout.matrix [
			[ "KC_ENT" (config.parts.modtap "G" "KC_SPC") "KC_UNDS" ]
		];
		LThumb = helpers.mkSimpleLayer [
			[ "TAB" "BSPC" "ESC" ]
		];
	};
}
