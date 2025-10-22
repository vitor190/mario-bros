extends Area2D

@export var win_scene_path: String = "res://Cenas/win_screen.tscn"

func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file(win_scene_path)
