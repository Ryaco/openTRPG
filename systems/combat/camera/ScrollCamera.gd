extends BattleCamera
class_name ScrollCamera

export(float, 80.0, 150.0) var camera_speed := 100.0
export(float, 0.1, 0.5) var scroll_margin := 0.1

func _ready() -> void:
	drag_margin_h_enabled = false
	drag_margin_v_enabled = false


func _physics_process(delta : float) -> void:
	if _locked:
		return

	var screen_size := get_viewport().size / 2
	var mouse := (get_viewport().get_mouse_position() - screen_size) / screen_size
	var threshold := 1 - 2 * scroll_margin
	
	if abs(mouse.x) > threshold or abs(mouse.y) > threshold:
		var speed := range_lerp(max(abs(mouse.x), abs(mouse.y)), 0.7, 1.0, 0.4, 1.0)
		position += mouse.normalized() * speed * camera_speed * delta
		_clamp_position()