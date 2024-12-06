extends Camera2D

@onready var birb_factory = $"../BirbFactory"
@export var scroll_locked:bool = false # Блокировка прокрутки

@onready var viewport_width = self.get_viewport_rect().size.x
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
	
	# Не давать заезжать в мертвые зоны прокрутки
	if self.position.x < self.limit_left + viewport_width/2:
		self.position.x = self.limit_left + viewport_width/2
		
	if self.position.x > self.limit_right - viewport_width/2:
		self.position.x = self.limit_right - viewport_width/2

	last_mouse = now_mouse
	
	# Тащить за камерой меню паузы 😧
	$"../PauseMenu".position = get_screen_center_position() - get_viewport_rect().size/2
	$"../GameOver".position = get_screen_center_position() - get_viewport_rect().size/2
	
