extends Area2D

func _on_body_entered(body: Node2D) -> void:
	
	if body is Player:
		body.small_to_big()
		
		queue_free()
