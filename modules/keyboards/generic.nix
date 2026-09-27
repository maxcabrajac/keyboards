{ lib, layout, config, ... }: let
	p = config.parts;
	goToLayer = x: "MO(LAYER_${x})";
in {
	keyboards.generic = {
		parts = {
			center = {
				inherit (p)
					qwerty
					numbers
				;
			};
			leftSide.qwerty = layout.column [
				"KC_GRV"
				(goToLayer "qwerty")
				"KC_NO"
			];
			rightSide.qwerty = layout.column [
				"KC_QUOT"
				(goToLayer "qwerty")
				"KC_NO"
			];
		};

		# This is not a real keyboard just an IR-keyboard
		layouter = _: layout.unit { layer = "KC_NO"; };
	};
}
