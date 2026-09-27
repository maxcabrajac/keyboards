{ helpers, ... }: {
	parts = {
		numpad = helpers.mkSimpleLayer [
			[ "7" "8" "9" null ]
			[ "4" "5" "6" "0"  ]
			[ "1" "2" "3" null ]
		];
		# TODO: stack symbols on top of numpad
		numbers = helpers.mkSimpleLayer [
			[ "LCBR" "AMPR" "LABK" "RABK" "RCBR" "SLSH" "7" "8" "9" "ASTR" ]
			[ "LPRN" "DLR"  "PERC" "CIRC" "RPRN" "EQL"  "4" "5" "6" "0"    ]
			[ "LBRC" "EXLM" "AT"   "HASH" "RBRC" "PIPE" "1" "2" "3" "BSLS" ]
		];
		numbersRThumb = helpers.mkSimpleLayer [
			[ "PLUS" "TRANSPARENT" "MINS" ]
		];
	};
}

