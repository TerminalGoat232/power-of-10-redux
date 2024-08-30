extends Control
var game = preload("res://game.tscn").instantiate()
func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass


func _on_vo_game_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn") 
