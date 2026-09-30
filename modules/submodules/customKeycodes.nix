{ lib, ... }: {
	submodules.enums.customKeycodes = lib.mkBefore [{
		name = "THIS_IS_HERE_JUST_TO_SET_SAFE_RANGE";
		value = "SAFE_RANGE";
	}];
}
