extends Area2D

class_name fireBall

@export var speed: float = 300
var direction := 1  

func _process(delta):
	position.x += speed * direction * delta

	# Se sair da tela, some
	if position.x < -1000 or position.x > 2000:
		queue_free()

func _on_area_entered(area):
	if area is Enemy:
		area.die_from_hit()
		queue_free()
