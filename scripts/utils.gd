extends Object
const top_bar_pos_y = 30.0
const bottom_bar_pos_y = 440.0
var player_1_pts = 0
var player_2_pts = 0
func percentage_to_posY(max,min,percentage):
	return (max-min)*(percentage)/100 + min
func posY_to_percentage(max,min,y):
	return (y-min)/(max-min)
