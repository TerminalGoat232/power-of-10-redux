extends Control

var includeUtils = preload("res://utils.gd")
var utils = includeUtils.new()
@onready var playerX_percentage = 0
var inp = ""
var locked = 0
@export var keyINCR: Key
@export var keyDCR: Key
@export var keyLOCK: Key
@onready var panel = $"."
@onready var panel_label = panel.get_child(0)
var isHovering_1 = false
var isHovering_2 = false
var styleBox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
func _ready():
	pass

func _process(delta):
	inp = int(playerX_percentage)
	panel_label.text = str(inp)+"%"
	if not locked:
		if Input.is_key_pressed(keyINCR):playerX_percentage += 0.34
		if Input.is_key_pressed(keyDCR): playerX_percentage -= 0.34
		playerX_percentage = clamp(playerX_percentage,0,100)
		panel.position.y = utils.percentage_to_posY(39,480,playerX_percentage)
	if Input.is_key_pressed(keyLOCK):
		add_theme_stylebox_override("panel",styleBox)
		locked = 1
		styleBox.set("bg_color",Color.RED)
