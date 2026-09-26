{
	perSystem = { mkKeyboard, ... }: {
		packages.redox =  mkKeyboard {
			src = ./src;
			keyboard = "redox";
			variant = "rev1";
		};
	};
}
