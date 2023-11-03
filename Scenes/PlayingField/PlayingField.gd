class_name PlayingField extends Node2D

@export var initial_snake_length : int = 3
@onready var tile_map: TileMap = $TileMap

var tile_size: Vector2
var field_tile_extents: Rect2
var snake: Snake

var apple_scene: PackedScene = load("res://Scenes/GameItems/Apple.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_size = tile_map.tile_set.tile_size as Vector2
	field_tile_extents = _calculate_field_tile_extents(tile_map)
	var spawn_position: Vector2 = get_random_tile_position(tile_map, initial_snake_length)
	var initial_direction: Vector2 = get_random_direction()
	_initialize_snake(initial_snake_length, spawn_position, initial_direction)
	_spawn_consumable("apple")
	Signals.score_updated.connect(_update_score_hud)
	Signals.item_consumed.connect(_spawn_consumable)
	Signals.game_paused.connect(_toggle_pause_screen)
	
# Creates a new instance of the snake and spawns it into the scene
func _initialize_snake(length: int, pos: Vector2, dir) -> void:
	snake = Snake.new(length, dir, pos, self)
	GameState.set_last_pressed_direction(VectorUtils.vector_to_direction(dir))
	add_child(snake)

func _spawn_consumable(item_type: String = "", _item_value: int = 0):
	var item : Node2D = null
	if item_type == "apple":
		item = apple_scene.instantiate()
	if item == null:
		return
	var spawn_position: Vector2 = get_random_tile_position(tile_map, 1)
	for snake_part in snake.snake_parts:
		if spawn_position == snake_part.global_position:
			_spawn_consumable(item_type)
			return
	add_child(item)
	item.position = spawn_position

func _update_score_hud(score: int):
	$Score.text = "Score: " + str(score)

func _toggle_pause_screen(paused: bool) -> void:
	if paused:
		$Pause.visible = true
		$Pause.get_node("VBoxContainer/ResumeButton").grab_focus()
	else:
		$Pause.visible = false

# Calculates the extents of the playing field
# with the tilemap which represents the playing field in the game scene
func _calculate_field_tile_extents(map: TileMap) -> Rect2:
	var rect: Rect2i = map.get_used_rect()
	
	var up_left_corner: Vector2 = map.map_to_local(Vector2i(rect.position.x, rect.position.y))
	var lower_right_corner: Vector2 = map.map_to_local(Vector2i(rect.end.x, rect.end.y))
	
	# Correct from tile center to top left corner position
	up_left_corner -= tile_size/2
	lower_right_corner -= tile_size/2
	
	# Rect2 with position and size
	return Rect2(up_left_corner, lower_right_corner - up_left_corner)

func get_tile_size() -> Vector2:
	return tile_size

func get_random_tile_position(map: TileMap, spawn_edge_margin: int) -> Vector2:
	var rect: Rect2i = map.get_used_rect()
	
	var rand: RandomNumberGenerator = RandomNumberGenerator.new()
	var pos_x: int = rand.randi_range(rect.position.x + spawn_edge_margin, rect.end.x - 1 - spawn_edge_margin)
	var pos_y: int = rand.randi_range(rect.position.y + spawn_edge_margin, rect.end.y - 1 - spawn_edge_margin)
	
	return map.map_to_local(Vector2i(pos_x, pos_y))

func get_random_direction() -> Vector2:
	var directions: Array[Vector2] = [Vector2(-1,0),Vector2(1,0),Vector2(0,1),Vector2(0,-1)]
	var rand: RandomNumberGenerator = RandomNumberGenerator.new()
	return directions[randi_range(0,directions.size() - 1)]
	
	

