{ lib, layout, config, helpers, ... }: let
	t = lib.types;
	keyModules = [
		{
			options._m = lib.mkOption {
				type = t.deferredModuleWith {};
				default = {};
			};
		}
	];
	key = t.submodule {
		imports = keyModules;
		options.key = lib.mkOption {
			type = t.str;
			default = "KC_NO";
		};
	};
	layeredKey = t.submodule {
		imports = keyModules;
		freeformType = t.attrsOf t.str;
	};
in {
	options = {
		submodules = lib.mkOption {
			type = t.deferredModuleWith {};
			default = {};
		};

		parts = lib.mkOption {
			type = t.attrsOf <| t.anything;
		};

		keyboards = lib.mkOption {
			type = t.lazyAttrsOf <| t.submodule ({
				options = {
					parts = lib.mkOption {
						type = t.attrsOf <| t.attrsOf <| layout.Of <| t.coercedTo t.str (key: { inherit key; }) key;
					};

					layouter = lib.mkOption {
						type = t.functionTo <| layout.Of <| t.nullOr layeredKey;
					};

					submodule = lib.mkOption {
						type = t.deferredModuleWith {};
						default = {};
					};
				};
			});
		};

		evaluatedKeyboards = lib.mkOption {
			type = t.attrsOf t.anything;
			readOnly = true;
		};
	};

	config = {
		evaluatedKeyboards = config.keyboards |> lib.mapAttrs (_: kb: let
			layers = kb.parts
				|> lib.attrValues
				|> map lib.attrNames
				|> lib.flatten
				|> lib.uniqueStrings
			;

			keymap = kb.parts
				|> lib.mapAttrs (_: part:
					part
					|> lib.mapAttrs (layer: layout.map ({ key, ... }: removeAttrs key [ "key" ] // { ${layer} = key.key; } ))
					|> (p: lib.genAttrs layers (l: p |> lib.attrByPath [ l ] (layout.unsized { ${l} = "KC_TRANSPARENT"; })))
					|> lib.attrValues
					# # TODO: This should be the merge function of layout.Of
					|> layout.mergeL (a: b: lib.mkMerge [ a b ])
				)
				|> helpers.evalAs (t.attrsOf <| layout.Of layeredKey)
				|> kb.layouter
				|> helpers.evalAs (layout.Of <| t.nullOr layeredKey)
			;

			keyboardSubmodule = {
				imports = keymap.values
					|> lib.filter (x: !isNull x)
					|> lib.map (x: x._m)
				;

				options = lib.genAttrs [ "keymap" "layers" ] (_: lib.mkOption {
					type = t.anything;
				});

				config = {
					inherit keymap layers;
				};
			};
		in
			lib.evalModules {
				modules = [
					kb.submodule
					keyboardSubmodule
					config.submodules
				];
			}
			|> (x: x.config)
		);

		flake = {
			inherit (config)
				keyboards
				evaluatedKeyboards
				parts
			;
		};
	};
}
