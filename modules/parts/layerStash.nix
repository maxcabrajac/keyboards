{ lib, entryAt, ... }: {
	parts.layerStash = {
		_m = {
			enums.customKeycodes = [ "CKC_LAYER_STASH" ];
			files."keymap.c".layerStateVariable = entryAt "definitions" /* c */ "static layer_state_t stashed_layer_state = 0;";
			functions = {
				default_layer_state_set_user.body.layerStash = "stashed_layer_state = state;";
				process_record_user.body.layerStash = /* c */ ''
					if (keycode == CKC_LAYER_STASH) {
						if (record->event.pressed) {
							if (layer_state != default_layer_state) {
								stashed_layer_state = layer_state;
								layer_state_set(default_layer_state);
							} else {
								layer_state_set(stashed_layer_state);
							}
						}
						return false;
					}
				'';
			};
		};
		key = "CKC_LAYER_STASH";
	};
}
