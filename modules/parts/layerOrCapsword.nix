{ config, ... }: {
	parts.layerOrCapsword = layer: let
		key = "CKC_LAYER_OR_CAPSWORD_${layer}";
	in {
		_m = {
			inherit key;
			config = {
				capsword.enable = true;
				enums.customKeycodes = [ key ];
				functions.process_record_user.body."layerOrCapsword${layer}" = /* c */ ''
					static uint8_t held = 0;
					if (keycode == ${key}) {
						if (record->event.pressed) {
							held++;
							if (held == 1) {
								layer_on(${config.parts.layerVar layer});
							} else if (held == 2) {
								caps_word_toggle();
							}
						} else {
							held--;
						}
						return false;
					}
				'';
			};
		};
		inherit key;
	};
}
