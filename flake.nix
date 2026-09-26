{
	inputs = {
		nixcaps.url = "github:agustinmista/nixcaps";
		nixpkgs.follows = "nixcaps/nixpkgs";
		flake-parts.url = "github:hercules-ci/flake-parts";
		import-tree.url = "github:denful/import-tree";
	};
	outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
		imports = [ (inputs.import-tree ./modules) ];
		systems = [ "x86_64-linux" ];
	};
}
