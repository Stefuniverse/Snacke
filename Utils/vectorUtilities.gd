extends Node
class_name VectorUtils

# Maps a direction Enum to a directional vector
static func direction_to_vector(direction: Enums.DIRECTION) -> Vector2:
	match direction:
		Enums.DIRECTION.DOWN:
			return Vector2(0,1)
		Enums.DIRECTION.UP:
			return Vector2(0,-1)
		Enums.DIRECTION.LEFT:
			return Vector2(-1,0)
		Enums.DIRECTION.RIGHT:
			return Vector2(1,0)
		_:
			return Vector2()

# Maps all possible angles to directions in 90 degree steps
# The mapping areas are beginning with >= in clockwise direction
static func vector_to_direction(vector: Vector2) -> Enums.DIRECTION:
	var angle: float = vector.angle()
	if angle >= PI/4 && angle < (3*PI)/4:
		return Enums.DIRECTION.DOWN
	if angle < -PI/4 && angle >= -(3*PI)/4:
		return Enums.DIRECTION.UP
	if angle < PI/4 && angle >= -PI/4:
		return Enums.DIRECTION.RIGHT
	else:
		return Enums.DIRECTION.LEFT

# Maps any vector to 90 degree steps
# The mapping areas are beginning with >= in clockwise direction
static func snap_vector_to_direction(vector: Vector2) -> Vector2:
	var angle: float = vector.angle()
	if angle >= PI/4 && angle < (3*PI)/4:
		return Vector2(0,1)
	if angle < PI/4 && angle >= -(3*PI)/4:
		return Vector2(0,-1)
	if angle >= PI/4 && angle < PI/4:
		return Vector2(1,0)
	else:
		return Vector2(-1,0)
