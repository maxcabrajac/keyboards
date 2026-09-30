{ inputs, ... }: {
	perSystem = { system, ... }: {
		_module.args.mkKeyboard = inputs.nixcaps.lib.${system}.flashQmkFirmware;
	};
}
