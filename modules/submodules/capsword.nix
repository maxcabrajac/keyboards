{ lib, ... }: let
	t = lib.types;
in {
	submodules = { config, ... }: let
		cfg = config.capsword;
	in {
		options.capsword = {
			enable = lib.mkOption {
				type = t.bool;
				default = false;
			};
			shifted = lib.mkOption {
				type = t.listOf t.str;
				default = [ "KC_A ... KC_Z" ];
			};
			unshifted = lib.mkOption {
				type = t.listOf t.str;
			};
		};

		config = lib.mkMerge [
			{
				capsword.unshifted = [
					"KC_1 ... KC_0"
					"KC_BSPC"
					"KC_DEL"
					"KC_UNDS"
					"KC_MINS"
				];
			}
			(lib.mkIf cfg.enable {
				rules.CAPS_WORD_ENABLE = true;
				functions.caps_word_press_user = {
					arguments = [ "uint16_t keycode" ];
					returnType = "bool";
					defaultReturn = "false";
					body.main = let
						cases = l: l
							|> map (x: "case ${x}:")
							|> lib.concatStringsSep " "
						;
					in /* c */ ''
						switch (keycode) {
							${cases cfg.shifted}
								add_weak_mods(MOD_BIT(KC_LSFT));
							${cases cfg.unshifted}
								return true;
						}
					'';
				};
			})
		];
	};
}
