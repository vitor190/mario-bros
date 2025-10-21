extends Control
@onready var coins_counter = $container/coins_container/coins_counter as Label
@onready var timer_counter = $container/timer_container/timer_counter as Label
@onready var score_counter = $container/score_container/score_counter as Label
@onready var clock_timer = $clock_timer as Timer

var minutes = 0
var seconds = 0

@export_range(0,5) var defadult_minutes: =2
@export_range(0,59) var defadult_seconds: =0

signal time_is_up()

func _ready():
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	timer_counter.text = str("%02d" % defadult_minutes) + ":" + str("%02d" % defadult_seconds)
	reset_clock_timer()
	connect("time_is_up", Callable(self, "_on_time_is_up"))
	
func _process(delta):
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	
	if minutes == 0 and seconds == 0:
		emit_signal("time_is_up")
	
func _on_clock_timer_timeout():
	if seconds == 0:
		if minutes > 0:
			minutes -= 1
			seconds = 60
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clock_timer():
	minutes = defadult_minutes
	seconds = defadult_seconds
	
func _on_time_is_up():
	Globals.score = 0
	Globals.coins = 0
	
	score_counter.text = str("%06d" % Globals.score)
	coins_counter.text = str("%04d" % Globals.coins)
	
	get_tree().reload_current_scene()
