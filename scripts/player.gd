extends Control

var includeUtils = preload("res://scripts/utils.gd")
var utils = includeUtils.new()
@onready var playerX_percentage = 0
var inp = ""
var locked = 0
@export var keyINCR: Key
@export var keyDCR: Key
@export var keyLOCK: Key
@export var timer: Timer
@onready var panel = $"."
@onready var panel_label = panel.get_child(0)
@onready var panel_label_sprite = panel.get_child(1)
var bottom_pos = utils.bottom_bar_pos_y
var top_pos = utils.bottom_bar_pos_y

func _ready():
	print(panel.get_child(1))
	timer.start(10)

func _process(delta):
	panel_label.text = str(int(playerX_percentage))+"%"
	if not locked:
		if Input.is_key_pressed(keyINCR):playerX_percentage += 0.34
		if Input.is_key_pressed(keyDCR): playerX_percentage -= 0.34
		playerX_percentage = clamp(playerX_percentage,0,100)
		panel.position.y = utils.percentage_to_posY(30,440,playerX_percentage)
	if Input.is_key_pressed(keyLOCK) or timer.time_left == 0:
		timer.stop()
		panel_label_sprite.texture = load("res://assets/rightbox.png")
		locked = 1
func _on_counting_down_b_4_ded_timeout():
	pass
