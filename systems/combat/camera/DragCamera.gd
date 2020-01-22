extends BattleCamera
class_name DragCamera

var camera_speed := 5.0

var _dragging := false
var _last := Vector2.ZERO

func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == BUTTON_RIGHT:
		get_tree().set_input_as_handled()
		
		if event.is_pressed():
			_last = get_viewport().get_mouse_position()
			_dragging = true
		else:
			_dragging = false
			
	elif _locked:
		return
		
	elif event is InputEventMouseMotion and _dragging:
		var mouse = event.position
		position += (_last - mouse).normalized() * camera_speed
		_last = mouse
		_clamp_position()
		update()