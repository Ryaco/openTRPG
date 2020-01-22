extends Node

class DiceResult:
	var dice := 1
	var sides := 20
	var rolled := []
	var sum := 0
	
	func _init(n, s) -> void:
		dice = n
		sides = s
		roll()
	
	func roll() -> int:
		rolled = []
		sum = 0
		
		for i in dice:
			var n = randi() % (sides - 1) + 1
			rolled.append(n)
			sum += n
			
		rolled.sort()
		return sum
	
	func max_roll() -> int:
		return dice * sides
	
	func average() -> float:
		return ((sides + 1) / 2.0) *  dice

func roll(n = 1, s = 20) -> DiceResult:
	return DiceResult.new(n, s)