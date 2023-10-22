extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%ResumeButton.button_up.connect(resume)
	%MainMenuButton.button_up.connect(main_menu)
	%QuitButton.button_up.connect(quit)

func resume() -> void:
	GameState.set_game_state(Enums.GAME_STATE.PLAYING)
	
func main_menu() -> void:
	GameState.set_game_state(Enums.GAME_STATE.MENU)

func quit() -> void:
	get_tree().quit()
