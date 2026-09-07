extends Node

var selected_team_index: int = 0
var current_round_index: int = 0
var kicks_taken: int = 0
var goals_scored: int = 0
var kicks_per_round: int = 5
var goals_needed_to_advance: int = 3

var round_difficulty_settings: Array = [
	{"keeper_error_range": 220.0, "keeper_dive_duration": 0.85, "keeper_reach_radius": 120.0},
	{"keeper_error_range": 170.0, "keeper_dive_duration": 0.75, "keeper_reach_radius": 120.0},
	{"keeper_error_range": 120.0, "keeper_dive_duration": 0.65, "keeper_reach_radius": 125.0},
	{"keeper_error_range": 80.0, "keeper_dive_duration": 0.55, "keeper_reach_radius": 130.0},
	{"keeper_error_range": 40.0, "keeper_dive_duration": 0.45, "keeper_reach_radius": 135.0}
]

var opponent_keeper_colors: Array = [
	Color8(60, 60, 60),
	Color8(120, 40, 40),
	Color8(30, 40, 110),
	Color8(120, 90, 20),
	Color8(20, 90, 70)
]

func start_new_tournament() -> void:
	current_round_index = 0
	reset_round()

func reset_round() -> void:
	kicks_taken = 0
	goals_scored = 0

func get_current_difficulty() -> Dictionary:
	var clamped_index: int = min(current_round_index, round_difficulty_settings.size() - 1)
	return round_difficulty_settings[clamped_index]

func get_opponent_color() -> Color:
	var clamped_index: int = min(current_round_index, opponent_keeper_colors.size() - 1)
	return opponent_keeper_colors[clamped_index]

func register_kick_result(scored: bool) -> void:
	kicks_taken += 1
	if scored:
		goals_scored += 1

func is_round_complete() -> bool:
	return kicks_taken >= kicks_per_round

func did_advance() -> bool:
	return goals_scored >= goals_needed_to_advance

func is_tournament_complete() -> bool:
	return current_round_index >= round_difficulty_settings.size() - 1

func advance_round() -> void:
	current_round_index += 1
	reset_round()
