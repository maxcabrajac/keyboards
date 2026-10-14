{ lib, inputs, config, ... }: let
	t = lib.types;
in {
	options.keyboards' = lib.mkOption {
		type = t.lazyAttrsOf <| t.submodule ({ name, ... }: {
			submodule.options = {
				keyboard = lib.mkOption {
					type = t.str;
					default = name;
				};
			};
		});
	};

	config = {
		submodules = { config, ... }: {
			options = {
				variant = lib.mkOption {
					type = t.str;
					default = "rev1";
				};

				sourceTree = lib.mkOption {
					type = t.functionTo t.package;
				};
			};

			config.sourceTree = pkgs: config.files
				|> lib.mapAttrsToList (fname: content: {
					name = fname;
					path = pkgs.writeText "${config.keyboard}-${config.variant}-${fname}" content;
				})
				|> pkgs.linkFarm "${config.keyboard}-${config.variant}"
			;
		};

		perSystem = { system, pkgs, ... }: {
			config = config.flake.keyboards
				|> lib.mapAttrsToList (name: kb: let
					nc = inputs.nixcaps.lib.${system};
					src = kb.evaluated.sourceTree pkgs;
					ncData = {
						inherit src;
						inherit (kb.evaluated) keyboard variant;
					};
				in {
					packages = {
						"${name}-source" = src;
						${name} = nc.mkQmkFirmware ncData;
					};
					apps = {
						${name} = nc.flashQmkFirmware ncData;
					};
				})
				|> lib.mkMerge
			;
		};
	};
}
