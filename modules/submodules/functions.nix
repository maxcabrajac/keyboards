{ lib, dag, entryAt, ... }: let
	t = lib.types;
in {
	submodules = { config, ... }: {
		options.functions = lib.mkOption {
			type = t.attrsOf <| t.submodule ({ name, config, ... }: {
				options = {
					arguments = lib.mkOption {
						# maybe this should be more elaborate
						type = t.listOf <| t.str;
					};
					returnType = lib.mkOption {
						type = t.str;
						default = "void";
					};
					defaultReturn = lib.mkOption {
						type = t.str;
					};
					definition = lib.mkOption {
						type = t.str;
					};
					body = lib.mkOption {
						type = dag.of <| t.coercedTo t.str (code: { inherit code; }) <| t.submodule {
							options = {
								wrap = lib.mkOption {
									type = t.bool;
									default = true;
								};
								code = lib.mkOption {
									type = t.str;
								};
							};
						};

						apply = d: let
							w = c: "{\n${c}\n}";
						in
							d
							|> dag.topoSort
							|> (x: lib.throwIfNot (x ? "result") "function ${name} body dag error: ${x}" x.result)
							|> map ({ data, ... }: data)
							|>	map ({ wrap, code }:	if wrap then w code else code)
							|> (x: if config.returnType != "void" then x ++ [ "return ${config.defaultReturn};" ] else x)
							|> lib.concatLines
							|> w
						;
					};

				};

				config.definition = "${config.returnType} ${name}(${config.arguments |> lib.concatStringsSep ", "})";
			});
		};

		config = {
			files."keymap.c".functions = config.functions
				|> lib.attrValues
				|> lib.foldl (acc: f: {
					definitions = acc.definitions ++ [ (f.definition + ";") ];
					bodies = acc.bodies ++ [ (f.definition + f.body) ];
				}) { definitions = []; bodies = []; }
				|> ({ definitions, bodies }: definitions ++ [ "" ] ++ bodies)
				|> lib.concatLines
				|> entryAt "code"
			;

			functions = {
				default_layer_state_set_user = {
					arguments = [ "layer_state_t state" ];
					returnType = "layer_state_t";
					defaultReturn = "state";
				};

				process_record_user = {
					arguments = [ "uint16_t keycode" "keyrecord_t *record" ];
					returnType = "bool";
					defaultReturn = "true";
				};
			};
		};
	};
}
