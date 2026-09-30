{ lib, layout, ... }: {
	# Is there a bettew way to do this? This is how I did it by hand.
	parts.emulatedOn = emulator: emulated: emulator
		|> layout.map ({ rawPosition, ... }:
			rawPosition
			|> lib.elemAt emulated.values
			|> (x: lib.lists.findFirstIndex (y: y == x) null emulator.values)
			|> lib.elemAt emulated.values
		)
	;
}
