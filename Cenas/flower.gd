extends Area2D


func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		body.small_to_shotting()
	
	if body is Player:
		body.big_to_shotting()
	
		queue_free()
