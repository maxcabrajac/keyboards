{ lib, layout, helpers, config, ... }: let
	l = layout;
	p = config.parts;
in {
	keyboards.sofle = lib.mkMerge [ config.keyboards.generic {
		parts = {
			leftBigThumb.qwerty = l.unit "KC_NO";
			leftHiddenThumb.qwerty = l.unit <| p.layerToggle "gaming";
			leftKnob.qwerty = helpers.mkSimpleLayer [[ "NO" "NO" "NO" ]];

			rightBigThumb.qwerty = l.unit "KC_NO";
			rightHiddenThumb.qwerty = l.unit p.layerStash;
			rightKnob.qwerty = helpers.mkSimpleLayer [[ "VOLD" "MUTE" "VOLU" ]];
		};

		layouter = lib.mkForce (p: let
			ommit = l.unit null;
			concatAll = lib.foldr l.concat null;
			stackAll = lib.foldr l.stack null;
			bottomRow = concatAll [
				ommit p.leftHiddenThumb p.leftThumb p.leftBigThumb
				p.rightBigThumb p.rightThumb p.rightHiddenThumb ommit
			];
			allKeys = stackAll [
				p.numberRow
				(concatAll [ p.leftSide p.center p.rightSide ])
				bottomRow
			];
			hands = l.splitHands allKeys;
			knobColumn = knob: stackAll [
				ommit
				ommit
				ommit
				knob
				ommit
			];

			# TODO: Move these somewhere else (?)
			getKnobClick = knob: l.unit <| lib.elemAt knob.values 1;
			# INFO: For now only the right knob is installed and it's inverted.
			# TODO: Check if the left knob is also inverted
			getKnobRotations = knob: [ 2 0 ]
				|> map (lib.elemAt knob.values)
				|> layout.row
			;

			knobs = [ p.leftKnob p.rightKnob ]
				|> map getKnobClick
				|> map knobColumn
				|> concatAll
			;
		in {
			keymap = concatAll [ hands.left knobs hands.right ];
			leftKnob = getKnobRotations p.leftKnob;
			rightKnob = getKnobRotations p.rightKnob;
		});

		submodule = { config, ... }: {
			knobs = with config.layouterOutput; [ leftKnob rightKnob ];
		};
	}];
}
