extends Control
var includeUtils = preload("res://scripts/utils.gd")
var utils = includeUtils.new()
var input_box_texture = load("res://assets/inputbox.png")

@export var n_walk_til_awnser = 4

var player1_percentage = 0
var player2_percentage = 0

var rng = RandomNumberGenerator.new()

var rd_walk_til_answer = []
var orig_pos = utils.bottom_bar_pos_y
var max_pos  = utils.top_bar_pos_y
var onNextAnswer = 0

var question_n = 0
var round = 0
var w_counted = 0

var json = JSON.new()
var qna_json_file = "res://qna.json"

var qna_dict = qna_info()
var qna_round = [qna_dict["ROUND_1"],qna_dict["ROUND_2"]]

@onready var timer_ticking_sound = $"../timer_end"
@onready var main_anim = $main_anim
signal dumb_sig
var tts_stopped = 1
@export var onShowResult = 0
func _ready():
	for x in range(0,4): rd_walk_til_answer.append(rng.randi_range(0,100))
	rd_walk_til_answer.append(qna_round[round][question_n]["answer"])
	$margin_que/question.text = qna_round[round][question_n]["question"]
	
func qna_info():
	var ERR = json.parse(FileAccess.get_file_as_string(qna_json_file))
	if ERR == OK: return json.data
	else: print("Something went badly while parsing the JSON file: ", json.get_error_message())

func decide_who_wins():
	var mismatch_p1 = abs(player1_percentage-qna_round[round][question_n]["answer"])
	var mismatch_p2 = abs(player2_percentage-qna_round[round][question_n]["answer"])
	print(question_n," ", mismatch_p1," ", mismatch_p2," ",qna_round[round][question_n]["answer"])
	if mismatch_p1 < mismatch_p2:
		utils.player_1_pts += 1
		$tickboxes_cnt_1.get_child(utils.player_1_pts-1).show()
		print("player 1 wins")
	else:
		utils.player_2_pts += 1
		$tickboxes_cnt_2.get_child(utils.player_2_pts-1).show()
		print("player 2 wins")	
	question_n += 1
func show_result():
	var pos = utils.percentage_to_val(max_pos,orig_pos,rd_walk_til_answer[w_counted])
	var perc = round(utils.val_to_percentage(max_pos,orig_pos,$panel_3.position.y)*100)
	$Secondarybar.scale.y = utils.percentage_to_val(0.52,0.03,perc)
	$panel_3.position.y = lerpf($panel_3.position.y,pos,get_process_delta_time()*2)
	$panel_3/res_lbl.text = str(perc)+"%"
	if (w_counted <= n_walk_til_awnser-1) and (perc == rd_walk_til_answer[w_counted]): w_counted+=1
	elif (w_counted == n_walk_til_awnser) and (perc == qna_round[round][question_n]["answer"]):
		main_anim.play("tick_box_for_player")

		onShowResult = 0
		set_process(!is_processing())
		
		
func _process(delta):
	player1_percentage = $panel_1.playerX_percentage
	player2_percentage = $panel_2.playerX_percentage
	#print($panel_1/timer_1.time_left, " ", $panel_2/timer_2.time_left)
	var both_player_locked = $panel_1.locked and $panel_2.locked
	if both_player_locked:
		
		if tts_stopped:
			tts_stopped=0
			main_anim.stop()
			timer_ticking_sound.play(10.0)
			
	if onShowResult:
		show_result()
		
	if onNextAnswer:
		resetPanels(delta)
		$margin_que/question.text = qna_round[round][question_n]["question"]
		if (int($panel_3.position.y) == orig_pos-1) and (int(player1_percentage) == 0):
			dumb_sig.emit()
			onNextAnswer=0
	timer_ticking()
func timer_ticking():
	if !$panel_1/timer_1.is_stopped():
		$timer_panel.get_child(int(11-$panel_1/timer_1.time_left)).hide()
	if !$panel_2/timer_2.is_stopped():
		$timer_panel2.get_child(int(11-$panel_2/timer_2.time_left)).hide()
func resetPanels(delta):
		
	$panel_1.playerX_percentage = lerpf(player1_percentage,0.0,delta*3)
	$panel_2.playerX_percentage = lerpf(player2_percentage,0.0,delta*3)
	$panel_3.position.y = lerp($panel_3.position.y, orig_pos, delta*4)
	var perc = round(utils.val_to_percentage(max_pos,orig_pos,$panel_3.position.y)*100)
	$Secondarybar.scale.y = utils.percentage_to_val(0.52,0.03,perc)
	$panel_3/res_lbl.text = str(perc)+"%"
	$panel_1/input_box_sprite_p1.texture = input_box_texture
	$panel_2/input_box_sprite_p1.texture = input_box_texture

func show_timer():
	$timer_panel.show()
	$timer_panel2.show()
	for z in range(0,10):
		$timer_panel.get_child(z).show()
		$timer_panel2.get_child(z).show()
func _on_next_pressed():
	set_process(!is_processing())
	onNextAnswer = 1
	$panel_3/answer_box.hide()
	$panel_3/res_lbl.hide()
	if utils.player_1_pts == 3 or utils.player_2_pts == 3:
		round = 1
		question_n = 0
	for x in range(0,4): rd_walk_til_answer[x] = rng.randi_range(0,100)
	rd_walk_til_answer[4] = qna_round[round][question_n]["answer"]
	$panel_1.locked = 0
	$panel_2.locked = 0
	w_counted=0


func _on_start_timer_pressed():
	set_process(!is_processing())
	main_anim.play("timer_ticking")
	#timer_ticking_sound.play()
	tts_stopped = 1
	
func _on_ans_pressed():
	main_anim.play("answer_holding")
	
func start_timer():
	$panel_1/timer_1.start()
	$panel_2/timer_2.start()
	
func _stop_proc():
	set_process(!is_processing())
