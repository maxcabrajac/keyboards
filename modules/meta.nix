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
in {
	options = {
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
						# type = t.attrsOf <| t.anything;
						readOnly = true;
					};

					layouter = lib.mkOption {
						type = t.functionTo <| layout.Of layeredKey;
					};

					keymap = lib.mkOption {
						type = layout.Of layeredKey;
					};
				};

				config = {
					finalParts = let
						layers = config.parts
							|> lib.attrValues
							|> map lib.attrNames
							|> lib.flatten
							|> lib.uniqueStrings
						;
					in config.parts
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
				};
			});
		};
	};

	config.flake = { inherit (config) keyboards parts; };
}
