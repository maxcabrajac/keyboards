{
	inputs = {
		nixcaps.url = "github:agustinmista/nixcaps";
		nixpkgs.follows = "nixcaps/nixpkgs";
		flake-utils.follows = "nixcaps/flake-utils";
	};

	outputs = {
		nixpkgs,
		flake-utils,
		nixcaps,
		...
	}: flake-utils.lib.eachDefaultSystem (
			system: let
				pkgs = nixpkgs.legacyPackages.${system};
				compile = nixcaps.packages.${system}.compile;
				lib = pkgs.lib;

				forEachSubPackage = dir: f: let
					subdirs = lib.filterAttrs (_: type: type == "directory") (builtins.readDir dir);
					subpkgs = lib.mapAttrs (name: _: pkgs.callPackage (dir + "/${name}") { }) subdirs;
				in
					builtins.mapAttrs (_: pkg: f pkg) subpkgs;
			in {
				packages = forEachSubPackage ./. compile;
			}
		);
}
