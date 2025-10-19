extends Node

@onready var player := $Player as CharacterBody2D
@onready var camera := $Camera2D as CharacterBody2D
@onready var control = $HUD/control

func _ready() -> void:
	player.follow_camera(camera)
	control.time_is_up.connect()
	
	
