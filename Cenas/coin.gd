extends Area2D

const POINTS_LABEL_SCENE = preload("res://Cenas/points_label.tscn")

var coins: = 100

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	
	Globals.coins += coins
	
	
