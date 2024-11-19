extends RigidBody2D


@export var max_health: int = 100
var health: int

func _ready() -> void:
	health = max_health
	add_to_group("pigs")
	$AnimatedSprite2D.play("default")

func apply_damage(force: float) -> void:
	var damage = force
	health -= damage

	if health <= 0:
		destroy_block()
	else:
		update_animation()

func update_animation() -> void:
	var health_percentage = health / max_health

	print_debug(health, ' ', max_health, ' ', health_percentage)
	if health_percentage <= 0.33:
		change_animation("heavily_damaged")
	elif health_percentage <= 0.66:
		change_animation("damaged")
	else:
		change_animation("default")

func change_animation(animation_name: String):
	$AnimatedSprite2D.play(animation_name)

func destroy_block():
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		if body is RigidBody2D:
			var collision_force = body.linear_velocity.length() * body.mass
			print_debug('pig', collision_force)
			apply_damage(collision_force)
