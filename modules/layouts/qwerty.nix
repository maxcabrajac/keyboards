{ layout, ... }: {
	parts.qwerty = layer: layout.matrix [
		[ "Q" "W" "E" "R" "T" "Y" "U" "I"    "O"   "P" ]
		[ "A" "S" "D" "F" "G" "H" "J" "K"    "L"   "SCLN" ]
		[ "Z" "X" "C" "V" "B" "N" "M" "COMM" "DOT" "SLSH" ]
	] |> layout.map ({ key, ... }: { ${layer} = "KC_${key}"; });
}
