extends Node

const Enums = preload("res://Utils/enums.gd")

var _difficulty : int = Enums.GAME_DIFFICULTY.EASY
var _state : int = Enums.GAME_STATE.MENU

func SetGameDifficulty(difficulty : Enums.GAME_DIFFICULTY) -> void:
	self._state = difficulty
	
func GetGameDifficulty() -> Enums.GAME_DIFFICULTY:
	return self._difficulty
	
func SetGameState(state : Enums.GAME_STATE) -> void:
	self._state = state
	if self._state == Enums.GAME_STATE.MENU:
		get_tree().change_scene_to_file("res://Scenes/MainMenu/MainMenu.tscn")
	elif self._state == Enums.GAME_STATE.PLAYING:
		get_tree().change_scene_to_file("res://Scenes/MainGame/MainGame.tscn")
	if self._state == Enums.GAME_STATE.PAUSED:
		get_tree().change_scene_to_file("res://Scenes/Pause/Pause.tscn")
	
func GetGameState() -> Enums.GAME_STATE:
	return self._state

