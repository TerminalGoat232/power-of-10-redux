extends Object
const top_bar_pos_y = 39
const bottom_bar_pos_y = 480
func percentage_to_posY(max,min,percentage):
	return (max-min)*(percentage)/100 + min
func posY_to_percentage(max,min,y):
	return (y-min)/(max-min)
