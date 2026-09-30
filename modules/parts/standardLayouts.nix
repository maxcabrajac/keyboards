{ helpers, ... }: {
	parts = {
		numberRow = helpers.mkSimpleLayer [
			[ "GRV" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "MINS" ]
		];
		qwerty = helpers.mkSimpleLayer [
			[ "Q" "W" "E" "R" "T" "Y" "U" "I"    "O"   "P" ]
			[ "A" "S" "D" "F" "G" "H" "J" "K"    "L"   "SCLN" ]
			[ "Z" "X" "C" "V" "B" "N" "M" "COMM" "DOT" "SLSH" ]
		];
		colemak = helpers.mkSimpleLayer [
			[ "Q" "W" "F" "P" "G" "J" "L" "U"    "Y"   "SCLN" ]
			[ "A" "R" "S" "T" "D" "H" "N" "E"    "I"   "O" ]
			[ "Z" "X" "C" "V" "B" "K" "M" "COMM" "DOT" "SLSH" ]
		];
	};
}
