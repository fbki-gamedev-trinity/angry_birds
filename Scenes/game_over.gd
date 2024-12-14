extends Control

func invoke(text):
	$VBoxContainer/Label.text = text
	get_tree().paused = true
	show()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
