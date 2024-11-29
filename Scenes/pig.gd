extends RigidBody2D


@export var max_health: int = 10
var health: float
var last_position = Vector2()
var fall_height = 0.0
var is_falling = false
var min_impact = 10

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
		impact = self.linear_velocity*self.mass*100
	
	# Логарифмическая боль
	# Всё что меньше min_impact будет проигнорировано
	var pain = log(impact.length() / min_impact)
	
	if pain > 0:
		apply_damage(pain)
