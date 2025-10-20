extends Area2D
class_name Enemy

const POINTS_LABEL_SCENE = preload("res://Cenas/points_label.tscn")

@export var horizontal_speed = 20
@export var vertical_speed = 100

@onready var ray_cast_2d2 = $RayCast2D2 as RayCast2D
@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

var is_dead = false
var direction := -1  

func _process(delta):
	position.x -= horizontal_speed * delta
	
	if !ray_cast_2d.is_colliding():
		position.y += vertical_speed * delta
	

func die():
	if is_dead:
		return
	is_dead = true
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")
	

func die_from_hit():
	if is_dead:
		return
	is_dead = true

	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	rotation_degrees = 100
	horizontal_speed = 0
	vertical_speed = 0

	spawn_points_label() 

	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(0, -25), 0.2)
	die_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
	die_tween.tween_callback(func(): queue_free())


func spawn_points_label():
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	Globals.score += 100


func _on_area_entered(area):
	if area is Koopa and (area as Koopa).in_a_shell and (area as Koopa).horizontal_speed != 0:
		die_from_hit()
