extends Control

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func start_clicked() -> void:
	get_tree().change_scene_to_file("res://Scenes/level1.tscn")
