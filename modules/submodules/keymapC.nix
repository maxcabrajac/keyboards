{ lib, dag, ... }: {
	submodules.files."keymap.c" = [
		"preamble"
		"definitions"
		"code"
		"keymap"
	] |> lib.foldl (res: sec: {
			acc = res.acc // {
				"${sec}Start" = dag.entryAfter res.after "// START ${sec}";
				"${sec}End" = dag.entryAfter ["${sec}Start"] "// END ${sec}";
			};
			after = [ "${sec}End" ];
		}) { acc = {}; after = []; }
	|> (x: x.acc);
}
