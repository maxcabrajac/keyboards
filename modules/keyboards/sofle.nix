{ lib, layout, helpers, config, ... }: let
	l = layout;
in {
	keyboards.sofle = {
		parts = config.keyboards.generic.parts // {
			leftBigThumb.qwerty = l.unit "KC_NO";
			leftHiddenThumb.qwerty = l.unit "KC_NO";
			leftKnob.qwerty = helpers.mkSimpleLayer [[ "NO" "NO" "NO" ]];

			rightBigThumb.qwerty = l.unit "KC_NO";
			rightHiddenThumb.qwerty = l.unit "KC_NO";
			rightKnob.qwerty = helpers.mkSimpleLayer [[ "NO" "NO" "NO" ]];
		};

		layouter = p: let
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
			# TODO: Set knob rotation
			# TODO: Move this somewhere else
			knobs = [ p.leftKnob p.rightKnob ]
				|> map (x: l.unit (lib.elemAt x.values 1))
				|> map knobColumn
				|> concatAll
			;
		in
			concatAll [ hands.left knobs hands.right ]
		;
	};
}
