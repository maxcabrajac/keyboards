{ lib, layout, config, ... }: let
	t = lib.types;
	fConfig = config;
	keyModules = [
		{
			options._m = lib.mkOption {
				type = t.deferredModuleWith {};
				default = {};
			};
		}
	];
	keyT = t.submodule {
		imports = keyModules;
		options.key = lib.mkOption {
			type = t.str;
			default = "KC_NO";
		};
	};
	layeredKeyT = t.submodule {
		imports = keyModules;
		freeformType = t.attrsOf t.str;
	};

	# TODO: this is spaguetti code to allow reuse
	keyboardOptions = {
		# <part>.<layer> = layout
		# This CAN have unused keys or even full unused parts.
		parts = lib.mkOption {
			type = t.attrsOf <| t.attrsOf <| layout.Of <| t.coercedTo t.str (key: { inherit key; }) keyT;
		};

		# { <part> = layout } (layers are merged from parts) -> layouterOutput
		# Whatever this outputs is final. All modules contained in keys will be used during evaluation.
		layouter = lib.mkOption {
			type = t.functionTo <| t.attrsOf <| layout.Of <| t.nullOr layeredKeyT;
		};

		submodule = lib.mkOption {
			type = t.deferredModuleWith {};
		};
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
			type = t.lazyAttrsOf <| t.submodule {
				options = keyboardOptions;
			};
		};

		keyboards' = lib.mkOption {
			type = t.lazyAttrsOf <| t.submodule ({ config, ...}: {
				options = keyboardOptions // {
					mergedParts = lib.mkOption {
						type = t.attrsOf <| layout.Of <| layeredKeyT;
						readOnly = true;
					};

					layouterOutput = lib.mkOption {
						type = t.attrsOf <| layout.Of <| t.nullOr layeredKeyT;
					};
				};

				config = {
					mergedParts = let
						layers = config.parts
							|> lib.attrValues
							|> map lib.attrNames
							|> lib.flatten
							|> lib.uniqueStrings
						;
					in
						config.parts
						|> lib.mapAttrs (_: part:
							part
							|> lib.mapAttrs (layer: layout.map ({ key, ... }: removeAttrs key [ "key" ] // { ${layer} = key.key; } ))
							|> (p: lib.genAttrs layers (l: p |> lib.attrByPath [ l ] (layout.unsized { ${l} = "KC_TRANSPARENT"; })))
							|> lib.attrValues
							# TODO: This should be the merge function of layout.Of
							|> layout.mergeL (a: b: lib.mkMerge [ a b ])
						)
					;

					layouterOutput = config.layouter config.mergedParts;
				};
			});
		};
	};

	config = {
		keyboards' = config.keyboards;

		flake = {
			inherit (config) parts;
			keyboards = config.keyboards';
		};
	};
}
