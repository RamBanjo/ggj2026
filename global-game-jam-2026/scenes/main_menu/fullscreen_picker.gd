extends OptionButton

func _ready() -> void:
	if GameOptions.fullscren_mode:
		select(0)
	else:
		select(1)
		
func _on_item_selected(index: int) -> void:
	var is_full = index == 0
	
	GameOptions.set_fullscreen_status(is_full)
	GameOptions.save_screen_settings(GameOptions.current_resolution , is_full)
