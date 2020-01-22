# BattleMap.gd
extends TileMap
class_name BattleMap

const DIRECTIONS_ODD_R = [
    [Vector2(1,  0), Vector2(0, -1), Vector2(-1, -1), 
     Vector2(-1,  0), Vector2(-1, 1), Vector2(0, 1)],
    [Vector2(1,  0), Vector2(1, -1), Vector2(0, -1), 
     Vector2(-1,  0), Vector2(0, 1), Vector2(1, 1)]]
const DIRECTIONS_ODD_Q = [
    [Vector2(1,  0), Vector2(1, -1), Vector2(0, -1), 
     Vector2(1,  -1), Vector2(-1, 0), Vector2(0, 1)],
    [Vector2(1,  1), Vector2(1, 0), Vector2(0, -1), 
     Vector2(-1,  0), Vector2(-1, 1), Vector2(0, 1)]]
const DIRECTIONS_SQUARE = [
	Vector2(1,0), Vector2(1,-1), Vector2(0,-1), Vector2(-1,-1),
	Vector2(-1,0), Vector2(-1,1), Vector2(0,1), Vector2(1,1)]

var _x_axis := Vector2.RIGHT
var _y_axis := Vector2.DOWN
var _origin := Vector2.ZERO

var _tracked := {}

func _ready() -> void:
	_calc_world_rect()
	
	var units = get_tree().get_nodes_in_group("Unit")
	for unit in units:
		if not _tracked.has(unit.placement):
			_tracked[unit.placement] = unit
			unit.connect("moved", self, '_on_unit_moved', [unit])
		else:
			unit.queue_free()


func add_unit(unit) -> bool:
	if _tracked.has(unit.placement) or get_children().has(unit):
		return false
	
	unit.connect("moved", self, '_on_unit_moved', [unit])
	_tracked[unit.placement] = unit
	add_child(unit)
	
	return true


func unit_at(placement : Vector2) -> Unit:
	if _tracked.has(placement):
		return _tracked[placement] as Unit
	else:
		return null


func directions(point : Vector2) -> Array:
	""" note that i am adding an empty array to make sure 
		nothing can unintentionally change the array """
	if cell_half_offset == HALF_OFFSET_X:
		return [] + DIRECTIONS_ODD_R[int(point.y) & 1]
	elif cell_half_offset == HALF_OFFSET_Y:
		return [] + DIRECTIONS_ODD_Q[int(point.x) & 1]
	else:
		return [] + DIRECTIONS_SQUARE


func euclidean(a : Vector2, b : Vector2) -> float:	
	if cell_half_offset == HALF_OFFSET_X:
		a += Vector2(int(a.y) & 1, 0) * 0.5
		b += Vector2(int(b.y) & 1, 0) * 0.5
	elif cell_half_offset == HALF_OFFSET_Y:
		a += Vector2(0, int(a.x) & 1) * 0.5
		b += Vector2(0, int(b.x) & 1) * 0.5
	
	return (a-b).length()


func manhattan(a : Vector2, b : Vector2) -> float:
	if cell_half_offset == HALF_OFFSET_DISABLED:
		return abs(a.x - b.x) + abs(a.y - b.y)
	elif cell_half_offset == HALF_OFFSET_Y:
		return max(
			abs(a.y - b.y + floor(b.x/2) - floor(a.x/2)),
			max(abs(b.y - a.y + floor(a.x/2) - floor(b.x/2) + b.x - a.x),
			abs(a.x - b.x)))
	else:
		return max(
			abs(a.x - b.x + floor(b.y/2) - floor(a.y/2)),
			max(abs(b.x - a.x + floor(a.y/2) - floor(b.y/2) + b.y - a.y),
			abs(a.y - b.y)))


func clamp_world_position(p : Vector2) -> Vector2:
	p -= _origin
	var x = Geometry.line_intersects_line_2d(p, _y_axis, Vector2.ZERO, _x_axis).x / _x_axis.x
	var y = Geometry.line_intersects_line_2d(p, _x_axis, Vector2.ZERO, _y_axis).y / _y_axis.y
	var r = _x_axis * clamp(x, 0.0, 1.0) + _y_axis * clamp(y, 0.0, 1.0)
	return r + _origin


func _calc_world_rect() -> void:
	var rect := get_used_rect()
	_origin = map_to_world(rect.position, true)
	_x_axis = map_to_world(Vector2(rect.end.x,rect.position.y),true) - _origin
	_y_axis = map_to_world(Vector2(rect.position.x,rect.end.y),true) - _origin


func _on_unit_moved(move_data, unit):
	match move_data:
		[var previous_position, var current_position]:
			if unit_at(previous_position) != unit:
				push_error("Unit no longer being tracked")
			else:
				_tracked.erase(previous_position)
			_tracked[current_position] = unit