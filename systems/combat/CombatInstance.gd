extends Node
class_name CombatInstance

# Note: we will be adding Custom Map imports later in the dev process
# 		for now we will be using a hard coded map

onready var map := $BattleMap
onready var camera : BattleCamera
var is_ready := false

func _enter_tree() -> void:
	if Combat.instance:
		queue_free()
		return
		
	Combat.instance = self


func _exit_tree() -> void:
	Combat.instance = null


func _ready() -> void:
	camera = Combat.pref_camera.new()
	add_child(camera, true)
	camera._map = $BattleMap
	is_ready = true