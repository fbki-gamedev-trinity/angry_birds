extends StaticBody2D

@onready var draggable_base = $Draggable.position
@onready var camera = $"../Camera2D"
@onready var birb_factory = $"../BirbFactory"
@onready var bird:Node2D = $Bird
@onready var shots = 3

var taking_input:bool = false

func _ready() -> void:
	pass

# Детектировать отпускание левой кнопки мыши
# и запускать птичку, если рогатка натянута
func _unhandled_input(event: InputEvent) -> void:
	if event.is_echo():
		return

	if event is InputEventMouseButton and event.is_released() and taking_input:
		if event.button_index == MOUSE_BUTTON_LEFT:
			var launch_vector = draggable_base - $Draggable.position
			
			birb_factory.fire_bird(bird.global_position, launch_vector*10)

# Предсказать траекторию полёта
func plot_trajectory(vec):
	var gravity = Vector2(0, 11)
	var lst = []
	
	for i in range(30):
		lst.append(bird.position - vec*i + gravity*i*i/2)
		
	$Trajectory.points = lst

# Здесь:
# - Позиционирование веревок
# - Порядок отрисовки веревок
func update_rope(vec):
	$RopeBack.points[0] = draggable_base + vec
	$RopeFront.points[0] = draggable_base + vec
	
	var x:Line2D = $RopeFront
	
	if vec.y <= 0:
		$RopeFront.z_index = 0
		$RopeBack.z_index = -1
	else:
		$RopeFront.z_index = -1
		$RopeBack.z_index = 0

# Здесь:
# - Натягивание рогатки
# - Позиционирование птички
# - Контроль видимости птички
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var local_mouse = get_local_mouse_position()
		var vec = local_mouse - draggable_base
		
		if vec.length() <= 100 and shots > 0:
			taking_input = true
		
		if taking_input:
			camera.scroll_locked = true
			camera.position = self.position
			
			
			vec = vec.limit_length(100)
			
			# Добавочка чтобы сдвинуть птичку чуть вверх
			var offset = vec.rotated(PI/2).normalized()*20
			
			$Draggable.position = draggable_base + vec

			update_rope(vec)
			
			bird.position = draggable_base + vec + offset
			bird.rotation = atan2(vec.y, vec.x) - PI
			
			plot_trajectory(vec)

	else:
		bird.position = draggable_base + Vector2(0, -20)
		bird.rotation = 0
		
		$Trajectory.points = []
		
		update_rope(Vector2.ZERO)
		
		if taking_input:
			taking_input = false
			camera.scroll_locked = false
	
	# Видимость птички в рогатке и ждущих птичек
	bird.visible = birb_factory.active_birb == null and shots > 0

	$Bird_spare2.visible = shots > 2
	$Bird_spare1.visible = shots > 1
