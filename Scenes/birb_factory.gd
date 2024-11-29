extends Node2D

@export var Birb: PackedScene = preload("res://Scenes/bird.tscn")

func fire_bird(origin, vector):
		var birb:RigidBody2D = Birb.instantiate()
		birb.global_position = origin
		birb.linear_velocity = vector
		add_child(birb)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		pass
