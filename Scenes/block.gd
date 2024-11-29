extends RigidBody2D

@export var max_health: int = 200
var health: float
var last_position = Vector2()
var fall_height = 0.0
var is_falling = false

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
	queue_free()

func _on_body_entered(body: Node) -> void:
	var impact:Vector2
	
	# Столкнулись с движущимся в противоположную сторону объектом
	# должно нанести очень много урона
	#
	# Столкнулись со статичным объектом (землёй?)
	# используем только свою скорость
	#
	if body is RigidBody2D: 
		impact = self.linear_velocity*self.mass - body.linear_velocity*body.mass
	else:
		impact = self.linear_velocity*self.mass
		
	apply_damage(impact.length())
