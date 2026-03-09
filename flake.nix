{
	inputs = {
		nixcaps.url = "github:agustinmista/nixcaps";
		nixpkgs.follows = "nixcaps/nixpkgs";
		flake-utils.follows = "nixcaps/flake-utils";
	};

	outputs = inputs @ {
		nixpkgs,
		flake-utils,
		...
	}:
		flake-utils.lib.eachDefaultSystem (system: let
			pkgs = nixpkgs.legacyPackages.${system};
			nixcaps = inputs.nixcaps.lib.${system};
			redox = {
				src = ./redox;
				keyboard = "redox";
				variant = "rev1";
			};
		in {
			packages = {
				redox = nixcaps.mkQmkFirmware redox;
			};

			apps = {
				redox = nixcaps.flashQmkFirmware redox;
			};

			devShells.default = pkgs.mkShell {
				QMK_HOME = "${inputs.nixcaps.inputs.qmk_firmware}";
				packages = [ pkgs.qmk ];
				shellHook = ''
					ln -sf "${nixcaps.mkCompileDb redox}/compile_commands.json" ./redox/compile_commands.json
				'';
			};
		});
}
