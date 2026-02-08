extends OptionButton

func _ready() -> void:
	if GameOptions.show_warning:
		select(0)
	else:
		select(1)
			
func _on_item_selected(index: int) -> void:
	GameOptions.save_show_warning(index == 0)
