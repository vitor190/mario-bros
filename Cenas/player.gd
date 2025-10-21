extends CharacterBody2D

class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode{
	SMALL,
	BIG,
	SHOOTING
}

signal points_scored(points: int)

const FIREBOL_SCENE = preload("res://Cenas/shoot.tscn")
const POINTS_LABEL_SCENE = preload("res://Cenas/points_label.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D as PlayerAnimatedSprite
@onready var area_collision_shape_2d = $Area2D/AreaCollisionShape2D
@onready var body_collision_shape_2d = $BodyCollisionShape2D
@onready var area_2d = $Area2D

@export_group("Locomotion")
@export var run_speed_damping = 0.5
@export var speed = 100.0
@export var jump_velocity = -350
@export_group("")

@export_group("Stomping Enemies")
@export var min_stomp_degree = 35
@export var max_stomp_degree = 145
@export var stomp_y_velocity = -150
@export_group("")

var is_transforming = false
var player_mode = PlayerMode.SMALL
var is_dead = false
var is_invulnerable = false

func _physics_process(delta):
	
	if player_mode == PlayerMode.SHOOTING and Input.is_action_just_pressed("shoot"):
		shoot()
	
	if is_transforming:
		return
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		
	animated_sprite_2d.trigger_animation(velocity, direction,player_mode)
	
	move_and_slide()
	
func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)
		
func handle_enemy_collision(enemy: Enemy):
	if enemy == null||is_dead:
		return
		
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).in_a_shell:
		(enemy as Koopa).on_stomp(global_position)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomped()
			spawn_points_label(enemy)
		else:
			die()
			
func on_enemy_stomped():
	velocity.y = stomp_y_velocity
	
func spawn_points_label(enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(100)
	
func die():
	if player_mode == PlayerMode.SMALL:
		is_dead = true
		animated_sprite_2d.play("small_death")
		set_physics_process(false)
		
		Globals.score = 0
		Globals.coins = 0
		
		if has_node("/root/Node2D/UI"):  
			var ui = get_node("/root/Node2D/UI")
			ui.score_counter.text = str("%06d" % Globals.score)
			ui.coins_counter.text = str("%04d" % Globals.coins)
		
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		death_tween.tween_callback(func(): get_tree().reload_current_scene())
		
func small_to_big():
	if player_mode == PlayerMode.SMALL and not is_transforming:
		is_transforming = true
		animated_sprite_2d.play("small_to_big")
		await animated_sprite_2d.animation_finished
		player_mode = PlayerMode.BIG
		body_collision_shape_2d.scale = Vector2(1, 2)
		is_transforming = false

func small_to_shotting():
	if player_mode == PlayerMode.SMALL and not is_transforming:
		is_transforming = true
		animated_sprite_2d.play("small_to_shooting")
		await animated_sprite_2d.animation_finished
		player_mode = PlayerMode.SHOOTING
		body_collision_shape_2d.scale = Vector2(1, 2)
		is_transforming = false
		
func big_to_shotting():
	if player_mode == PlayerMode.BIG and not is_transforming:
		is_transforming = true
		animated_sprite_2d.play("big_to_shooting")
		await animated_sprite_2d.animation_finished
		player_mode = PlayerMode.SHOOTING
		body_collision_shape_2d.scale = Vector2(1, 2)
		is_transforming = false
		
func shoot():
	
	var firebal = FIREBOL_SCENE.instantiate()
	var offset_x = 16 if animated_sprite_2d.flip_h == false else -16
	
	firebal.position = global_position + Vector2(offset_x, -10)
	firebal.direction = -1 if animated_sprite_2d.flip_h else 1
	
	get_tree().root.add_child(firebal)
	animated_sprite_2d.play("shooting")
	
	
