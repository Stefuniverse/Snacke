extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreLabel.text = "Final Score \n" + str(GameState.get_score())
	%RestartButton.grab_focus()
	%RestartButton.button_up.connect(restart)
	%MainMenuButton.button_up.connect(main_menu)
	%QuitButton.button_up.connect(quit)

func restart() -> void:
	GameState.set_game_state(Enums.GAME_STATE.PLAYING)
	
func main_menu() -> void:
	GameState.set_game_state(Enums.GAME_STATE.MENU)

func quit() -> void:
	get_tree().quit()
