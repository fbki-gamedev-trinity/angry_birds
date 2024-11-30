extends Node2D

@export var Birb: PackedScene = preload("res://Scenes/bird.tscn")
@export var active_birb:RigidBody2D

@onready var camera:Camera2D = $"../Camera2D"
var min_birb_velocity = 20.0
var birb_sat_unmoving = 0.0
@onready var dust_particles_scene = preload("res://Scenes/dust.tscn")

func fire_bird(origin, vector):
	
	# Запретить запуск новых птичек, пока есть активная птичка
	if active_birb:
		return

	# Активной птички нет? запускаем
	var birb:RigidBody2D = Birb.instantiate()
	birb.global_position = origin
	birb.linear_velocity = vector
	print("Fire with", vector.length(), "velocity")
	add_child(birb)
	
	birb_sat_unmoving = 0.0
	active_birb = birb

func remove_bird():
	camera.position = $"../Sling".position
	var dust_particles_instance = dust_particles_scene.instantiate()
	dust_particles_instance.global_transform.origin = global_transform.origin
	dust_particles_instance.emitting = true
	get_tree().current_scene.add_child(dust_particles_instance)
	active_birb.queue_free()
	active_birb = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_birb:
			if active_birb.linear_velocity.length() < min_birb_velocity:
				birb_sat_unmoving += delta
			else:
				birb_sat_unmoving = 0.0
				
			if birb_sat_unmoving > 5:
				remove_bird()
