extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.get_popup().allow_search = false

	self.get_popup().add_item("Einfach", 0)
	self.get_popup().add_item("Mittel", 1)
	self.get_popup().add_item("Schwer", 2)
	
	self.get_popup().id_pressed.connect(self._start_game)
	self.grab_focus()

	
func _start_game(id):
	GameState.set_game_difficulty(id)
	GameState.set_game_state(Enums.GAME_STATE.PLAYING)
