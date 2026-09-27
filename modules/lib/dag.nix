{ inputs, lib, ... }: {
	_module.args.dag = inputs.dag.lib { inherit lib; };
}
