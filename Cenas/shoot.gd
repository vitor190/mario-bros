extends CharacterBody2D

class_name FireBall

@export var speed: float = 600.0 
@export var bounce_factor: float = 0.5 
@export var lifetime: float = 1.0

const GRAVITY: float = 1200.0 

var direction: int = 1
var time_alive: float = 0.0

func _ready():
	velocity = Vector2(speed * direction, 0)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	

	var collision = move_and_collide(velocity * delta)
	
	if collision:
		var normal: Vector2 = collision.get_normal()
		
		velocity = velocity.bounce(normal) * bounce_factor

	time_alive += delta
	if time_alive >= lifetime:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.die_from_hit()
		queue_free()
