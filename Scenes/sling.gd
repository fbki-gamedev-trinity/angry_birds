extends StaticBody2D


@onready var rope:Line2D = $Rope
@onready var draggable_base = rope.points[1]
@onready var camera = $"../Camera2D"
@onready var bird:Node2D = $Bird
var taking_input:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event is InputEventMouseButton and event.is_released() and taking_input:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var launch_vector = draggable_base - rope.points[1]
			
			$"../BirbFactory".fire_bird(rope.points[1] + rope.global_position, launch_vector*10)

# Предсказать траекторию полёта
func plot_trajectory(vec):
	var gravity = Vector2(0, 9.8)
	var lst = []
	
	for i in range(30):
		lst.append(draggable_base + vec - vec*i + gravity*i*i/2)
		
	$Trajectory.points = lst

# Обработка непрерывного ввода
func _process(delta: float) -> void:
	bird.visible = $"../BirbFactory".active_birb == null
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_mouse = get_local_mouse_position()
		var vec = local_mouse - draggable_base
		
		if vec.length() <= 100:
			taking_input = true
		
		if taking_input:
			camera.scroll_locked = true
			camera.position = self.position
			
			vec = vec.limit_length(100)
			bird.position = draggable_base + vec
			bird.rotation = atan2(vec.y, vec.x) - PI
			
			plot_trajectory(vec)
			
			rope.points[1] = draggable_base + vec
	else:
		bird.position = draggable_base
		rope.points[1] = draggable_base
		
		$Trajectory.points = []
		
		if taking_input:
			taking_input = false
			camera.scroll_locked = false
