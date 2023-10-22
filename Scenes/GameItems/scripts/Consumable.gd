extends Node2D
class_name Consumable

var item_type: String = "consumable"
var score_value: int = 0

func _init() -> void:
	add_to_group("consumable")

func consume():
	Signals.item_consumed.emit(item_type, score_value)
	queue_free()
