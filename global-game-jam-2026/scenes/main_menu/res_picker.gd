extends OptionButton

func _ready() -> void:
	var idx = 0
	for res in GameOptions.RESOLUTION_OPTIONS:
		add_item(GameOptions.get_res_as_string(res))
		
		if GameOptions.current_resolution == res:
			select(idx)
			
		idx += 1

func _on_item_selected(index: int) -> void:
	if not GameOptions.fullscren_mode:
		
		var new_size : Vector2i = GameOptions.RESOLUTION_OPTIONS[index]
		DisplayServer.window_set_size(new_size)
		
		GameOptions.save_screen_settings(new_size, GameOptions.fullscren_mode)
