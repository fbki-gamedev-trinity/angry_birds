extends Camera2D

@onready var birb_factory = $"../BirbFactory"
@export var scroll_locked:bool = false # Блокировка прокрутки

var last_mouse = Vector2(0, 0)

func _ready() -> void:
	pass

# Камера сопровождает активную птичку, если она есть
# Иначе прокручивается по дельтам мыши
func _process(delta: float) -> void:
	var now_mouse = get_global_mouse_position()
	var delta_mouse = now_mouse - last_mouse
	
	if birb_factory.active_birb:
		self.position = birb_factory.active_birb.position
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and not scroll_locked:
		self.position -= delta_mouse
		
	last_mouse = now_mouse
