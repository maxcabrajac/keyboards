{
	perSystem = { mkKeyboard, ... }: {
		apps.redox-legacy =  mkKeyboard {
			src = ./src;
			keyboard = "redox";
			variant = "rev1";
		};
	};
}
