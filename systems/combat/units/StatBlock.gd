extends Resource
class_name StatBlock

# Our three Main Stats: Spirit, Agility and Might, for now we have capped it between 0 and 5 inclusive
export(int, 0, 5) var spirit	:= 0
export(int, 0, 5) var agility 	:= 0
export(int, 0, 5) var might 	:= 0

# Our Units Level for now im using the max level of 20
export(int, 1, 20) var level	:= 1

var max_hp	:= 0 setget , _max_hp
var max_mov	:= 0 setget , _max_mov
var max_ap	:= 0 setget , _max_ap

# hp will be between 5 and 200
func _max_hp():
	max_hp = level * (5 + might)
	return max_hp

# mov will be between 5 and 8 inclusive
func _max_mov():
	max_mov =  5 + ceil(agility / 2)
	return max_mov

# ap will be between 3 and 6 inclusive
func _max_ap():
	max_ap = 3 + ceil(spirit / 2)
	return max_ap