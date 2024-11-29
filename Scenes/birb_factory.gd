extends Node2D

@export var Birb: PackedScene = preload("res://Scenes/bird.tscn")
var active_birb:Node2D

func fire_bird(origin, vector):
		var birb:RigidBody2D = Birb.instantiate()
		birb.global_position = origin
		birb.linear_velocity = vector
		print("Fire with", vector.length(), "velocity")
		add_child(birb)
		
		active_birb = birb

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_birb:
			$"../Camera2D".position = active_birb.global_position
