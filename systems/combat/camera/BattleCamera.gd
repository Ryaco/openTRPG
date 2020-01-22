extends Camera2D
class_name BattleCamera

var _map : BattleMap
var _tween : Tween = null
var _locked := false


func _ready() -> void:
	var tween := Tween.new() as Tween
	add_child(tween)
	_tween = tween
	current = true
	
	if not Combat.instance.is_ready:
		yield(Combat.instance, 'ready')
	
	_map = Combat.instance.map


func _clamp_position() -> void:
	if _map:
		position = _map.clamp_world_position(position)



func move_to(placement : Vector2, pps : float, caller : String) -> void:
	if _locked or not _tween or not _map:
		return
		
		
	var time = (_map.map_to_world(placement) - position).length() / pps
	_locked = true
	
	_tween.interpolate_property(self, 'position', position, _map.map_to_world(placement), time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	_tween.start()
	
	yield(_tween, "tween_completed")
	_locked = false