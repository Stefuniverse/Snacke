extends Node

const Enums = preload("res://Utils/enums.gd")

var _difficulty : int = Enums.GAME_DIFFICULTY.EASY :
	set = set_game_difficulty,
	get = get_game_difficulty
var _state : int = Enums.GAME_STATE.MENU :
	set = set_game_state,
	get = get_game_state
var _last_pressed_direction : int = Enums.DIRECTION.LEFT :
	set = set_last_pressed_direction,
	get = get_last_pressed_direction
var _last_move : int = Enums.DIRECTION.LEFT
var _time_since_last_move : float = 0.0
var _last_input_action : String
var _paused: bool = false

var score: int = 0 :
	set = set_score,
	get = get_score

var _current_scene_file: String = ""

var move_frequency : float = 1
var difficulty_dict: Dictionary = {Enums.GAME_DIFFICULTY.EASY: 1,
 Enums.GAME_DIFFICULTY.MEDIUM: 2,
 Enums.GAME_DIFFICULTY.HARD: 3}

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	Signals.item_consumed.connect(update_score)
	Signals.snake_died.connect(set_game_state)

func _process(delta: float) -> void:
	if _paused:
		return
	_time_since_last_move += delta
	
	# Move and change direction after fixed time steps
	if _time_since_last_move > 1.0/move_frequency:
		_time_since_last_move = 0
		_last_move = _last_pressed_direction
		Signals.new_move.emit(_last_pressed_direction)
	
	# Snake goes faster if same direction input is held
	elif _time_since_last_move > 0.5/move_frequency && \
	_last_input_action != "" && \
	 action_to_direction(_last_input_action) == _last_move && \
	 Input.is_action_pressed(_last_input_action):
		_time_since_last_move = 0
		_last_move = _last_pressed_direction
		Signals.new_move.emit(_last_pressed_direction)

func _input(event):
	if event.is_action_pressed("down") && _last_move != Enums.DIRECTION.UP:
		_last_pressed_direction = Enums.DIRECTION.DOWN
		_last_input_action = "down"
	if event.is_action_pressed("up") && _last_move != Enums.DIRECTION.DOWN:
		_last_pressed_direction = Enums.DIRECTION.UP
		_last_input_action = "up"
	if event.is_action_pressed("left") && _last_move != Enums.DIRECTION.RIGHT:
		_last_pressed_direction = Enums.DIRECTION.LEFT
		_last_input_action = "left"
	if event.is_action_pressed("right") && _last_move != Enums.DIRECTION.LEFT:
		_last_pressed_direction = Enums.DIRECTION.RIGHT
		_last_input_action = "right"
	
	if event.is_action_released("pause"):
		if _paused == false:
			set_game_state(Enums.GAME_STATE.PAUSED)
		else:
			set_game_state(Enums.GAME_STATE.PLAYING)

func set_game_difficulty(difficulty : Enums.GAME_DIFFICULTY) -> void:
	_state = difficulty
	move_frequency = difficulty_dict.get(difficulty)
	
func get_game_difficulty() -> Enums.GAME_DIFFICULTY:
	return _difficulty as Enums.GAME_DIFFICULTY
	
func set_game_state(state : Enums.GAME_STATE) -> void:
	_state = state
	if _state == Enums.GAME_STATE.MENU:
		_current_scene_file = "res://Scenes/MainMenu/MainMenu.tscn"
		get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
	elif _state == Enums.GAME_STATE.PLAYING:
		_paused = false
		var play_scene: String = "res://Scenes/PlayingField/PlayingField.tscn"
		Signals.game_paused.emit(false)
		if _current_scene_file != play_scene:
			_current_scene_file = play_scene
			get_tree().change_scene_to_file(play_scene)
	if _state == Enums.GAME_STATE.PAUSED:
		_paused = true
		Signals.game_paused.emit(true)
	if _state == Enums.GAME_STATE.GAME_OVER:
		_current_scene_file = "res://Scenes/GameOver/GameOver.tscn"
		get_tree().change_scene_to_file("res://Scenes/GameOver/GameOver.tscn")
	
func get_game_state() -> Enums.GAME_STATE:
	return _state as Enums.GAME_STATE
	
func get_last_pressed_direction() -> Enums.DIRECTION:
	return _last_pressed_direction as Enums.DIRECTION

func set_last_pressed_direction(direction: Enums.DIRECTION) -> void:
	_last_pressed_direction = direction

func get_score() -> int:
	return score

func set_score(new_score: int) -> void:
	score = new_score
	
func update_score(_item_kind: String, value: int) -> void:
	score += value
	Signals.score_updated.emit(score)

func action_to_direction(action: String) -> Enums.DIRECTION:
	if action == "down":
		return Enums.DIRECTION.DOWN
	if action == "up":
		return Enums.DIRECTION.UP
	if action == "left":
		return Enums.DIRECTION.LEFT
	if action == "right":
		return Enums.DIRECTION.RIGHT
	else:
		return Enums.DIRECTION.LEFT
