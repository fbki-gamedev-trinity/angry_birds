extends RigidBody2D


@export var max_health: int = 100
var health: int
var last_position = Vector2()
var fall_height = 0.0
var is_falling = false

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
			apply_damage(collision_force)

func _integrate_forces(state) -> void:
	var current_velocity = state.get_linear_velocity()
	if current_velocity.length() > 0.01:
		if not is_falling:
			last_position = position
			is_falling = true
	else:
		if is_falling:
			fall_height = abs(last_position.y - position.y)
			if fall_height > 10:
				var fall_damage = fall_height * 0.1
				apply_damage(fall_damage)
			is_falling = false
