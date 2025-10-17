extends Control


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://Cenas/main.tscn")


func _on_credits_btn_pressed():
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
