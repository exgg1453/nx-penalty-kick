extends Node2D

const GOAL_LEFT_X: float = 200.0
const GOAL_RIGHT_X: float = 1080.0
const GOAL_TOP_Y: float = 150.0
const GOAL_BOTTOM_Y: float = 400.0

@onready var goalkeeper: Node2D = $Goalkeeper
@onready var ball: Node2D = $Ball
@onready var joystick: Control = $Joystick
@onready var power_bar: Control = $PowerBar
@onready var round_label: Label = $HUD/RoundLabel
@onready var score_label: Label = $HUD/ScoreLabel
@onready var target_label: Label = $HUD/TargetLabel
@onready var team_label: Label = $HUD/TeamLabel
@onready var feedback_label: Label = $FeedbackLabel
@onready var result_popup: Panel = $ResultPopup
@onready var result_label: Label = $ResultPopup/VBoxContainer/ResultLabel
@onready var primary_button: Button = $ResultPopup/VBoxContainer/PrimaryButton
@onready var secondary_button: Button = $ResultPopup/VBoxContainer/SecondaryButton

var pending_aim_direction: Vector2 = Vector2.ZERO
var is_kick_in_progress: bool = false

func _ready() -> void:
	result_popup.visible = false
	feedback_label.visible = false
	joystick.aim_locked.connect(_on_aim_locked)
	power_bar.power_locked.connect(_on_power_locked)
	var team: Dictionary = TeamData.get_team(GameManager.selected_team_index)
	team_label.text = team["name"]
	team_label.add_theme_color_override("font_color", team["primary_color"])
	goalkeeper.set_kit_color(GameManager.get_opponent_color())
	_update_hud()
	_begin_aiming_phase()

func _update_hud() -> void:
	round_label.text = "Tur " + str(GameManager.current_round_index + 1) + " / " + str(GameManager.round_difficulty_settings.size())
	score_label.text = "Gol: " + str(GameManager.goals_scored) + " / " + str(GameManager.kicks_taken) + " (" + str(GameManager.kicks_per_round) + " atis)"
	target_label.text = "Gecmek icin gerekli: " + str(GameManager.goals_needed_to_advance) + " gol"

func _begin_aiming_phase() -> void:
	is_kick_in_progress = false
	power_bar.visible = false
	joystick.set_enabled(true)

func _on_aim_locked(direction: Vector2) -> void:
	if is_kick_in_progress:
		return
	pending_aim_direction = direction
	joystick.set_enabled(false)
	power_bar.visible = true
	power_bar.set_enabled(true)

func _on_power_locked(power_value: float) -> void:
	power_bar.visible = false
	_perform_kick(pending_aim_direction, power_value)

func _perform_kick(direction: Vector2, power_value: float) -> void:
	is_kick_in_progress = true
	var normalized_x: float = clamp((direction.x + 1.0) / 2.0, 0.0, 1.0)
	var normalized_y: float = clamp((-direction.y + 1.0) / 2.0, 0.0, 1.0)
	var target_x: float = lerp(GOAL_LEFT_X + 50.0, GOAL_RIGHT_X - 50.0, normalized_x)
	var target_y: float = lerp(GOAL_BOTTOM_Y - 30.0, GOAL_TOP_Y + 30.0, normalized_y)
	var target_position: Vector2 = Vector2(target_x, target_y)
	var difficulty: Dictionary = GameManager.get_current_difficulty()
	var flight_duration: float = lerp(1.1, 0.55, power_value)
	var keeper_start_x: float = goalkeeper.resting_position_x
	var error_range: float = difficulty["keeper_error_range"]
	var predicted_x: float = clamp(target_x + randf_range(-error_range, error_range), GOAL_LEFT_X, GOAL_RIGHT_X)
	var dive_duration: float = difficulty["keeper_dive_duration"]
	var keeper_progress: float = clamp(flight_duration / dive_duration, 0.0, 1.0)
	var keeper_final_x: float = lerp(keeper_start_x, predicted_x, keeper_progress)
	var reach_radius: float = difficulty["keeper_reach_radius"]
	var is_saved: bool = abs(keeper_final_x - target_x) <= reach_radius
	ball.shoot(target_position, flight_duration)
	goalkeeper.dive_to(keeper_final_x, min(dive_duration, flight_duration))
	await get_tree().create_timer(flight_duration).timeout
	_resolve_kick(is_saved)

func _resolve_kick(is_saved: bool) -> void:
	feedback_label.text = "KURTARDI!" if is_saved else "GOL!"
	feedback_label.visible = true
	GameManager.register_kick_result(not is_saved)
	_update_hud()
	await get_tree().create_timer(1.0).timeout
	feedback_label.visible = false
	ball.reset_position()
	goalkeeper.reset_position()
	await get_tree().create_timer(0.4).timeout
	if GameManager.is_round_complete():
		_show_round_result()
	else:
		_begin_aiming_phase()

func _show_round_result() -> void:
	result_popup.visible = true
	secondary_button.visible = false
	if GameManager.did_advance():
		if GameManager.is_tournament_complete():
			result_label.text = "Turnuvayi kazandin!\n" + str(GameManager.goals_scored) + " / " + str(GameManager.kicks_per_round) + " gol"
			primary_button.text = "Ana Menu"
			primary_button.pressed.connect(_go_to_main_menu, CONNECT_ONE_SHOT)
		else:
			result_label.text = "Turu gectin!\n" + str(GameManager.goals_scored) + " / " + str(GameManager.kicks_per_round) + " gol"
			primary_button.text = "Sonraki Tur"
			primary_button.pressed.connect(_go_to_next_round, CONNECT_ONE_SHOT)
	else:
		result_label.text = "Turu gecemedin.\n" + str(GameManager.goals_scored) + " / " + str(GameManager.kicks_per_round) + " gol"
		primary_button.text = "Tekrar Dene"
		primary_button.pressed.connect(_retry_round, CONNECT_ONE_SHOT)
		secondary_button.visible = true
		secondary_button.text = "Ana Menu"
		secondary_button.pressed.connect(_go_to_main_menu, CONNECT_ONE_SHOT)

func _go_to_next_round() -> void:
	GameManager.advance_round()
	get_tree().reload_current_scene()

func _retry_round() -> void:
	GameManager.reset_round()
	get_tree().reload_current_scene()

func _go_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
