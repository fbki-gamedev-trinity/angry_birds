extends StaticBody2D

@onready var draggable:Polygon2D = $Draggable
@onready var draggable_base = draggable.position
@onready var rope_a:Line2D = $RopeA

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			var launch_vector = draggable_base - get_local_mouse_position()
			
			$"../BirbFactory".fire_bird(get_global_mouse_position(), launch_vector*10)

# Обработка непрерывного ввода
# TODO: Привязать верёвки к точкам корзины?
# TODO: Проверять что мышь вблизи корзины
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_mouse = get_local_mouse_position()
		var vec = local_mouse - draggable_base
		
		vec = vec.limit_length(100)
		draggable.position = draggable_base + vec
		draggable.rotation = atan2(vec.y, vec.x) - PI
		
		rope_a.points[1] = draggable_base + vec
	else:
		draggable.position = draggable_base
		rope_a.points[1] = draggable_base
