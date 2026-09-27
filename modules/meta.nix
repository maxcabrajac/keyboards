{ lib, layout, config, ... }: let
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
	flakeConfig = config;
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
			type = t.attrsOf <| t.submodule ({ config, ... }: {
				options = {
					parts = lib.mkOption {
						type = t.attrsOf <| t.attrsOf <| layout.Of <| t.coercedTo t.str (key: { inherit key; }) key;
					};

					finalParts = lib.mkOption {
						type = t.attrsOf <| layout.Of layeredKey;
						readOnly = true;
					};

					layouter = lib.mkOption {
						type = t.functionTo <| layout.Of <| t.nullOr layeredKey;
					};

					keymap = lib.mkOption {
						type = layout.Of <| t.nullOr layeredKey;
					};

					submodule = lib.mkOption {
						type = t.deferredModuleWith {};
					};

					evaluated = lib.mkOption {
						type = t.anything;
						readOnly = true;
					};
				};

				config = let
					layers = config.parts
						|> lib.attrValues
						|> map lib.attrNames
						|> lib.flatten
						|> lib.uniqueStrings
					;
				in {
					finalParts = config.parts
						|> lib.mapAttrs (_: part:
							part
							|> lib.mapAttrs (layer: layout.map ({ key, ... }: removeAttrs key [ "key" ] // { ${layer} = key.key;} ))
							|> (p: lib.genAttrs layers (l: p |> lib.attrByPath [ l ] (layout.unsized { ${l} = "KC_TRANSPARENT"; })))
							|> lib.attrValues
							# # TODO: This should be the merge function of layout.Of
							|> layout.mergeL (a: b: lib.mkMerge [ a b ])
						)
					;

					keymap = config.layouter config.finalParts;

					submodule = {
						imports = config.keymap.values
							|> lib.filter (x: !isNull x)
							|> lib.map (x: x._m)
						;

						options = lib.genAttrs [ "keymap" "layers" ] (_: lib.mkOption {
							type = t.anything;
							readOnly = true;
						});

						config = {
							inherit (config) keymap;
							inherit layers;
						};
					};

					evaluated = (lib.evalModules {
						modules = [ config.submodule flakeConfig.submodules ];
					}).config;
				};
			});
		};
	};

	config.flake = { inherit (config) keyboards parts; };
}
