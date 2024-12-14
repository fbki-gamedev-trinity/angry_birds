extends Node2D

#
# Отслеживание количества противников и выигрывание/проигрывание
#
var enemy_count = 0

func track_enemy(enemy: Node2D):
	enemy_count += 1
	
func track_enemy_defeated(enemy: Node2D):
	enemy_count -= 1
	
	if enemy_count == 0:
		await get_tree().create_timer(3).timeout
		$GameOver.invoke("Победа!")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if $Sling.shots == 0:
		await get_tree().create_timer(3).timeout
		$GameOver.invoke("Поражение!")


func _on_playable_area_body_exited(body: Node2D) -> void:
	if body == $BirbFactory.active_birb:
		await get_tree().create_timer(3).timeout
		$BirbFactory.remove_bird()
