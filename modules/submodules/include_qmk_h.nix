{ dag, ... }: {
	submodules.files."keymap.c".include_qmk = dag.entryBefore [ "preambleStart" ] "#include QMK_KEYBOARD_H";
}
