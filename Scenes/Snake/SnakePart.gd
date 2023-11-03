extends Node2D

var front_part: Node2D = null
var back_part: Node2D = null
var previous_position: Vector2
	
func move_part(displacement: Vector2, regular_move_distance: float) -> void:
	previous_position = position
	position += displacement
	if(back_part != null):
		var back_part_displacement: Vector2 = previous_position - back_part.position
		back_part.move_part(back_part_displacement, regular_move_distance)
	adjust_sprite(_teleport_to_regular_move(displacement, regular_move_distance), regular_move_distance)

func set_sprite(frame: int, angle: float = rotation) -> void:
	if frame >= $Sprite2D.hframes * $Sprite2D.vframes:
		return
	$Sprite2D.frame = frame
	$Sprite2D.rotation = angle
	
# Adjusts the sprite of a snake part to fit in with it's neighbours
func adjust_sprite(heading_direction: Vector2, regular_move_distance: float) -> void:
	# Part is head
	if (front_part == null):
		set_sprite(0, direction_to_sprite_rotation(heading_direction))
		return
	var front_direction: Vector2 = _teleport_to_regular_move(front_part.position - position, regular_move_distance).normalized()
	var front_turn_angle: float = heading_direction.angle_to(front_direction)
	# Part is tail
	if (back_part == null):
		set_sprite(3, direction_to_sprite_rotation(front_direction))
		return
	# Part is straight
	if(front_turn_angle == 0):
		set_sprite(1, direction_to_sprite_rotation(front_direction))
		return
	# Determine fitting bend sprite
	set_sprite(2, direction_to_sprite_rotation(heading_direction))
	if(front_turn_angle > 0):
		set_sprite(2, direction_to_sprite_rotation(heading_direction.normalized().rotated(deg_to_rad(-90))))
		return

# Maps the four directional Vectors right,left,down,up to the fitting rotation of
# the snake sprites. Depends on the provided sprites.
func direction_to_sprite_rotation(dir: Vector2) -> float:
	var direction: Vector2 = dir.normalized()
	if direction.is_equal_approx(Vector2(1,0)):
		return deg_to_rad(90)
	if direction.is_equal_approx(Vector2(-1,0)):
		return deg_to_rad(-90)
	if direction.is_equal_approx(Vector2(0,1)):
		return deg_to_rad(180)
	if direction.is_equal_approx(Vector2(0,-1)):
		return deg_to_rad(0)
	return 0

# If the part is teleported to the other side of the field
# this will translate the move into a regular move without teleportation.
func _teleport_to_regular_move(displacement: Vector2, regular_move_distance) -> Vector2:
	if displacement.length() <= regular_move_distance:
		return displacement
	if displacement.normalized().is_equal_approx(Vector2(-1,0)):
		return Vector2(1, 0)
	if displacement.normalized().is_equal_approx(Vector2(1,0)):
		return Vector2(-1, 0)
	if displacement.normalized().is_equal_approx(Vector2(0,-1)):
		return Vector2(0, 1)
	if displacement.normalized().is_equal_approx(Vector2(0,1)):
		return Vector2(0, -1)
	return Vector2(0,0)
