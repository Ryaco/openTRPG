extends Node2D
class_name Unit

signal moved(move_data)

export(Vector2) var placement := Vector2.ZERO
export(Resource) var stat_block : Resource

var _move_tween : Tween
var _map


func _ready() -> void:
	if not Combat.instance.is_ready:
		yield(Combat.instance, "ready")
	_map = Combat.instance.map
	
	_move_tween = Tween.new()
	add_child(_move_tween)
	
	position = _map.map_to_world(placement)
	update()
	randomize()
	random_move()


func move_direction(direction : Vector2, time : float) -> void:
	if _map.directions(placement).has(direction):
		var destination = _map.map_to_world(placement + direction)
		
		_move_tween.interpolate_property(
				self, "position", position, destination,
				time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		_move_tween.start()
		
		yield(_move_tween, "tween_completed")
		placement += direction
		emit_signal("moved", [placement - direction, placement])


func random_move():
	var timer := Timer.new()
	timer.one_shot = true

	timer.process_mode = Timer.TIMER_PROCESS_PHYSICS
	
	add_child(timer)
	
	while true:
		timer.start(randf() * 5.0)
		yield(timer, "timeout")
		var directions = _map.directions(placement)
		directions.shuffle()
		
		yield(move_direction(directions[0], 0.5), "completed")

