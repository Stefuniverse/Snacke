extends MenuButton


# Called when the node enters the scene tree for the first time.
func _ready():
	
	self.get_popup().allow_search = false

	self.get_popup().add_item("Einfach", 1)
	self.get_popup().add_item("Mittel", 2)
	self.get_popup().add_item("Schwer", 3)
	
	self.get_popup().connect("id_pressed", self._startGame)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _startGame(id):
	GameState.SetGameDifficulty(id)
	GameState.SetGameState(Enums.GAME_STATE.PLAYING)
