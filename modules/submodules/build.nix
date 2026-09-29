{ lib, inputs, config, ... }: let
	t = lib.types;
in {
	submodules = { config, ... }: {
		options = {
			keyboard = lib.mkOption {
				type = t.str;
				default = config.name;
			};

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
		config = config.evaluatedKeyboards
			|> lib.mapAttrsToList (name: kb: let
				nc = inputs.nixcaps.lib.${system};
				src = kb.sourceTree pkgs;
				ncData = {
					inherit src;
					inherit (kb) keyboard variant;
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
}
