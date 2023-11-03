extends Node2D
class_name Snake

@export var SnakePart: PackedScene = load("res://Scenes/Snake/SnakePart.tscn")

var snake_parts: Array[Node2D]

var environment: PlayingField

var is_dead: bool = false

func _init(part_count: int, spawn_direction: Vector2, pos: Vector2, env: PlayingField) -> void:
	self.position = pos
	self.environment = env
	spawn_snake(part_count, spawn_direction)
	Signals.new_move.connect(move_snake)
	Signals.item_consumed.connect(attach_snake_part)

# Calculates the displacement of the snake for the direction given in this turn
# and calls the move method of the snakes head
func move_snake(dir: Enums.DIRECTION) -> void:
	if snake_parts.size() <= 0 || is_dead:
		return
	var displacement: Vector2 = VectorUtils.direction_to_vector(dir) * environment.get_tile_size()
	var head_position: Vector2 = snake_parts[0].global_position
	var next_head_position : Vector2 = head_position + displacement
	
	var regular_move_distance: float = environment.get_tile_size().x
	
	# Displacements for moving to the other side of the screen
	if next_head_position.x < environment.field_tile_extents.position.x:
		displacement.x = environment.field_tile_extents.end.x - head_position.x
		displacement.x -= environment.get_tile_size().x/2
	elif next_head_position.x > environment.field_tile_extents.end.x:
		displacement.x = environment.field_tile_extents.position.x - head_position.x
		displacement.x += environment.get_tile_size().x/2
	elif next_head_position.y < environment.field_tile_extents.position.y:
		displacement.y = environment.field_tile_extents.end.y - head_position.y
		displacement.y -= environment.get_tile_size().y/2
	elif next_head_position.y > environment.field_tile_extents.end.y:
		displacement.y = environment.field_tile_extents.position.y - head_position.y
		displacement.y += environment.get_tile_size().y/2
	
	snake_parts[0].move_part(displacement, regular_move_distance)
	check_collisions(snake_parts[0])

func check_collisions(snake_head: Node2D) -> void:
	for snake_part in snake_parts:
		if snake_part != snake_head && snake_part.global_position == snake_head.global_position:
			die()
	for consumable in get_tree().get_nodes_in_group("consumable"):
		if snake_head.global_position == consumable.global_position:
			consumable.consume()

func die() -> void:
	is_dead = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await timer.timeout
	Signals.snake_died.emit(Enums.GAME_STATE.GAME_OVER)
	
func spawn_snake(part_count: int, initial_direction: Vector2 = Vector2(-1,0)) -> void:
	for i in part_count:
		attach_snake_part("", 0, initial_direction)

# Attaches a new part to the snake in opposite to the initial movement direction
# or, per default, at the end of the snake and opposite to the direction the last
# snake part moved towards in the last turn
func attach_snake_part(_item_type: String = "", _item_value: int = 0,
	 initial_direction: Vector2 = Vector2(0,0)) -> void:
	var snake_part: Node2D = SnakePart.instantiate()
	var tile_size: Vector2 = environment.tile_map.tile_set.tile_size as Vector2
	add_child(snake_part)
	snake_parts.append(snake_part)
	if snake_parts.size() > 1:
		# Current tail part
		var front_part: Node2D = snake_parts[snake_parts.size() - 2]
		front_part.back_part = snake_part
		snake_part.front_part = front_part
		# Only applied on intial spawn
		if initial_direction == Vector2(0,0):
			initial_direction = round((front_part.position - front_part.previous_position).normalized())
		snake_part.position = front_part.position + (-initial_direction * tile_size)
		front_part.adjust_sprite(initial_direction, tile_size.x)
	snake_part.adjust_sprite(initial_direction, tile_size.x)
	
