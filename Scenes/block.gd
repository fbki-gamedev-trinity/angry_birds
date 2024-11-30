extends RigidBody2D

@export var max_health: int = 5
var last_velocity = Vector2(0, 0)
var health: float
var min_impact = 50.0
@onready var dust_particles_scene = preload("res://Scenes/dust.tscn")

func _ready() -> void:
	health = max_health
	add_to_group("blocks")
	$AnimatedSprite2D.play("default")

func apply_damage(force: float) -> void:
	var damage = force
	health -= damage

	print_debug("Damage applied: ", damage, " New health: ", health)
	if health <= 0:
		destroy_block()
	else:
		update_animation()

func update_animation() -> void:
	var health_percentage = health / max_health

	if health_percentage <= 0.25:
		change_animation("very_heavily_damaged")
	elif health_percentage <= 0.5:
		change_animation("heavily_damaged")
	elif health_percentage <= 0.75:
		change_animation("damaged")
	else:
		change_animation("default")

func change_animation(animation_name: String):
	$AnimatedSprite2D.play(animation_name)

func destroy_block():
	var dust_particles_instance = dust_particles_scene.instantiate()
	dust_particles_instance.global_transform.origin = global_transform.origin
	dust_particles_instance.emitting = true
	get_tree().current_scene.add_child(dust_particles_instance)
	queue_free()
	
# Хранить предыдущую скорость
# Пригодится когда возникнет столкновение
func _process(delta: float) -> void:
	last_velocity = self.linear_velocity

func _on_body_entered(body: Node) -> void:
	var impact:Vector2
	
	# Столкнулись с движущимся в противоположную сторону объектом
	# должно нанести очень много урона
	#
	# Столкнулись со статичным объектом (землёй?)
	# используем только свою скорость
	#
	if body is RigidBody2D: 
		impact = self.last_velocity*self.mass - body.linear_velocity*body.mass
	else:
		impact = self.last_velocity*self.mass
	
	# Логарифмическая боль
	# Всё что меньше min_impact будет проигнорировано
	var pain = log(impact.length() / min_impact)
	
	if pain > 0:
		apply_damage(pain)
