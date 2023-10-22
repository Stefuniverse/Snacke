# Collection class for signals sent between the games main systems
extends Node

signal item_consumed(item_type: String, score_value: int)
signal score_updated(score: int)
signal snake_died(game_state: Enums.GAME_STATE)
signal new_move(direction: Enums.DIRECTION)
signal game_paused(paused: bool)
