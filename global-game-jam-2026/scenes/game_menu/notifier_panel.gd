extends PanelContainer
class_name NotifierPanel

@export var closable : bool = true

@onready var title_label : Label = $VBoxContainer/HBoxContainer/Label
@onready var body_label : Label = $VBoxContainer/Label

@onready var x_close_button : TextureButton = $VBoxContainer/HBoxContainer/TextureButton
@onready var close_button : Button = $VBoxContainer/CloseButton

@export var title : String = ""
@export var body_text : String = ""
@export var button_text : String = ""

signal trigger_close

func _ready() -> void:
	
	if title != "":
		title_label.text = title
	
	if body_text != "":
		body_label.text = body_text
		
	if button_text != "":
		close_button.text = button_text
	
	x_close_button.visible = closable

func show_panel_with_text(change_title: String, change_body_text: String, change_button_text : String):
	show()
	title_label.text = change_title
	body_label.text = change_body_text
	close_button.text = change_button_text
	
func _on_close_button_pressed() -> void:
	if closable:
		hide()
	
	trigger_close.emit()
